import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../features/authentication/domain/entities/user.dart';
import '../../features/authentication/data/models/user_model.dart';

class AdminAuthService {
  static const String _adminEmail = 'admin@gmail.com';
  static const String _adminPassword = '123456';

  // Check if credentials match admin credentials
  static bool isAdminCredentials(String email, String password) {
    return email.trim().toLowerCase() == _adminEmail.toLowerCase() && 
           password == _adminPassword;
  }

  // Create admin user object
  static User createAdminUser({required String uid}) {
    return UserModel.admin(
      id: uid,
      email: _adminEmail,
      firstName: 'System',
      lastName: 'Administrator',
    );
  }

  // Check if current Firebase user is admin
  static bool isCurrentUserAdmin(firebase_auth.User? firebaseUser) {
    if (firebaseUser == null) return false;
    return firebaseUser.email?.toLowerCase() == _adminEmail.toLowerCase();
  }

  // Authenticate admin and create Firebase user if doesn't exist
  static Future<firebase_auth.UserCredential> authenticateAdmin(
    String email,
    String password,
    firebase_auth.FirebaseAuth firebaseAuth,
  ) async {
    if (!isAdminCredentials(email, password)) {
      throw firebase_auth.FirebaseAuthException(
        code: 'invalid-admin-credentials',
        message: 'Invalid admin credentials',
      );
    }

    try {
      // Try to sign in with existing admin account
      return await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // Create admin account if it doesn't exist
        try {
          return await firebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
        } catch (createError) {
          rethrow;
        }
      } else {
        rethrow;
      }
    }
  }
}
