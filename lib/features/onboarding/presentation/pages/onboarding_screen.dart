import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../config/routes/route_names.dart';
import '../../../../core/utils/orientation_builder_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _onboardingData = [
    OnboardingData(
      title: 'Compare Prices',
      description:
          'Find the best prices for your favorite products across multiple stores in Rwanda',
      icon: Icons.compare_arrows,
      color: AppColors.primary,
    ),
    OnboardingData(
      title: 'Save Money',
      description:
          'Save money by finding the lowest prices and best deals in your area',
      icon: Icons.savings_outlined,
      color: Colors.green,
    ),
    OnboardingData(
      title: 'Find Nearby Stores',
      description:
          'Locate stores near you and check their product availability and prices',
      icon: Icons.location_on_outlined,
      color: Colors.orange,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return OrientationBuilderWidget(
      builder: (context, orientation) {
        final isPortrait = orientation == Orientation.portrait;
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;

        // Responsive sizing calculations
        final iconSize = isPortrait ? 200.0 : screenHeight * 0.25;
        final iconInnerSize = isPortrait ? 100.0 : screenHeight * 0.12;
        final titleFontSize = isPortrait ? 32.0 : screenHeight * 0.035;
        final descriptionFontSize = isPortrait ? 16.0 : screenHeight * 0.02;
        final buttonHeight = isPortrait ? 52.0 : screenHeight * 0.06;
        final buttonFontSize = isPortrait ? 18.0 : screenHeight * 0.02;
        final horizontalPadding = isPortrait ? 24.0 : screenWidth * 0.1;
        final verticalSpacing = isPortrait ? 40.0 : screenHeight * 0.03;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                // Skip button (top-right)
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.all(isPortrait ? 16.0 : 8.0),
                    child: TextButton(
                      onPressed: _goToMainApp,
                      child: Text(
                        'Skip',
                        style: AppTextStyles.h6.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: isPortrait ? 16 : 14,
                        ),
                      ),
                    ),
                  ),
                ),

                // Main content area
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: _onboardingData.length,
                    itemBuilder: (context, index) {
                      return _buildOnboardingPage(
                        _onboardingData[index],
                        iconSize,
                        iconInnerSize,
                        titleFontSize,
                        descriptionFontSize,
                        horizontalPadding,
                        verticalSpacing,
                        isPortrait,
                      );
                    },
                  ),
                ),

                // Bottom section with indicators and button
                Column(
                  children: [
                    // Page indicator dots
                    Padding(
                      padding: EdgeInsets.only(bottom: verticalSpacing * 0.5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _onboardingData.length,
                          (index) => _buildPageIndicator(index),
                        ),
                      ),
                    ),

                    // Next/Get Started button
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: verticalSpacing * 0.5,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: buttonHeight,
                        child: ElevatedButton(
                          onPressed: _currentPage == _onboardingData.length - 1
                              ? _goToMainApp
                              : _nextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(buttonHeight / 2),
                            ),
                            elevation: 4,
                          ),
                          child: Text(
                            _currentPage == _onboardingData.length - 1
                                ? 'Get Started'
                                : 'Next',
                            style: AppTextStyles.h5.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: buttonFontSize,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Bottom padding
                    SizedBox(height: verticalSpacing * 0.5),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOnboardingPage(
    OnboardingData data,
    double iconSize,
    double iconInnerSize,
    double titleFontSize,
    double descriptionFontSize,
    double horizontalPadding,
    double verticalSpacing,
    bool isPortrait,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalSpacing * 0.5,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon container
            Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                color: data.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                data.icon,
                size: iconInnerSize,
                color: data.color,
              ),
            ),

            // Title
            Padding(
              padding: EdgeInsets.only(top: verticalSpacing),
              child: Text(
                data.title,
                style: AppTextStyles.h2.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: titleFontSize,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Description
            Padding(
              padding: EdgeInsets.only(
                top: verticalSpacing * 0.4,
                bottom: verticalSpacing,
                left: isPortrait ? 0 : horizontalPadding * 0.5,
                right: isPortrait ? 0 : horizontalPadding * 0.5,
              ),
              child: Text(
                data.description,
                style: AppTextStyles.h5.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                  fontSize: descriptionFontSize,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: _currentPage == index ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? AppColors.primary
            : AppColors.primary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToMainApp() {
    Navigator.pushReplacementNamed(context, RouteNames.mainNavigation);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}