import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  // Authentication methods
  Future<Either<Failure, User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    String? location,
  });

  Future<Either<Failure, User>> signInWithGoogle();

  Future<Either<Failure, User>> signInWithFacebook();

  Future<Either<Failure, void>> signOut();

  // Phone verification
  Future<Either<Failure, String>> sendPhoneVerification({
    required String phoneNumber,
  });

  Future<Either<Failure, User>> verifyPhoneNumber({
    required String verificationId,
    required String otpCode,
  });

  // Password management
  Future<Either<Failure, void>> sendPasswordResetEmail({
    required String email,
  });

  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  });

  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  // User state
  Future<Either<Failure, User?>> getCurrentUser();
  
  Stream<User?> get authStateChanges;

  Future<Either<Failure, bool>> isSignedIn();

  // Email verification
  Future<Either<Failure, void>> sendEmailVerification();

  Future<Either<Failure, void>> verifyEmail({
    required String token,
  });

  // Profile management
  Future<Either<Failure, User>> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? location,
    String? profileImageUrl,
  });

  Future<Either<Failure, String>> uploadProfileImage({
    required String imagePath,
  });

  // Account management
  Future<Either<Failure, void>> deleteAccount();

  Future<Either<Failure, void>> deactivateAccount();

  Future<Either<Failure, void>> reactivateAccount();

  // Session management
  Future<Either<Failure, void>> refreshAuthToken();

  Future<Either<Failure, void>> invalidateAllSessions();
}