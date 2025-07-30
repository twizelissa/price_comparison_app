import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../domain/entities/store.dart';

class StoreCard extends StatelessWidget {
  final Store store;
  final VoidCallback? onTap;
  final bool showDistance;

  const StoreCard({
    Key? key,
    required this.store,
    this.onTap,
    this.showDistance = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.storeCardRadius),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.textSecondary.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Store image
            _buildStoreImage(),
            
            // Store details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Store name
                    Text(
                      store.name,
                      style: AppTextStyles.storeName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: AppDimensions.paddingXS),
                    
                    // Address
                    Text(
                      store.address,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const Spacer(),
                    
                    // Distance and rating
                    Row(
                      children: [
                        if (showDistance && store.distanceFromUser != null) ...[
                          Icon(
                            Icons.location_on,
                            size: AppDimensions.iconS,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: AppDimensions.paddingXS),
                          Text(
                            store.formattedDistance,
                            style: AppTextStyles.storeDistance,
                          ),
                          const Spacer(),
                        ],
                        
                        // Rating
                        if (store.totalReviews > 0) ...[
                          Icon(
                            Icons.star,
                            size: AppDimensions.iconS,
                            color: AppColors.warning,
                          ),
                          const SizedBox(width: AppDimensions.paddingXS),
                          Text(
                            store.rating.toStringAsFixed(1),
                            style: AppTextStyles.caption.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreImage() {
    return Stack(
      children: [
        Container(
          height: AppDimensions.storeImageHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppDimensions.storeCardRadius),
              topRight: Radius.circular(AppDimensions.storeCardRadius),
            ),
          ),
          child: store.imageUrl != null
              ? ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppDimensions.storeCardRadius),
                    topRight: Radius.circular(AppDimensions.storeCardRadius),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: store.imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => _buildImagePlaceholder(),
                    errorWidget: (context, url, error) => _buildImagePlaceholder(),
                  ),
                )
              : _buildImagePlaceholder(),
        ),
        
        // Fair pricing badge
        if (store.hasFairPricing)
          Positioned(
            top: AppDimensions.paddingS,
            left: AppDimensions.paddingS,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingS,
                vertical: AppDimensions.paddingXS,
              ),
              decoration: BoxDecoration(
                color: AppColors.success,
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              ),
              child: Text(
                'Fair Pricing',
                style: AppTextStyles.labelSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        
        // Store type badge
        Positioned(
          top: AppDimensions.paddingS,
          right: AppDimensions.paddingS,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingS,
              vertical: AppDimensions.paddingXS,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            ),
            child: Text(
              store.type.displayName,
              style: AppTextStyles.labelSmall.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: AppColors.cardBackground,
      child: Center(
        child: Icon(
          _getStoreTypeIcon(),
          size: AppDimensions.iconXXL,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }

  IconData _getStoreTypeIcon() {
    switch (store.type) {
      case StoreType.market:
        return Icons.store;
      case StoreType.supermarket:
        return Icons.shopping_cart;
      case StoreType.shop:
        return Icons.storefront;
      case StoreType.mall:
        return Icons.business;
      case StoreType.pharmacy:
        return Icons.local_pharmacy;
      case StoreType.restaurant:
        return Icons.restaurant;
      default:
        return Icons.store;
    }
  }
}

// Compact store card for lists
class CompactStoreCard extends StatelessWidget {
  final Store store;
  final VoidCallback? onTap;

  const CompactStoreCard({
    Key? key,
    required this.store,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // Store type icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              ),
              child: Icon(
                _getStoreTypeIcon(),
                color: AppColors.primary,
                size: AppDimensions.iconL,
              ),
            ),
            
            const SizedBox(width: AppDimensions.paddingM),
            
            // Store details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.name,
                    style: AppTextStyles.labelLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimensions.paddingXS),
                  Text(
                    store.address,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimensions.paddingXS),
                  Row(
                    children: [
                      if (store.distanceFromUser != null) ...[
                        Icon(
                          Icons.location_on,
                          size: AppDimensions.iconS,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: AppDimensions.paddingXS),
                        Text(
                          store.formattedDistance,
                          style: AppTextStyles.caption,
                        ),
                      ],
                      if (store.hasFairPricing) ...[
                        const SizedBox(width: AppDimensions.paddingS),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.paddingS,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
                          ),
                          child: Text(
                            'Fair Price',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.success,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            
            // Rating
            if (store.totalReviews > 0)
              Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        size: AppDimensions.iconS,
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: AppDimensions.paddingXS),
                      Text(
                        store.rating.toStringAsFixed(1),
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '(${store.totalReviews})',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  IconData _getStoreTypeIcon() {
    switch (store.type) {
      case StoreType.market:
        return Icons.store;
      case StoreType.supermarket:
        return Icons.shopping_cart;
      case StoreType.shop:
        return Icons.storefront;
      case StoreType.mall:
        return Icons.business;
      case StoreType.pharmacy:
        return Icons.local_pharmacy;
      case StoreType.restaurant:
        return Icons.restaurant;
      default:
        return Icons.store;
    }
  }
}