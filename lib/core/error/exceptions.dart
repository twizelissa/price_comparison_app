class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

class CacheException implements Exception {
  final String message;

  const CacheException({required this.message});

  @override
  String toString() => 'CacheException: $message';
}

class NetworkException implements Exception {
  final String message;

  const NetworkException({required this.message});

  @override
  String toString() => 'NetworkException: $message';
}

class AuthException implements Exception {
  final String message;
  final String? code;

  const AuthException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'AuthException: $message (Code: $code)';
}

class ValidationException implements Exception {
  final String message;
  final Map<String, String>? fieldErrors;

  const ValidationException({
    required this.message,
    this.fieldErrors,
  });

  @override
  String toString() => 'ValidationException: $message';
}

class FirebaseException implements Exception {
  final String message;
  final String? code;

  const FirebaseException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'FirebaseException: $message (Code: $code)';
}

class LocationException implements Exception {
  final String message;

  const LocationException({required this.message});

  @override
  String toString() => 'LocationException: $message';
}

class ImagePickerException implements Exception {
  final String message;

  const ImagePickerException({required this.message});

  @override
  String toString() => 'ImagePickerException: $message';
}

class PermissionException implements Exception {
  final String message;
  final String? permission;

  const PermissionException({
    required this.message,
    this.permission,
  });

  @override
  String toString() => 'PermissionException: $message (Permission: $permission)';
}

class ParseException implements Exception {
  final String message;

  const ParseException({required this.message});

  @override
  String toString() => 'ParseException: $message';
}