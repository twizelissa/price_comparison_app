class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() {
    return 'ServerException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
  }
}

class NetworkException implements Exception {
  final String message;

  const NetworkException({
    required this.message,
  });

  @override
  String toString() {
    return 'NetworkException: $message';
  }
}

class CacheException implements Exception {
  final String message;

  const CacheException({
    required this.message,
  });

  @override
  String toString() {
    return 'CacheException: $message';
  }
}

class AuthException implements Exception {
  final String message;
  final String? code;

  const AuthException({
    required this.message,
    this.code,
  });

  @override
  String toString() {
    return 'AuthException: $message${code != null ? ' (Code: $code)' : ''}';
  }
}

class ValidationException implements Exception {
  final String message;
  final Map<String, List<String>>? errors;

  const ValidationException({
    required this.message,
    this.errors,
  });

  @override
  String toString() {
    return 'ValidationException: $message';
  }
}

class TimeoutException implements Exception {
  final String message;

  const TimeoutException({
    required this.message,
  });

  @override
  String toString() {
    return 'TimeoutException: $message';
  }
}

class UnauthorizedException implements Exception {
  final String message;

  const UnauthorizedException({
    required this.message,
  });

  @override
  String toString() {
    return 'UnauthorizedException: $message';
  }
}

class NotFoundException implements Exception {
  final String message;

  const NotFoundException({
    required this.message,
  });

  @override
  String toString() {
    return 'NotFoundException: $message';
  }
}

class LocationException implements Exception {
  final String message;

  const LocationException({
    required this.message,
  });

  @override
  String toString() {
    return 'LocationException: $message';
  }
}

class ImagePickerException implements Exception {
  final String message;

  const ImagePickerException({
    required this.message,
  });

  @override
  String toString() {
    return 'ImagePickerException: $message';
  }
}

class StorageException implements Exception {
  final String message;

  const StorageException({
    required this.message,
  });

  @override
  String toString() {
    return 'StorageException: $message';
  }
}
