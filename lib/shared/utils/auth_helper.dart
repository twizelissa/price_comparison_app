import 'package:firebase_auth/firebase_auth.dart';
import 'admin_auth_service.dart';

class AuthHelper {
  static const String adminEmail = 'admin@gmail.com';
  
  static bool get isLoggedIn => FirebaseAuth.instance.currentUser != null;
  
  static String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;
  
  static String? get currentUserEmail => FirebaseAuth.instance.currentUser?.email;
  
  static bool get isAdmin => AdminAuthService.isCurrentUserAdmin(FirebaseAuth.instance.currentUser);
  
  static String get currentUserDisplayName {
    final user = FirebaseAuth.instance.currentUser;
    if (user?.displayName?.isNotEmpty == true) {
      return user!.displayName!;
    }
    if (user?.email?.isNotEmpty == true) {
      return user!.email!.split('@').first;
    }
    return 'Anonymous User';
  }
  
  static bool canEditProduct(String? productUserId) {
    if (!isLoggedIn) return false;
    if (isAdmin) return true; // Admin can edit any product
    return currentUserId == productUserId; // Regular users can only edit their own products
  }
}
