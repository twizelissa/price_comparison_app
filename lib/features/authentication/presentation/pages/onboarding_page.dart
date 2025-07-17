import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../config/routes/app_router.dart';
import '../widgets/custom_button.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () => _navigateToSignIn(context),
                  child: Text(
                    'Skip',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              
              // Main content
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Illustration
                    _buildIllustration(),
                    
                    const SizedBox(height: AppDimensions.sectionSpacingL),
                    
                    // Title
                    Text(
                      AppStrings.onboardingTitle,
                      style: AppTextStyles.h2.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: AppDimensions.paddingL),
                    
                    // Subtitle
                    Text(
                      AppStrings.onboardingSubtitle,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: AppDimensions.paddingL),
                    
                    // Community powered badge
                    _buildCommunityBadge(),
                  ],
                ),
              ),
              
              // Get Started button
              PrimaryButton(
                text: AppStrings.getStarted,
                onPressed: () => _navigateToSignUp(context),
              ),
              
              const SizedBox(height: AppDimensions.paddingL),
              
              // Sign in link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _navigateToSignIn(context),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
      ),
      child: Stack(
        children: [
          // Market stalls illustration (simplified)
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.3),
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMarketStall(Colors.orange.withOpacity(0.6)),
                  _buildMarketStall(Colors.green.withOpacity(0.6)),
                  _buildMarketStall(Colors.brown.withOpacity(0.6)),
                ],
              ),
            ),
          ),
          
          // People illustrations (simplified)
          Positioned(
            bottom: 60,
            left: 30,
            child: _buildPersonIcon(AppColors.primary),
          ),
          Positioned(
            bottom: 40,
            left: 80,
            child: _buildPersonIcon(Colors.orange),
          ),
          Positioned(
            bottom: 70,
            right: 60,
            child: _buildPersonIcon(Colors.green),
          ),
          Positioned(
            bottom: 50,
            right: 30,
            child: _buildPersonIcon(Colors.purple),
          ),
          
          // Umbrellas/covering
          Positioned(
            top: 20,
            left: 30,
            child: Container(
              width: 80,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.7),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 30,
            child: Container(
              width: 80,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.7),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketStall(Color color) {
    return Container(
      width: 50,
      height: 80,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 40,
            height: 15,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 35,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildPersonIcon(Color color) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: const Icon(
        Icons.person,
        size: 12,
        color: Colors.white,
      ),
    );
  }

  Widget _buildCommunityBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingL,
        vertical: AppDimensions.paddingM,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            AppStrings.communityPowered,
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXS),
          Text(
            AppStrings.realTimePrices,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _navigateToSignUp(BuildContext context) {
    AppRouter.pushNamed(context, AppRouter.signUp);
  }

  void _navigateToSignIn(BuildContext context) {
    AppRouter.pushNamed(context, AppRouter.signIn);
  }
}