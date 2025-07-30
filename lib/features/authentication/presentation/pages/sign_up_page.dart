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

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _locationController = TextEditingController();

  final _fullNameFocus = FocusNode();
  final _phoneNumberFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _locationFocus = FocusNode();

  bool _acceptedTerms = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _locationController.dispose();
    
    _fullNameFocus.dispose();
    _phoneNumberFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _locationFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: AppStrings.createAccount,
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
                const SizedBox(height: AppDimensions.paddingL),
                
                // Full Name field
                CustomTextField(
                  label: AppStrings.fullName,
                  hintText: AppStrings.enterFullName,
                  controller: _fullNameController,
                  focusNode: _fullNameFocus,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    color: AppColors.textSecondary,
                    size: AppDimensions.iconM,
                  ),
                  validator: Validators.validateFullName,
                  onChanged: (_) => _clearErrorIfNeeded(),
                ),
                
                const SizedBox(height: AppDimensions.formFieldSpacing),
                
                // Phone Number field
                PhoneTextField(
                  label: AppStrings.phoneNumber,
                  hintText: AppStrings.enterPhoneNumber,
                  controller: _phoneNumberController,
                  focusNode: _phoneNumberFocus,
                  textInputAction: TextInputAction.next,
                  validator: Validators.validatePhoneNumber,
                  onChanged: (_) => _clearErrorIfNeeded(),
                ),
                
                const SizedBox(height: AppDimensions.formFieldSpacing),
                
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
                  textInputAction: TextInputAction.next,
                  validator: Validators.validatePassword,
                  onChanged: (_) => _clearErrorIfNeeded(),
                ),
                
                const SizedBox(height: AppDimensions.paddingM),
                
                // Password strength indicator
                _buildPasswordStrengthIndicator(),
                
                const SizedBox(height: AppDimensions.formFieldSpacing),
                
                // Location field (optional)
                CustomTextField(
                  label: AppStrings.location,
                  hintText: AppStrings.enterLocation,
                  controller: _locationController,
                  focusNode: _locationFocus,
                  textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.words,
                  prefixIcon: const Icon(
                    Icons.location_on_outlined,
                    color: AppColors.textSecondary,
                    size: AppDimensions.iconM,
                  ),
                  validator: (value) => null, // Optional field
                  onChanged: (_) => _clearErrorIfNeeded(),
                ),
                
                const SizedBox(height: AppDimensions.paddingL),
                
                // Terms and conditions checkbox
                _buildTermsCheckbox(),
                
                const SizedBox(height: AppDimensions.paddingXL),
                
                // Sign Up button
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return PrimaryButton(
                      text: AppStrings.createAccount,
                      isLoading: state.isLoading,
                      onPressed: _acceptedTerms ? _onSignUpPressed : null,
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
                      onGooglePressed: _onGoogleSignUpPressed,
                      onFacebookPressed: _onFacebookSignUpPressed,
                    );
                  },
                ),
                
                const SizedBox(height: AppDimensions.paddingXL),
                
                // Sign in link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.alreadyHaveAccount.split('Login')[0],
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: _navigateToSignIn,
                      child: Text(
                        'Login',
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

  Widget _buildPasswordStrengthIndicator() {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _passwordController,
      builder: (context, value, child) {
        final strength = Validators.getPasswordStrength(value.text);
        final strengthText = Validators.getPasswordStrengthText(strength);
        
        if (value.text.isEmpty) {
          return const SizedBox.shrink();
        }

        Color strengthColor;
        double strengthValue;
        
        switch (strength) {
          case PasswordStrength.weak:
            strengthColor = AppColors.error;
            strengthValue = 0.33;
            break;
          case PasswordStrength.medium:
            strengthColor = AppColors.warning;
            strengthValue = 0.66;
            break;
          case PasswordStrength.strong:
            strengthColor = AppColors.success;
            strengthValue = 1.0;
            break;
          default:
            strengthColor = AppColors.textTertiary;
            strengthValue = 0.0;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '${AppStrings.passwordStrength}: ',
                  style: AppTextStyles.bodySmall,
                ),
                Text(
                  strengthText,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: strengthColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingS),
            LinearProgressIndicator(
              value: strengthValue,
              backgroundColor: AppColors.cardBackground,
              valueColor: AlwaysStoppedAnimation<Color>(strengthColor),
              minHeight: 4,
            ),
          ],
        );
      },
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _acceptedTerms,
          onChanged: (value) {
            setState(() {
              _acceptedTerms = value ?? false;
            });
          },
          activeColor: AppColors.primary,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        const SizedBox(width: AppDimensions.paddingS),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _acceptedTerms = !_acceptedTerms;
              });
            },
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                children: [
                  const TextSpan(text: 'By continuing, you agree to our '),
                  TextSpan(
                    text: 'Terms of Service',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleAuthStateChange(BuildContext context, AuthState state) {
    if (state is AuthAuthenticated) {
      // Navigate to phone verification if phone not verified
      if (!state.user.isPhoneVerified) {
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

  void _onSignUpPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      
      context.read<AuthBloc>().add(
        SignUpWithEmailEvent(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          fullName: _fullNameController.text.trim(),
          phoneNumber: _phoneNumberController.text.trim(),
          location: _locationController.text.trim().isEmpty 
              ? null 
              : _locationController.text.trim(),
        ),
      );
    }
  }

  void _onGoogleSignUpPressed() {
    context.read<AuthBloc>().add(SignInWithGoogleEvent());
  }

  void _onFacebookSignUpPressed() {
    context.read<AuthBloc>().add(SignInWithFacebookEvent());
  }

  void _navigateToSignIn() {
    AppRouter.pushReplacementNamed(context, AppRouter.signIn);
  }

  void _clearErrorIfNeeded() {
    final currentState = context.read<AuthBloc>().state;
    if (currentState.hasError) {
      context.read<AuthBloc>().add(ClearAuthErrorEvent());
    }
  }
}