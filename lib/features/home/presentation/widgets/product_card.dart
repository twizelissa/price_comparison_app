import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/utils/currency_formatter.dart';
import '../../domain/entities/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final bool showSaveButton;
  final bool isSaved;
  final VoidCallback? onSaveToggle;

  const ProductCard({
    Key? key,
    required this.product,
    this.onTap,
    this.showSaveButton = false,
    this.isSaved = false,
    this.onSaveToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
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
            // Product image
            _buildProductImage(),
            
            // Product details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name
                    Text(
                      product.name,
                      style: AppTextStyles.productName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: AppDimensions.paddingS),
                    
                    // Price and trend
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            CurrencyFormatter.formatRWF(product.averagePrice),
                            style: AppTextStyles.priceText.copyWith(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        if (product.priceChange != null)
                          _buildPriceTrend(),
                      ],
                    ),
                    
                    const SizedBox(height: AppDimensions.paddingXS),
                    
                    // Additional info
                    Text(
                      '${product.priceSubmissions} submissions',
                      style: AppTextStyles.caption,
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

  Widget _buildProductImage() {
    return Stack(
      children: [
        Container(
          height: AppDimensions.productImageHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppDimensions.cardRadius),
              topRight: Radius.circular(AppDimensions.cardRadius),
            ),
          ),
          child: product.imageUrl != null
              ? ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppDimensions.cardRadius),
                    topRight: Radius.circular(AppDimensions.cardRadius),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => _buildImagePlaceholder(),
                    errorWidget: (context, url, error) => _buildImagePlaceholder(),
                  ),
                )
              : _buildImagePlaceholder(),
        ),
        
        // Trending badge
        if (product.isTrending)
          Positioned(
            top: AppDimensions.paddingS,
            left: AppDimensions.paddingS,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingS,
                vertical: AppDimensions.paddingXS,
              ),
              decoration: BoxDecoration(
                color: AppColors.warning,
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              ),
              child: Text(
                'Trending',
                style: AppTextStyles.labelSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        
        // Save button
        if (showSaveButton)
          Positioned(
            top: AppDimensions.paddingS,
            right: AppDimensions.paddingS,
            child: GestureDetector(
              onTap: onSaveToggle,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_outline,
                  color: isSaved ? AppColors.primary : AppColors.textSecondary,
                  size: AppDimensions.iconM,
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
          _getCategoryIcon(),
          size: AppDimensions.iconXXL,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }

  Widget _buildPriceTrend() {
    if (product.priceChange == null) return const SizedBox.shrink();
    
    final isPositive = product.priceChange! > 0;
    final color = isPositive ? AppColors.priceUp : AppColors.priceDown;
    final icon = isPositive ? Icons.trending_up : Icons.trending_down;
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingS,
        vertical: AppDimensions.paddingXS,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppDimensions.iconS,
            color: color,
          ),
          const SizedBox(width: AppDimensions.paddingXS),
          Text(
            product.priceChangeText,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon() {
    switch (product.category.toLowerCase()) {
      case 'food':
      case 'groceries':
        return Icons.restaurant;
      case 'electronics':
        return Icons.devices;
      case 'clothing':
        return Icons.checkroom;
      case 'health':
        return Icons.local_pharmacy;
      default:
        return Icons.shopping_bag;
    }
  }
}

// Compact product card for lists
class CompactProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const CompactProductCard({
    Key? key,
    required this.product,
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
            // Product image
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              ),
              child: product.imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                      child: CachedNetworkImage(
                        imageUrl: product.imageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => _buildPlaceholder(),
                        errorWidget: (context, url, error) => _buildPlaceholder(),
                      ),
                    )
                  : _buildPlaceholder(),
            ),
            
            const SizedBox(width: AppDimensions.paddingM),
            
            // Product details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTextStyles.labelLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimensions.paddingXS),
                  Text(
                    CurrencyFormatter.formatRWF(product.averagePrice),
                    style: AppTextStyles.priceText.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: AppDimensions.paddingXS),
                  Text(
                    '${product.priceSubmissions} submissions',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            
            // Trending indicator
            if (product.isTrending)
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingXS),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.trending_up,
                  color: AppColors.warning,
                  size: AppDimensions.iconS,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Icon(
        Icons.image,
        color: AppColors.textTertiary,
        size: AppDimensions.iconL,
      ),
    );
  }
}