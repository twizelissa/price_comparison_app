import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_dimensions.dart';

class EmptyStateWidget extends StatelessWidget {
  final String? message;
  final String? title;
  final IconData? icon;
  final Widget? illustration;
  final Widget? action;
  final VoidCallback? onActionPressed;
  final String? actionText;
  final bool showAction;

  const EmptyStateWidget({
    Key? key,
    this.message,
    this.title,
    this.icon,
    this.illustration,
    this.action,
    this.onActionPressed,
    this.actionText,
    this.showAction = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingXXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Illustration or Icon
            _buildIllustration(),
            const SizedBox(height: AppDimensions.paddingXL),
            
            // Title
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
            
            // Message
            if (message != null)
              Text(
                message!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            
            // Action
            if (showAction) ...[
              const SizedBox(height: AppDimensions.paddingXL),
              _buildAction(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    if (illustration != null) {
      return illustration!;
    }
    
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon ?? Icons.inbox_outlined,
        size: AppDimensions.iconXXXL,
        color: AppColors.textTertiary,
      ),
    );
  }

  Widget _buildAction() {
    if (action != null) {
      return action!;
    }
    
    if (onActionPressed != null && actionText != null) {
      return ElevatedButton(
        onPressed: onActionPressed,
        child: Text(actionText!),
      );
    }
    
    return const SizedBox.shrink();
  }
}

// Specific empty state widgets
class NoSearchResultsWidget extends StatelessWidget {
  final String query;
  final VoidCallback? onClearSearch;

  const NoSearchResultsWidget({
    Key? key,
    required this.query,
    this.onClearSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.search_off,
      title: 'No Results Found',
      message: 'We couldn\'t find any results for "$query".\nTry different keywords or check the spelling.',
      actionText: 'Clear Search',
      onActionPressed: onClearSearch,
    );
  }
}

class NoSavedProductsWidget extends StatelessWidget {
  final VoidCallback? onBrowseProducts;

  const NoSavedProductsWidget({
    Key? key,
    this.onBrowseProducts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.bookmark_outline,
      title: 'No Saved Products',
      message: 'You haven\'t saved any products yet.\nStart browsing to save products you\'re interested in.',
      actionText: 'Browse Products',
      onActionPressed: onBrowseProducts,
    );
  }
}

class NoPriceSubmissionsWidget extends StatelessWidget {
  final VoidCallback? onAddPrice;

  const NoPriceSubmissionsWidget({
    Key? key,
    this.onAddPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.add_circle_outline,
      title: 'No Price Submissions',
      message: 'You haven\'t submitted any prices yet.\nHelp your community by sharing prices you\'ve seen.',
      actionText: 'Add Price',
      onActionPressed: onAddPrice,
    );
  }
}

class NoNotificationsWidget extends StatelessWidget {
  const NoNotificationsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const EmptyStateWidget(
      icon: Icons.notifications_none,
      title: 'No Notifications',
      message: 'You\'re all caught up!\nWe\'ll notify you about price drops and community updates.',
      showAction: false,
    );
  }
}

class NoNearbyStoresWidget extends StatelessWidget {
  final VoidCallback? onRefresh;

  const NoNearbyStoresWidget({
    Key? key,
    this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.store_outlined,
      title: 'No Nearby Stores',
      message: 'We couldn\'t find any stores in your area.\nTry expanding your search radius or refresh.',
      actionText: 'Refresh',
      onActionPressed: onRefresh,
    );
  }
}

class NoPriceDataWidget extends StatelessWidget {
  final String productName;
  final VoidCallback? onAddPrice;

  const NoPriceDataWidget({
    Key? key,
    required this.productName,
    this.onAddPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.trending_down,
      title: 'No Price Data',
      message: 'We don\'t have any price information for $productName yet.\nBe the first to contribute!',
      actionText: 'Add Price',
      onActionPressed: onAddPrice,
    );
  }
}

class NetworkOfflineWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const NetworkOfflineWidget({
    Key? key,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.wifi_off,
      title: 'You\'re Offline',
      message: 'Please check your internet connection and try again.',
      actionText: 'Retry',
      onActionPressed: onRetry,
    );
  }
}

class MaintenanceWidget extends StatelessWidget {
  const MaintenanceWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const EmptyStateWidget(
      icon: Icons.build_outlined,
      title: 'Under Maintenance',
      message: 'We\'re currently performing maintenance.\nPlease check back in a few minutes.',
      showAction: false,
    );
  }
}

// Animated empty state widget
class AnimatedEmptyStateWidget extends StatefulWidget {
  final String? message;
  final String? title;
  final IconData? icon;
  final Widget? action;
  final VoidCallback? onActionPressed;
  final String? actionText;

  const AnimatedEmptyStateWidget({
    Key? key,
    this.message,
    this.title,
    this.icon,
    this.action,
    this.onActionPressed,
    this.actionText,
  }) : super(key: key);

  @override
  State<AnimatedEmptyStateWidget> createState() => _AnimatedEmptyStateWidgetState();
}

class _AnimatedEmptyStateWidgetState extends State<AnimatedEmptyStateWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: EmptyStateWidget(
              title: widget.title,
              message: widget.message,
              icon: widget.icon,
              action: widget.action,
              onActionPressed: widget.onActionPressed,
              actionText: widget.actionText,
            ),
          ),
        );
      },
    );
  }
}