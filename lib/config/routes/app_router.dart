import 'package:flutter/material.dart';
import 'route_names.dart';

// Import all pages
import '../../main.dart'; // SplashScreen
import '../../features/authentication/presentation/pages/onboarding_page.dart';
import '../../features/authentication/presentation/pages/sign_in_page.dart';
import '../../features/authentication/presentation/pages/sign_up_page.dart';
import '../../features/authentication/presentation/pages/phone_verification_page.dart';
import '../../features/authentication/presentation/pages/forgot_password_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/main_navigation_page.dart';
import '../../features/price_comparison/presentation/pages/search_results_page.dart';
import '../../features/price_comparison/presentation/pages/price_comparison_page.dart';
import '../../features/price_comparison/presentation/pages/product_detail_page.dart';
import '../../features/add_price/presentation/pages/add_price_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/profile/presentation/pages/submitted_prices_page.dart';
import '../../features/profile/presentation/pages/saved_products_page.dart';
import '../../features/profile/presentation/pages/notifications_page.dart';
import '../../features/profile/presentation/pages/settings_page.dart';
import '../../shared/widgets/error_page.dart';
import '../../shared/widgets/no_internet_page.dart';

class AppRouter {
  // Route names (for easy access)
  static const String splash = RouteNames.splash;
  static const String onboarding = RouteNames.onboarding;
  static const String signIn = RouteNames.signIn;
  static const String signUp = RouteNames.signUp;
  static const String phoneVerification = RouteNames.phoneVerification;
  static const String forgotPassword = RouteNames.forgotPassword;
  static const String home = RouteNames.home;
  static const String mainNavigation = RouteNames.mainNavigation;
  static const String search = RouteNames.search;
  static const String searchResults = RouteNames.searchResults;
  static const String priceComparison = RouteNames.priceComparison;
  static const String productDetail = RouteNames.productDetail;
  static const String addPrice = RouteNames.addPrice;
  static const String profile = RouteNames.profile;
  static const String editProfile = RouteNames.editProfile;
  static const String submittedPrices = RouteNames.submittedPrices;
  static const String savedProducts = RouteNames.savedProducts;
  static const String notifications = RouteNames.notifications;
  static const String settings = RouteNames.settings;
  static const String noInternet = RouteNames.noInternet;
  static const String error = RouteNames.error;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Authentication Routes
      case RouteNames.splash:
        return _buildRoute(const SplashScreen());
        
      case RouteNames.onboarding:
        return _buildRoute(const OnboardingPage());
        
      case RouteNames.signIn:
        return _buildRoute(const SignInPage());
        
      case RouteNames.signUp:
        return _buildRoute(const SignUpPage());
        
      case RouteNames.phoneVerification:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(PhoneVerificationPage(
          phoneNumber: args?['phoneNumber'] ?? '',
          verificationId: args?['verificationId'] ?? '',
        ));
        
      case RouteNames.forgotPassword:
        return _buildRoute(const ForgotPasswordPage());
        
      // Main App Routes
      case RouteNames.home:
        return _buildRoute(const HomePage());
        
      case RouteNames.mainNavigation:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(MainNavigationPage(
          initialIndex: args?['initialIndex'] ?? 0,
        ));
        
      // Search & Comparison Routes
      case RouteNames.searchResults:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(SearchResultsPage(
          query: args?['query'] ?? '',
          category: args?['category'],
          filters: args?['filters'],
        ));
        
      case RouteNames.priceComparison:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(PriceComparisonPage(
          productId: args?['productId'] ?? '',
          productName: args?['productName'] ?? '',
        ));
        
      case RouteNames.productDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(ProductDetailPage(
          productId: args?['productId'] ?? '',
          productName: args?['productName'] ?? '',
        ));
        
      // Add Price Routes
      case RouteNames.addPrice:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(AddPricePage(
          productName: args?['productName'],
          preFilledData: args?['preFilledData'],
        ));
        
      // Profile Routes
      case RouteNames.profile:
        return _buildRoute(const ProfilePage());
        
      case RouteNames.editProfile:
        return _buildRoute(const EditProfilePage());
        
      case RouteNames.submittedPrices:
        return _buildRoute(const SubmittedPricesPage());
        
      case RouteNames.savedProducts:
        return _buildRoute(const SavedProductsPage());
        
      case RouteNames.notifications:
        return _buildRoute(const NotificationsPage());
        
      case RouteNames.settings:
        return _buildRoute(const SettingsPage());
        
      // Utility Routes
      case RouteNames.noInternet:
        return _buildRoute(const NoInternetPage());
        
      case RouteNames.error:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(ErrorPage(
          message: args?['message'] ?? 'An error occurred',
          onRetry: args?['onRetry'],
        ));
        
      // Default route
      default:
        return _buildRoute(
          const ErrorPage(
            message: 'Page not found',
          ),
        );
    }
  }

  static PageRoute<dynamic> _buildRoute(Widget page) {
    return MaterialPageRoute(builder: (_) => page);
  }

  static PageRoute<dynamic> _buildSlideRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  static PageRoute<dynamic> _buildFadeRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  // Navigation helper methods
  static void pushNamed(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  static void pushReplacementNamed(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
  }

  static void pushNamedAndClearStack(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  static void pop(BuildContext context, [Object? result]) {
    Navigator.pop(context, result);
  }

  static bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }

  // Specific navigation methods
  static void goToHome(BuildContext context) {
    pushNamedAndClearStack(context, mainNavigation);
  }

  static void goToAuth(BuildContext context) {
    pushNamedAndClearStack(context, onboarding);
  }

  static void goToProductDetail(BuildContext context, String productId, String productName) {
    pushNamed(context, productDetail, arguments: {
      'productId': productId,
      'productName': productName,
    });
  }

  static void goToPriceComparison(BuildContext context, String productId, String productName) {
    pushNamed(context, priceComparison, arguments: {
      'productId': productId,
      'productName': productName,
    });
  }

  static void goToAddPrice(BuildContext context, {String? productName, Map<String, dynamic>? preFilledData}) {
    pushNamed(context, addPrice, arguments: {
      'productName': productName,
      'preFilledData': preFilledData,
    });
  }

  static void goToPhoneVerification(BuildContext context, String phoneNumber, String verificationId) {
    pushNamed(context, phoneVerification, arguments: {
      'phoneNumber': phoneNumber,
      'verificationId': verificationId,
    });
  }

  static void goToSearchResults(BuildContext context, String query, {String? category, Map<String, dynamic>? filters}) {
    pushNamed(context, searchResults, arguments: {
      'query': query,
      'category': category,
      'filters': filters,
    });
  }

  static void showError(BuildContext context, String message, {VoidCallback? onRetry}) {
    pushNamed(context, error, arguments: {
      'message': message,
      'onRetry': onRetry,
    });
  }
}