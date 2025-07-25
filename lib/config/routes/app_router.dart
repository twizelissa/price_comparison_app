import 'package:flutter/material.dart';
import 'package:kigali_price_check/config/routes/route_names.dart';
import 'package:kigali_price_check/features/splash/presentation/pages/splash_screen.dart';
import 'package:kigali_price_check/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:kigali_price_check/features/authentication/presentation/pages/sign_in_screen.dart';
import 'package:kigali_price_check/features/authentication/presentation/pages/sign_up_screen.dart';
import 'package:kigali_price_check/features/authentication/presentation/pages/phone_verification_page.dart';
import 'package:kigali_price_check/features/authentication/presentation/pages/forgot_password_screen.dart';
import 'package:kigali_price_check/features/home/presentation/pages/home_page.dart';
import 'package:kigali_price_check/features/home/presentation/pages/main_navigation_page.dart';
import 'package:kigali_price_check/features/product_details/presentation/pages/product_details_page.dart';
import 'package:kigali_price_check/core/models/product_model.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case RouteNames.onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        );
      case RouteNames.signIn:
        return MaterialPageRoute(
          builder: (_) => const SignInScreen(),
        );
      case RouteNames.signUp:
        return MaterialPageRoute(
          builder: (_) => const SignUpScreen(),
        );
      case RouteNames.phoneVerification:
        return MaterialPageRoute(
          builder: (_) => const PhoneVerificationPage(),
        );
      case RouteNames.forgotPassword:
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordScreen(),
        );
      case RouteNames.home:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
        );
      case RouteNames.mainNavigation:
        return MaterialPageRoute(
          builder: (_) => const MainNavigationPage(),
        );
      case RouteNames.productDetails:
        final product = settings.arguments as Product;
        return MaterialPageRoute(
          builder: (_) => ProductDetailsPage(product: product),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Page not found'),
            ),
          ),
        );
    }
  }
}
