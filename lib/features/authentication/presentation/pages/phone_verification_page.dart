import 'dart:async';
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

class PhoneVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  const PhoneVerificationPage({
    Key? key,
    required this.phoneNumber,
    required this.verificationId,
  }) : super(key: key);

  @override
  State<PhoneVerificationPage> createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  String _otpCode = '';
  Timer? _resendTimer;
  int _resendCountdown = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _canResend = false;
    _resendCountdown = 60;
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendCountdown > 0) {
          _resendCountdown--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: AppStrings.enterCode,
        showBackButton: true,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: _handleAuthStateChange,
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppDimensions.paddingXL),
              
              // Verification icon
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.sms_outlined,
                    size: AppDimensions.iconXXL,
                    color: AppColors.primary,
                  ),
                ),
              ),
              
              const SizedBox(height: AppDimensions.paddingXL),
              
              // Title
              Text(
                AppStrings.verifyPhone,
                style: AppTextStyles.h4.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppDimensions.paddingM),
              
              // Phone number display
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  children: [
                    const TextSpan(text: 'We sent a 4-digit code to '),
                    TextSpan(
                      text: widget.phoneNumber,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppDimensions.sectionSpacingL),
              
              // OTP input
              OTPInputWidget(
                fieldCount: 4,
                onCompleted: (code) {
                  _otpCode = code;
                  _onVerifyPressed();
                },
                onChanged: (code) {
                  _otpCode = code;
                },
              ),
              
              const SizedBox(height: AppDimensions.paddingXL),
              
              // Verify button
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return PrimaryButton(
                    text: AppStrings.verify,
                    isLoading: state is PhoneVerificationLoading,
                    onPressed: _otpCode.length == 4 ? _onVerifyPressed : null,
                  );
                },
              ),
              
              const SizedBox(height: AppDimensions.paddingL),
              
              // Error message
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is PhoneVerificationError) {
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
              
              // Resend code section
              _buildResendSection(),
              
              const Spacer(),
              
              // Help text
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingL),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppColors.primary,
                      size: AppDimensions.iconL,
                    ),
                    const SizedBox(height: AppDimensions.paddingS),
                    Text(
                      'Didn\'t receive the code?\nCheck your SMS messages or try resending.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppDimensions.paddingL),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResendSection() {
    return Center(
      child: Column(
        children: [
          if (!_canResend) ...[
            Text(
              'Resend code in ${_resendCountdown}s',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Didn\'t receive the code? ',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: state is PhoneVerificationLoading ? null : _onResendPressed,
                      child: Text(
                        AppStrings.resendCode,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: state is PhoneVerificationLoading 
                              ? AppColors.textTertiary 
                              : AppColors.primary,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _handleAuthStateChange(BuildContext context, AuthState state) {
    if (state is PhoneVerificationCompleted) {
      // Phone verification successful, navigate to main app
      SuccessSnackBar.show(context, 'Phone number verified successfully!');
      AppRouter.goToHome(context);
    } else if (state is PhoneVerificationSent) {
      // New verification code sent
      SuccessSnackBar.show(context, 'New verification code sent!');
      _startResendTimer();
    } else if (state is PhoneVerificationError) {
      ErrorSnackBar.show(context, state.message);
    }
  }

  void _onVerifyPressed() {
    if (_otpCode.length == 4) {
      context.read<AuthBloc>().add(
        VerifyPhoneNumberEvent(
          verificationId: widget.verificationId,
          otpCode: _otpCode,
        ),
      );
    }
  }

  void _onResendPressed() {
    if (_canResend) {
      context.read<AuthBloc>().add(
        SendPhoneVerificationEvent(
          phoneNumber: widget.phoneNumber,
        ),
      );
    }
  }
}