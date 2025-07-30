import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({
    required this.message,
    this.statusCode,
  });

  @override
  List<Object?> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.statusCode,
  });
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

class AuthFailure extends Failure {
  final String? code;

  const AuthFailure({
    required super.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;

  const ValidationFailure({
    required super.message,
    this.fieldErrors,
  });

  @override
  List<Object?> get props => [message, fieldErrors];
}

class FirebaseFailure extends Failure {
  final String? code;

  const FirebaseFailure({
    required super.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

class LocationFailure extends Failure {
  const LocationFailure({required super.message});
}

class ImagePickerFailure extends Failure {
  const ImagePickerFailure({required super.message});
}

class PermissionFailure extends Failure {
  final String? permission;

  const PermissionFailure({
    required super.message,
    this.permission,
  });

  @override
  List<Object?> get props => [message, permission];
}

class ParseFailure extends Failure {
  const ParseFailure({required super.message});
}

// Common failure messages
class FailureMessages {
  static const String serverError = 'Server error occurred';
  static const String networkError = 'Please check your internet connection';
  static const String cacheError = 'Failed to load cached data';
  static const String authError = 'Authentication failed';
  static const String validationError = 'Please check your input';
  static const String unknownError = 'An unknown error occurred';
  static const String locationError = 'Failed to get location';
  static const String permissionError = 'Permission denied';
  static const String imagePickerError = 'Failed to pick image';
  static const String parseError = 'Failed to parse data';
  
  // Auth specific
  static const String userNotFound = 'User not found';
  static const String wrongPassword = 'Wrong password';
  static const String emailAlreadyInUse = 'Email already in use';
  static const String weakPassword = 'Password is too weak';
  static const String invalidEmail = 'Invalid email address';
  static const String userDisabled = 'User account has been disabled';
  static const String tooManyRequests = 'Too many requests. Please try again later';
  static const String operationNotAllowed = 'Operation not allowed';
  static const String invalidCredential = 'Invalid credentials';
  static const String accountExistsWithDifferentCredential = 'Account exists with different credential';
  static const String invalidVerificationCode = 'Invalid verification code';
  static const String invalidPhoneNumber = 'Invalid phone number';
  static const String sessionExpired = 'Session expired. Please login again';
  
  // Network specific
  static const String connectionTimeout = 'Connection timeout';
  static const String receiveTimeout = 'Receive timeout';
  static const String sendTimeout = 'Send timeout';
  static const String badRequest = 'Bad request';
  static const String unauthorized = 'Unauthorized access';
  static const String forbidden = 'Access forbidden';
  static const String notFound = 'Resource not found';
  static const String internalServerError = 'Internal server error';
  static const String serviceUnavailable = 'Service unavailable';
  
  // Validation specific
  static const String requiredField = 'This field is required';
  static const String invalidFormat = 'Invalid format';
  static const String passwordTooShort = 'Password must be at least 6 characters';
  static const String passwordsDoNotMatch = 'Passwords do not match';
  static const String invalidPhoneFormat = 'Invalid phone number format';
  static const String invalidPriceFormat = 'Invalid price format';
  
  // Location specific
  static const String locationPermissionDenied = 'Location permission denied';
  static const String locationServiceDisabled = 'Location service disabled';
  static const String locationTimeout = 'Location request timeout';
  
  // Image picker specific
  static const String cameraPermissionDenied = 'Camera permission denied';
  static const String galleryPermissionDenied = 'Gallery permission denied';
  static const String imagePickCancelled = 'Image selection cancelled';
  static const String imageTooLarge = 'Selected image is too large';
  
  // Firebase specific
  static const String firebaseNotInitialized = 'Firebase not initialized';
  static const String documentNotFound = 'Document not found';
  static const String permissionDenied = 'Permission denied';
  static const String unavailable = 'Service unavailable';
  static const String dataLoss = 'Data loss occurred';
}