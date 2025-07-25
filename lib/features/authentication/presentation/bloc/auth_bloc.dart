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
      // Configure GoogleSignIn with proper client ID for web
      return GoogleSignIn(
        clientId: kIsWeb 
            ? '55226443629-d045htpnqdd7k3r8bh4v8ig9g7qaqmeq.apps.googleusercontent.com'  
            : null, // For mobile, use the one from google-services.json
        scopes: [
          'email',
          'profile',
        ],
      );
    } catch (e) {
      print('Google Sign-In initialization error: $e');
      // Return a GoogleSignIn instance that will handle errors gracefully
      return GoogleSignIn(
        clientId: kIsWeb 
            ? '55226443629-d045htpnqdd7k3r8bh4v8ig9g7qaqmeq.apps.googleusercontent.com'  
            : null,
        scopes: ['email', 'profile'],
      );
    }
  }

  void _onAuthStarted(AuthStarted event, Emitter<AuthState> emit) {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      // Check if current user is admin
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
  }

  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      UserCredential credential;
      app_user.User? appUser;

      // Check if this is admin login
      if (AdminAuthService.isAdminCredentials(event.email, event.password)) {
        credential = await AdminAuthService.authenticateAdmin(
          event.email,
          event.password,
          _firebaseAuth,
        );
        // Create admin user object
        appUser = AdminAuthService.createAdminUser(uid: credential.user!.uid);
      } else {
        // Regular user login
        credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: event.email.trim(),
          password: event.password,
        );
      }

      if (credential.user != null) {
        emit(AuthAuthenticated(
          firebaseUser: credential.user!,
          appUser: appUser,
        ));
      } else {
        emit(const AuthError(message: 'Sign in failed'));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: _getErrorMessage(e.code)));
    } catch (e) {
      emit(AuthError(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<void> _onSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: event.email.trim(),
        password: event.password,
      );

      if (credential.user != null) {
        // Update user profile with display name
        await credential.user!.updateDisplayName(
          '${event.firstName} ${event.lastName}',
        );
        emit(AuthAuthenticated(
          firebaseUser: credential.user!,
          appUser: null, // Regular user, role will be determined later
        ));
      } else {
        emit(const AuthError(message: 'Sign up failed'));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: _getErrorMessage(e.code)));
    } catch (e) {
      emit(AuthError(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _firebaseAuth.signOut();
      try {
        await _googleSignIn.signOut();
      } catch (e) {
        print('Google Sign-Out error (non-critical): $e');
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
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        emit(AuthUnauthenticated());
        return;
      }

      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = 
          await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user != null) {
        emit(AuthAuthenticated(
          firebaseUser: userCredential.user!,
          appUser: null, // Regular user from Google sign-in
        ));
      } else {
        emit(const AuthError(message: 'Google sign in failed'));
      }
    } catch (e) {
      print('Google Sign-In error: $e');
      // For web, if Google Sign-In fails, just go to unauthenticated state
      // rather than crashing the app
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onForgotPasswordRequested(
    AuthForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: event.email.trim());
      // You might want to emit a success state here
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
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
