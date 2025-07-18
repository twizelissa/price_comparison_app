import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';

class CustomErrorWidget extends StatelessWidget {
  final String? message;
  final String? title;
  final VoidCallback? onRetry;
  final IconData? icon;
  final String? buttonText;
  final bool showRetryButton;

  const CustomErrorWidget({
    Key? key,
    this.message,
    this.title,
    this.onRetry,
    this.icon,
    this.buttonText,
    this.showRetryButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingXXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.error_outline,
              size: AppDimensions.iconXXXL * 1.5,
              color: AppColors.error,
            ),
            const SizedBox(height: AppDimensions.paddingL),
            if (title != null) ...[
              Text(
                title!,
                style: AppTextStyles.h5.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.paddingM),
            ],
            Text(
              message ?? AppStrings.somethingWentWrong,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (showRetryButton && onRetry != null) ...[
              const SizedBox(height: AppDimensions.paddingXL),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: onRetry,
                  child: Text(buttonText ?? AppStrings.tryAgain),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? message;

  const NetworkErrorWidget({
    Key? key,
    this.onRetry,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(
      title: 'No Internet Connection',
      message: message ?? AppStrings.noInternetConnection,
      icon: Icons.wifi_off,
      onRetry: onRetry,
      buttonText: AppStrings.tryAgain,
    );
  }
}

class ServerErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? message;

  const ServerErrorWidget({
    Key? key,
    this.onRetry,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(
      title: 'Server Error',
      message: message ?? 'Something went wrong on our end. Please try again.',
      icon: Icons.cloud_off,
      onRetry: onRetry,
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  final String? message;
  final String? title;
  final IconData? icon;
  final Widget? action;
  final VoidCallback? onActionPressed;
  final String? actionText;

  const EmptyStateWidget({
    Key? key,
    this.message,
    this.title,
    this.icon,
    this.action,
    this.onActionPressed,
    this.actionText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingXXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.inbox_outlined,
              size: AppDimensions.iconXXXL * 1.5,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: AppDimensions.paddingL),
            if (title != null) ...[
              Text(
                title!,
                style: AppTextStyles.h5.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.paddingM),
            ],
            Text(
              message ?? 'No data available',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[
              const SizedBox(height: AppDimensions.paddingXL),
              action!,
            ] else if (onActionPressed != null && actionText != null) ...[
              const SizedBox(height: AppDimensions.paddingXL),
              ElevatedButton(
                onPressed: onActionPressed,
                child: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Full-screen error page
class ErrorPage extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String? title;

  const ErrorPage({
    Key? key,
    required this.message,
    this.onRetry,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomErrorWidget(
          title: title,
          message: message,
          onRetry: onRetry,
        ),
      ),
    );
  }
}

// No internet page
class NoInternetPage extends StatelessWidget {
  final VoidCallback? onRetry;

  const NoInternetPage({
    Key? key,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: NetworkErrorWidget(
          onRetry: onRetry ?? () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}

// Error snackbar helper
class ErrorSnackBar {
  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: AppDimensions.iconM,
            ),
            const SizedBox(width: AppDimensions.paddingM),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        margin: const EdgeInsets.all(AppDimensions.paddingL),
      ),
    );
  }
}

// Success snackbar helper
class SuccessSnackBar {
  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: AppDimensions.iconM,
            ),
            const SizedBox(width: AppDimensions.paddingM),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        margin: const EdgeInsets.all(AppDimensions.paddingL),
      ),
    );
  }
}