import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final firebase_auth.User firebaseUser;
  final User? appUser; // Our custom user with role information

  const AuthAuthenticated({
    required this.firebaseUser,
    this.appUser,
  });

  // Helper to check if user is admin
  bool get isAdmin => appUser?.isAdmin ?? false;

  @override
  List<Object?> get props => [firebaseUser, appUser];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}
