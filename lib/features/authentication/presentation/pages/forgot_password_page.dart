import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../config/routes/app_router.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _emailFocus = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Reset Password',
        showBackButton: true,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: _handleAuthStateChange,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppDimensions.paddingXL),
                
                // Reset password icon
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_reset,
                      size: AppDimensions.iconXXL,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                
                const SizedBox(height: AppDimensions.paddingXL),
                
                // Title
                Text(
                  'Forgot Password?',
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: AppDimensions.paddingM),
                
                // Description
                Text(
                  'Don\'t worry! Enter your email address and we\'ll send you a link to reset your password.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: AppDimensions.sectionSpacingL),
                
                // Email field
                EmailTextField(
                  label: 'Email Address',
                  hintText: 'Enter your email address',
                  controller: _emailController,
                  focusNode: _emailFocus,
                  textInputAction: TextInputAction.done,
                  validator: Validators.validateEmail,
                  onChanged: (_) => _clearErrorIfNeeded(),
                ),
                
                const SizedBox(height: AppDimensions.paddingXL),
                
                // Send Reset Link button
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return PrimaryButton(
                      text: 'Send Reset Link',
                      isLoading: state is PasswordResetLoading,
                      onPressed: _onSendResetLinkPressed,
                    );
                  },
                ),
                
                const SizedBox(height: AppDimensions.paddingL),
                
                // Error message
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is PasswordResetError) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppDimensions.paddingL),
                        child: Text(
                          state.message,
                          style: AppTextStyles.errorText,
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                
                const SizedBox(height: AppDimensions.paddingXL),
                
                // Back to Sign In link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Remember your password? ',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: _navigateToSignIn,
                      child: Text(
                        'Sign In',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppDimensions.sectionSpacingL),
                
                // Help section
                Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingL),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    border: Border.all(
                      color: AppColors.border,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.help_outline,
                        color: AppColors.primary,
                        size: AppDimensions.iconL,
                      ),
                      const SizedBox(height: AppDimensions.paddingS),
                      Text(
                        'Need Help?',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingS),
                      Text(
                        'If you don\'t receive the reset email within a few minutes, please check your spam folder or contact our support team.',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleAuthStateChange(BuildContext context, AuthState state) {
    if (state is PasswordResetSent) {
      // Show success dialog
      _showSuccessDialog(context, state.email);
    } else if (state is PasswordResetError) {
      ErrorSnackBar.show(context, state.message);
    }
  }

  void _onSendResetLinkPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      
      context.read<AuthBloc>().add(
        SendPasswordResetEvent(
          email: _emailController.text.trim(),
        ),
      );
    }
  }

  void _navigateToSignIn() {
    AppRouter.pushReplacementNamed(context, AppRouter.signIn);
  }

  void _clearErrorIfNeeded() {
    final currentState = context.read<AuthBloc>().state;
    if (currentState is PasswordResetError) {
      context.read<AuthBloc>().add(ClearAuthErrorEvent());
    }
  }

  void _showSuccessDialog(BuildContext context, String email) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.dialogRadius),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline,
                size: AppDimensions.iconXXL,
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingL),
            Text(
              'Reset Link Sent!',
              style: AppTextStyles.h5.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.paddingM),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                children: [
                  const TextSpan(text: 'We\'ve sent a password reset link to '),
                  TextSpan(
                    text: email,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(text: '. Please check your email and follow the instructions to reset your password.'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          PrimaryButton(
            text: 'Got it',
            onPressed: () {
              Navigator.of(context).pop();
              _navigateToSignIn();
            },
          ),
        ],
      ),
    );
  }
}