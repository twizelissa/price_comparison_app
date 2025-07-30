import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    String? location,
  });

  Future<UserModel> signInWithGoogle();

  Future<UserModel> signInWithFacebook();

  Future<void> signOut();

  Future<String> sendPhoneVerification({
    required String phoneNumber,
  });

  Future<UserModel> verifyPhoneNumber({
    required String verificationId,
    required String otpCode,
  });

  Future<void> sendPasswordResetEmail({
    required String email,
  });

  Future<UserModel?> getCurrentUser();

  Stream<UserModel?> get authStateChanges;

  Future<bool> isSignedIn();

  Future<void> sendEmailVerification();

  Future<UserModel> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? location,
    String? profileImageUrl,
  });

  Future<void> deleteAccount();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final GoogleSignIn googleSignIn;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
    GoogleSignIn? googleSignIn,
  }) : googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw const AuthException(message: 'Failed to sign in');
      }

      return await _getUserFromFirestore(credential.user!.uid);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(
        message: _getAuthErrorMessage(e.code),
        code: e.code,
      );
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    String? location,
  }) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw const AuthException(message: 'Failed to create account');
      }

      // Update display name
      await credential.user!.updateDisplayName(fullName);

      // Create user document in Firestore
      final userModel = UserModel.fromFirebaseUser(
        credential.user!,
        fullName: fullName,
        phoneNumber: phoneNumber,
        location: location,
      );

      await _createUserInFirestore(userModel);

      return userModel;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(
        message: _getAuthErrorMessage(e.code),
        code: e.code,
      );
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      
      if (googleUser == null) {
        throw const AuthException(message: 'Google sign in cancelled');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await firebaseAuth.signInWithCredential(credential);

      if (userCredential.user == null) {
        throw const AuthException(message: 'Failed to sign in with Google');
      }

      // Check if user exists in Firestore, if not create them
      UserModel userModel;
      try {
        userModel = await _getUserFromFirestore(userCredential.user!.uid);
      } catch (e) {
        // User doesn't exist, create them
        userModel = UserModel.fromFirebaseUser(userCredential.user!);
        await _createUserInFirestore(userModel);
      }

      return userModel;
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(message: 'Failed to sign in with Google: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> signInWithFacebook() async {
    // Facebook sign-in would be implemented here
    // For now, throw not implemented
    throw const AuthException(message: 'Facebook sign-in not implemented yet');
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([
        firebaseAuth.signOut(),
        googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw AuthException(message: 'Failed to sign out: ${e.toString()}');
    }
  }

  @override
  Future<String> sendPhoneVerification({
    required String phoneNumber,
  }) async {
    try {
      String verificationId = '';
      
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (firebase_auth.PhoneAuthCredential credential) async {
          // Auto-verification completed
          await firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (firebase_auth.FirebaseAuthException e) {
          throw AuthException(
            message: _getAuthErrorMessage(e.code),
            code: e.code,
          );
        },
        codeSent: (String verId, int? resendToken) {
          verificationId = verId;
        },
        codeAutoRetrievalTimeout: (String verId) {
          verificationId = verId;
        },
        timeout: const Duration(seconds: 60),
      );

      // Wait a bit for the verification ID to be set
      await Future.delayed(const Duration(seconds: 1));
      
      if (verificationId.isEmpty) {
        throw const AuthException(message: 'Failed to send verification code');
      }

      return verificationId;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(
        message: _getAuthErrorMessage(e.code),
        code: e.code,
      );
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(message: 'Failed to send phone verification: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> verifyPhoneNumber({
    required String verificationId,
    required String otpCode,
  }) async {
    try {
      final credential = firebase_auth.PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpCode,
      );

      final userCredential = await firebaseAuth.signInWithCredential(credential);

      if (userCredential.user == null) {
        throw const AuthException(message: 'Failed to verify phone number');
      }

      // Update user in Firestore to mark phone as verified
      await _updateUserInFirestore(userCredential.user!.uid, {
        'isPhoneVerified': true,
        'phoneNumber': userCredential.user!.phoneNumber,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return await _getUserFromFirestore(userCredential.user!.uid);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(
        message: _getAuthErrorMessage(e.code),
        code: e.code,
      );
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(message: 'Failed to verify phone number: ${e.toString()}');
    }
  }

  @override
  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(
        message: _getAuthErrorMessage(e.code),
        code: e.code,
      );
    } catch (e) {
      throw AuthException(message: 'Failed to send password reset email: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final firebaseUser = firebaseAuth.currentUser;
      if (firebaseUser == null) return null;

      return await _getUserFromFirestore(firebaseUser.uid);
    } catch (e) {
      return null;
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      try {
        return await _getUserFromFirestore(firebaseUser.uid);
      } catch (e) {
        return null;
      }
    });
  }

  @override
  Future<bool> isSignedIn() async {
    return firebaseAuth.currentUser != null;
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        throw const AuthException(message: 'No user signed in');
      }

      await user.sendEmailVerification();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(
        message: _getAuthErrorMessage(e.code),
        code: e.code,
      );
    } catch (e) {
      throw AuthException(message: 'Failed to send email verification: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? location,
    String? profileImageUrl,
  }) async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        throw const AuthException(message: 'No user signed in');
      }

      // Update Firebase Auth profile
      if (fullName != null || profileImageUrl != null) {
        await user.updateProfile(
          displayName: fullName,
          photoURL: profileImageUrl,
        );
      }

      // Update Firestore document
      final updateData = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (fullName != null) updateData['fullName'] = fullName;
      if (phoneNumber != null) updateData['phoneNumber'] = phoneNumber;
      if (location != null) updateData['location'] = location;
      if (profileImageUrl != null) updateData['profileImageUrl'] = profileImageUrl;

      await _updateUserInFirestore(user.uid, updateData);

      return await _getUserFromFirestore(user.uid);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(message: 'Failed to update profile: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        throw const AuthException(message: 'No user signed in');
      }

      // Delete user document from Firestore
      await firestore.collection('users').doc(user.uid).delete();

      // Delete Firebase Auth account
      await user.delete();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(
        message: _getAuthErrorMessage(e.code),
        code: e.code,
      );
    } catch (e) {
      throw AuthException(message: 'Failed to delete account: ${e.toString()}');
    }
  }

  // Private helper methods
  Future<UserModel> _getUserFromFirestore(String uid) async {
    try {
      final doc = await firestore.collection('users').doc(uid).get();
      
      if (!doc.exists) {
        throw const FirebaseException(message: 'User document not found');
      }

      return UserModel.fromFirestore(doc.data()!, doc.id);
    } catch (e) {
      if (e is FirebaseException) rethrow;
      throw FirebaseException(message: 'Failed to get user from Firestore: ${e.toString()}');
    }
  }

  Future<void> _createUserInFirestore(UserModel user) async {
    try {
      await firestore.collection('users').doc(user.id).set(user.toFirestore());
    } catch (e) {
      throw FirebaseException(message: 'Failed to create user in Firestore: ${e.toString()}');
    }
  }

  Future<void> _updateUserInFirestore(String uid, Map<String, dynamic> data) async {
    try {
      await firestore.collection('users').doc(uid).update(data);
    } catch (e) {
      throw FirebaseException(message: 'Failed to update user in Firestore: ${e.toString()}');
    }
  }

  String _getAuthErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No user found with this email address';
      case 'wrong-password':
        return 'Wrong password provided';
      case 'email-already-in-use':
        return 'An account already exists with this email address';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'This user account has been disabled';
      case 'too-many-requests':
        return 'Too many requests. Please try again later';
      case 'operation-not-allowed':
        return 'Operation not allowed';
      case 'invalid-credential':
        return 'Invalid credentials provided';
      case 'account-exists-with-different-credential':
        return 'Account exists with different credential';
      case 'invalid-verification-code':
        return 'Invalid verification code';
      case 'invalid-verification-id':
        return 'Invalid verification ID';
      case 'credential-already-in-use':
        return 'This credential is already associated with a different user account';
      case 'invalid-phone-number':
        return 'Invalid phone number';
      case 'missing-phone-number':
        return 'Phone number is required';
      case 'quota-exceeded':
        return 'SMS quota exceeded';
      case 'captcha-check-failed':
        return 'reCAPTCHA verification failed';
      case 'missing-client-identifier':
        return 'Missing client identifier';
      case 'network-request-failed':
        return 'Network error occurred. Please check your connection';
      case 'requires-recent-login':
        return 'This operation requires recent authentication. Please sign in again';
      default:
        return 'Authentication failed. Please try again';
    }
  }
}