import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';

class SocialLoginButtons extends StatelessWidget {
  final VoidCallback? onGooglePressed;
  final VoidCallback? onFacebookPressed;
  final bool isLoading;

  const SocialLoginButtons({
    Key? key,
    this.onGooglePressed,
    this.onFacebookPressed,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          AppStrings.orSignInWith,
          style: AppTextStyles.bodySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.paddingL),
        Row(
          children: [
            Expanded(
              child: _SocialLoginButton(
                text: 'Google',
                icon: Icons.g_mobiledata, // In real app, use Google logo
                backgroundColor: AppColors.google,
                onPressed: isLoading ? null : onGooglePressed,
              ),
            ),
            const SizedBox(width: AppDimensions.paddingL),
            Expanded(
              child: _SocialLoginButton(
                text: 'Facebook',
                icon: Icons.facebook, // In real app, use Facebook logo
                backgroundColor: AppColors.facebook,
                onPressed: isLoading ? null : onFacebookPressed,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialLoginButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback? onPressed;

  const _SocialLoginButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.backgroundColor,
    this.onPressed,
  }) : super(key: key);

  @override
  State<_SocialLoginButton> createState() => _SocialLoginButtonState();
}

class _SocialLoginButtonState extends State<_SocialLoginButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null) {
      _animationController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              height: AppDimensions.buttonHeightSmall,
              decoration: BoxDecoration(
                color: isEnabled 
                    ? widget.backgroundColor 
                    : widget.backgroundColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
                boxShadow: isEnabled
                    ? [
                        BoxShadow(
                          color: widget.backgroundColor.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onPressed,
                  borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingM,
                      vertical: AppDimensions.paddingS,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          widget.icon,
                          color: Colors.white,
                          size: AppDimensions.iconM,
                        ),
                        const SizedBox(width: AppDimensions.paddingS),
                        Text(
                          widget.text,
                          style: AppTextStyles.buttonMedium.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Individual social login buttons
class GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool fullWidth;

  const GoogleSignInButton({
    Key? key,
    this.onPressed,
    this.isLoading = false,
    this.fullWidth = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: AppDimensions.buttonHeight,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Icon(
                Icons.g_mobiledata, // Replace with Google logo
                color: Colors.white,
                size: AppDimensions.iconL,
              ),
        label: Text(
          'Continue with Google',
          style: AppTextStyles.buttonLarge.copyWith(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.google,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: AppColors.google.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
          ),
        ),
      ),
    );
  }
}

class FacebookSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool fullWidth;

  const FacebookSignInButton({
    Key? key,
    this.onPressed,
    this.isLoading = false,
    this.fullWidth = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: AppDimensions.buttonHeight,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Icon(
                Icons.facebook, // Replace with Facebook logo
                color: Colors.white,
                size: AppDimensions.iconL,
              ),
        label: Text(
          'Continue with Facebook',
          style: AppTextStyles.buttonLarge.copyWith(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.facebook,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: AppColors.facebook.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
          ),
        ),
      ),
    );
  }
}

// OR divider widget
class OrDivider extends StatelessWidget {
  final String text;

  const OrDivider({
    Key? key,
    this.text = 'OR',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: AppColors.divider,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
          child: Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ),
        const Expanded(
          child: Divider(
            color: AppColors.divider,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}