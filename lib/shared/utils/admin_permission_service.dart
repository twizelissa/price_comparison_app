import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../features/authentication/presentation/bloc/auth_bloc.dart';
import '../../features/authentication/presentation/bloc/auth_state.dart';

class AdminPermissionService {
  /// Check if current user has admin permissions
  static bool isCurrentUserAdmin(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      return authState.isAdmin;
    }
    return false;
  }

  /// Check if current user is authenticated
  static bool isUserAuthenticated(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    return authState is AuthAuthenticated;
  }

  /// Get current Firebase user
  static firebase_auth.User? getCurrentFirebaseUser(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      return authState.firebaseUser;
    }
    return null;
  }

  /// Show admin required dialog
  static void showAdminRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Admin Access Required'),
        content: const Text(
          'This action requires administrator privileges. Please login with admin credentials.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Show login required dialog
  static void showLoginRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Required'),
        content: const Text(
          'Please login to perform this action.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/sign-in');
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
