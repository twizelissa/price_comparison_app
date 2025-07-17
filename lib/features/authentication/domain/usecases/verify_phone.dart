import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SendPhoneVerification implements UseCase<String, SendPhoneVerificationParams> {
  final AuthRepository repository;

  SendPhoneVerification(this.repository);

  @override
  Future<Either<Failure, String>> call(SendPhoneVerificationParams params) async {
    return await repository.sendPhoneVerification(
      phoneNumber: params.phoneNumber,
    );
  }
}

class SendPhoneVerificationParams extends Equatable {
  final String phoneNumber;

  const SendPhoneVerificationParams({
    required this.phoneNumber,
  });

  @override
  List<Object> get props => [phoneNumber];
}

class VerifyPhone implements UseCase<User, VerifyPhoneParams> {
  final AuthRepository repository;

  VerifyPhone(this.repository);

  @override
  Future<Either<Failure, User>> call(VerifyPhoneParams params) async {
    return await repository.verifyPhoneNumber(
      verificationId: params.verificationId,
      otpCode: params.otpCode,
    );
  }
}

class VerifyPhoneParams extends Equatable {
  final String verificationId;
  final String otpCode;

  const VerifyPhoneParams({
    required this.verificationId,
    required this.otpCode,
  });

  @override
  List<Object> get props => [verificationId, otpCode];
}