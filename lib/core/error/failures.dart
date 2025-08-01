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
    required String message,
    int? statusCode,
  }) : super(message: message, statusCode: statusCode);
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    required String message,
  }) : super(message: message);
}

class CacheFailure extends Failure {
  const CacheFailure({
    required String message,
  }) : super(message: message);
}

class AuthFailure extends Failure {
  final String? code;

  const AuthFailure({
    required String message,
    this.code,
    int? statusCode,
  }) : super(message: message, statusCode: statusCode);

  @override
  List<Object?> get props => [message, statusCode, code];
}

class ValidationFailure extends Failure {
  final Map<String, List<String>>? errors;

  const ValidationFailure({
    required String message,
    this.errors,
  }) : super(message: message);

  @override
  List<Object?> get props => [message, errors];
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({
    required String message,
  }) : super(message: message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    required String message,
  }) : super(message: message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({
    required String message,
  }) : super(message: message);
}

class LocationFailure extends Failure {
  const LocationFailure({
    required String message,
  }) : super(message: message);
}

class ImagePickerFailure extends Failure {
  const ImagePickerFailure({
    required String message,
  }) : super(message: message);
}

class StorageFailure extends Failure {
  const StorageFailure({
    required String message,
  }) : super(message: message);
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    required String message,
  }) : super(message: message);
}
