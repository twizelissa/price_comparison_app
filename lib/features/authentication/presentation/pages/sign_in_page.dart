import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../../../../config/routes/app_router.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/social_login_buttons.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: AppStrings.signIn,
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
                
                // Welcome back text
                Text(
                  'Welcome back!',
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: AppDimensions.paddingM),
                
                Text(
                  'Sign in to continue to KigaliPriceCheck',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: AppDimensions.sectionSpacingL),
                
                // Email field
                EmailTextField(
                  label: AppStrings.email,
                  hintText: AppStrings.enterEmail,
                  controller: _emailController,
                  focusNode: _emailFocus,
                  textInputAction: TextInputAction.next,
                  validator: Validators.validateEmail,
                  onChanged: (_) => _clearErrorIfNeeded(),
                ),
                
                const SizedBox(height: AppDimensions.formFieldSpacing),
                
                // Password field
                PasswordTextField(
                  label: AppStrings.password,
                  hintText: AppStrings.enterPassword,
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  textInputAction: TextInputAction.done,
                  validator: Validators.validatePassword,
                  onChanged: (_) => _clearErrorIfNeeded(),
                ),
                
                const SizedBox(height: AppDimensions.paddingL),
                
                // Remember me and Forgot password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Remember me checkbox
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                          activeColor: AppColors.primary,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        const SizedBox(width: AppDimensions.paddingS),
                        Text(
                          'Remember me',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                    
                    // Forgot password link
                    GestureDetector(
                      onTap: _navigateToForgotPassword,
                      child: Text(
                        AppStrings.forgotPassword,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppDimensions.paddingXL),
                
                // Sign In button
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return PrimaryButton(
                      text: AppStrings.signIn,
                      isLoading: state.isLoading,
                      onPressed: _onSignInPressed,
                    );
                  },
                ),
                
                const SizedBox(height: AppDimensions.paddingL),
                
                // Error message
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state.hasError) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppDimensions.paddingL),
                        child: Text(
                          state.errorMessage ?? AppStrings.somethingWentWrong,
                          style: AppTextStyles.errorText,
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                
                // OR divider
                const OrDivider(),
                
                const SizedBox(height: AppDimensions.paddingL),
                
                // Social login buttons
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return SocialLoginButtons(
                      isLoading: state.isLoading,
                      onGooglePressed: _onGoogleSignInPressed,
                      onFacebookPressed: _onFacebookSignInPressed,
                    );
                  },
                ),
                
                const SizedBox(height: AppDimensions.paddingXL),
                
                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.dontHaveAccount.split('Sign Up')[0],
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: _navigateToSignUp,
                      child: Text(
                        'Sign Up',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppDimensions.paddingL),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleAuthStateChange(BuildContext context, AuthState state) {
    if (state is AuthAuthenticated) {
      // Check if phone verification is needed
      if (!state.user.isPhoneVerified) {
        // Navigate to phone verification
        AppRouter.goToPhoneVerification(
          context,
          state.user.phoneNumber,
          '', // Will be set during phone verification
        );
      } else {
        // Navigate to main app
        AppRouter.goToHome(context);
      }
    } else if (state is AuthError) {
      ErrorSnackBar.show(context, state.message);
    }
  }

  void _onSignInPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      
      context.read<AuthBloc>().add(
        SignInWithEmailEvent(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  void _onGoogleSignInPressed() {
    context.read<AuthBloc>().add(SignInWithGoogleEvent());
  }

  void _onFacebookSignInPressed() {
    context.read<AuthBloc>().add(SignInWithFacebookEvent());
  }

  void _navigateToSignUp() {
    AppRouter.pushReplacementNamed(context, AppRouter.signUp);
  }

  void _navigateToForgotPassword() {
    AppRouter.pushNamed(context, AppRouter.forgotPassword);
  }

  void _clearErrorIfNeeded() {
    final currentState = context.read<AuthBloc>().state;
    if (currentState.hasError) {
      context.read<AuthBloc>().add(ClearAuthErrorEvent());
    }
  }
}