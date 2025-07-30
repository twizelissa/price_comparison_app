import 'package:flutter/material.dart';
import 'route_names.dart';

// Import all the pages we have
import '../../features/splash/presentation/pages/splash_screen.dart';
import '../../features/onboarding/presentation/pages/onboarding_screen.dart';
import '../../features/authentication/presentation/pages/sign_in_screen.dart';
import '../../features/main_navigation/presentation/pages/main_navigation_screen.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Authentication Routes
      case RouteNames.splash:
        return _buildRoute(const SplashScreen());
        
      case RouteNames.onboarding:
        return _buildRoute(const OnboardingScreen());
        
      case RouteNames.signIn:
        return _buildRoute(const SignInScreen());
        
      // Main App Routes
      case RouteNames.mainNavigation:
        return _buildRoute(const MainNavigationScreen());
        
      // Default route
      default:
        return _buildRoute(
          Scaffold(
            appBar: AppBar(title: const Text('Page Not Found')),
            body: const Center(
              child: Text('Page not found'),
            ),
          ),
        );
    }
  }

  static PageRoute<dynamic> _buildRoute(Widget page) {
    return MaterialPageRoute(builder: (_) => page);
  }
}
