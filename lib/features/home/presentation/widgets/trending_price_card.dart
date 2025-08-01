import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/product.dart';
import 'product_card.dart';

class TrendingProductsSection extends StatelessWidget {
  final List<Product> products;
  final ValueChanged<Product>? onProductTap;
  final VoidCallback? onSeeAllTap;

  const TrendingProductsSection({
    Key? key,
    required this.products,
    this.onProductTap,
    this.onSeeAllTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPaddingH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.trendingPriceChecks,
                style: AppTextStyles.h5,
              ),
              if (onSeeAllTap != null)
                TextButton(
                  onPressed: onSeeAllTap,
                  child: Text(
                    'See all',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: AppDimensions.paddingM),
          
          // Horizontal product list
          SizedBox(
            height: AppDimensions.productCardHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Container(
                  width: AppDimensions.productCardWidth,
                  margin: EdgeInsets.only(
                    right: index < products.length - 1 
                        ? AppDimensions.paddingM 
                        : 0,
                  ),
                  child: ProductCard(
                    product: product,
                    onTap: () => onProductTap?.call(product),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}