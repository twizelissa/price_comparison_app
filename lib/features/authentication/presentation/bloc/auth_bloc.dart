import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'auth_event.dart';
import 'auth_state.dart';
import '../../../../shared/utils/admin_auth_service.dart';
import '../../domain/entities/user.dart' as app_user;

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthBloc({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? _createSafeGoogleSignIn(),
        super(AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthGoogleSignInRequested>(_onGoogleSignInRequested);
    on<AuthForgotPasswordRequested>(_onForgotPasswordRequested);
  }

  static GoogleSignIn _createSafeGoogleSignIn() {
    try {
      return GoogleSignIn(
        clientId: kIsWeb 
            ? '55226443629-d045htpnqdd7k3r8bh4v8ig9g7qaqmeq.apps.googleusercontent.com'  
            : null,
        scopes: ['email', 'profile'],
      );
    } catch (e) {
      print('Google Sign-In initialization error: $e');
      return GoogleSignIn(
        clientId: kIsWeb 
            ? '55226443629-d045htpnqdd7k3r8bh4v8ig9g7qaqmeq.apps.googleusercontent.com'  
            : null,
        scopes: ['email', 'profile'],
      );
    }
  }

  void _onAuthStarted(AuthStarted event, Emitter<AuthState> emit) async {
    try {
      // Add a small delay to ensure Firebase is fully initialized
      await Future.delayed(const Duration(milliseconds: 100));
      
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        app_user.User? appUser;
        if (AdminAuthService.isCurrentUserAdmin(user)) {
          appUser = AdminAuthService.createAdminUser(uid: user.uid);
        }
        emit(AuthAuthenticated(
          firebaseUser: user,
          appUser: appUser,
        ));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      print('Auth started error: $e');
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      UserCredential credential;
      app_user.User? appUser;

      // Add input validation
      if (event.email.trim().isEmpty || event.password.isEmpty) {
        emit(const AuthError(message: 'Email and password cannot be empty'));
        return;
      }

      // Check if this is admin login
      if (AdminAuthService.isAdminCredentials(event.email, event.password)) {
        credential = await AdminAuthService.authenticateAdmin(
          event.email,
          event.password,
          _firebaseAuth,
        );
        appUser = AdminAuthService.createAdminUser(uid: credential.user!.uid);
      } else {
        // Regular user login with better error handling
        credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: event.email.trim(),
          password: event.password,
        );
      }

      // Ensure user exists before proceeding
      final user = credential.user;
      if (user != null) {
        // Wait for auth state to stabilize
        await Future.delayed(const Duration(milliseconds: 500));
        
        emit(AuthAuthenticated(
          firebaseUser: user,
          appUser: appUser,
        ));
      } else {
        emit(const AuthError(message: 'Authentication failed - no user returned'));
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.code} - ${e.message}');
      emit(AuthError(message: _getErrorMessage(e.code)));
    } catch (e) {
      print('Unexpected auth error: $e');
      // More specific error handling for the cast error
      if (e.toString().contains('PigeonUserDetails')) {
        emit(const AuthError(message: 'Authentication service error. Please restart the app and try again.'));
      } else {
        emit(AuthError(message: 'An unexpected error occurred: ${e.toString()}'));
      }
    }
  }

  Future<void> _onSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // Input validation
      if (event.email.trim().isEmpty || event.password.isEmpty) {
        emit(const AuthError(message: 'Email and password cannot be empty'));
        return;
      }
      
      if (event.firstName.trim().isEmpty || event.lastName.trim().isEmpty) {
        emit(const AuthError(message: 'First name and last name cannot be empty'));
        return;
      }

      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: event.email.trim(),
        password: event.password,
      );

      final user = credential.user;
      if (user != null) {
        try {
          // Update user profile with display name
          await user.updateDisplayName('${event.firstName.trim()} ${event.lastName.trim()}');
          
          // Reload user to get updated info
          await user.reload();
          final updatedUser = _firebaseAuth.currentUser;
          
          // Wait for auth state to stabilize
          await Future.delayed(const Duration(milliseconds: 500));
          
          emit(AuthAuthenticated(
            firebaseUser: updatedUser ?? user,
            appUser: null, // Regular user, role will be determined later
          ));
        } catch (profileError) {
          print('Profile update error: $profileError');
          // Still emit authenticated even if profile update fails
          emit(AuthAuthenticated(
            firebaseUser: user,
            appUser: null,
          ));
        }
      } else {
        emit(const AuthError(message: 'Account creation failed - no user returned'));
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException during signup: ${e.code} - ${e.message}');
      emit(AuthError(message: _getErrorMessage(e.code)));
    } catch (e) {
      print('Unexpected signup error: $e');
      if (e.toString().contains('PigeonUserDetails')) {
        emit(const AuthError(message: 'Account creation service error. Please restart the app and try again.'));
      } else {
        emit(AuthError(message: 'An unexpected error occurred: ${e.toString()}'));
      }
    }
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      // Sign out from Firebase first
      await _firebaseAuth.signOut();
      
      // Then try to sign out from Google (if applicable)
      try {
        if (!kIsWeb) {
          await _googleSignIn.signOut();
        } else {
          // For web, disconnect is usually better
          await _googleSignIn.disconnect();
        }
      } catch (googleSignOutError) {
        print('Google Sign-Out error (non-critical): $googleSignOutError');
        // Don't fail the entire sign-out process for Google sign-out errors
      }
      
      emit(AuthUnauthenticated());
    } catch (e) {
      print('Sign out error: $e');
      // Even if sign out fails, emit unauthenticated to let user retry
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onGoogleSignInRequested(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // Clear any existing sign-in first
      await _googleSignIn.signOut();
      
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // User cancelled the sign-in
        emit(AuthUnauthenticated());
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Ensure we have the required tokens
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        emit(const AuthError(message: 'Google authentication failed - missing tokens'));
        return;
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        // Wait for auth state to stabilize
        await Future.delayed(const Duration(milliseconds: 500));
        
        emit(AuthAuthenticated(
          firebaseUser: user,
          appUser: null, // Regular user from Google sign-in
        ));
      } else {
        emit(const AuthError(message: 'Google sign in failed - no user returned'));
      }
    } catch (e) {
      print('Google Sign-In error: $e');
      
      if (e.toString().contains('PigeonUserDetails')) {
        emit(const AuthError(message: 'Google sign-in service error. Please restart the app and try again.'));
      } else if (e.toString().contains('network')) {
        emit(const AuthError(message: 'Network error. Please check your connection and try again.'));
      } else {
        // For web or other non-critical errors, just go to unauthenticated
        emit(AuthUnauthenticated());
      }
    }
  }

  Future<void> _onForgotPasswordRequested(
    AuthForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      if (event.email.trim().isEmpty) {
        emit(const AuthError(message: 'Email cannot be empty'));
        return;
      }
      
      await _firebaseAuth.sendPasswordResetEmail(email: event.email.trim());
      // Consider emitting a success state here
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: _getErrorMessage(e.code)));
    } catch (e) {
      emit(AuthError(message: 'Failed to send reset email: ${e.toString()}'));
    }
  }

  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      case 'operation-not-allowed':
        return 'Signing in with Email and Password is not enabled.';
      case 'invalid-credential':
        return 'The provided credentials are invalid.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with a different sign-in method.';
      case 'credential-already-in-use':
        return 'This credential is already associated with a different user account.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}