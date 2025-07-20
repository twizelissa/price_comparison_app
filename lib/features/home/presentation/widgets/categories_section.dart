import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/category.dart';

class CategoriesSection extends StatelessWidget {
  final List<Category> categories;
  final ValueChanged<Category>? onCategoryTap;

  const CategoriesSection({
    Key? key,
    required this.categories,
    this.onCategoryTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPaddingH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Text(
            AppStrings.quickCategories,
            style: AppTextStyles.h5,
          ),
          
          const SizedBox(height: AppDimensions.paddingM),
          
          // Categories grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3.5,
              crossAxisSpacing: AppDimensions.paddingM,
              mainAxisSpacing: AppDimensions.paddingM,
            ),
            itemCount: categories.length > 4 ? 4 : categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return CategoryCard(
                category: category,
                onTap: () => onCategoryTap?.call(category),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback? onTap;

  const CategoryCard({
    Key? key,
    required this.category,
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
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.textSecondary.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Category icon
            Container(
              width: AppDimensions.categoryIconSize,
              height: AppDimensions.categoryIconSize,
              decoration: BoxDecoration(
                color: category.displayColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              ),
              child: Icon(
                category.displayIcon,
                color: category.displayColor,
                size: AppDimensions.iconM,
              ),
            ),
            
            const SizedBox(width: AppDimensions.paddingM),
            
            // Category name
            Expanded(
              child: Text(
                category.displayName,
                style: AppTextStyles.categoryLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Full categories grid (for dedicated categories page)
class CategoriesGrid extends StatelessWidget {
  final List<Category> categories;
  final ValueChanged<Category>? onCategoryTap;
  final int crossAxisCount;

  const CategoriesGrid({
    Key? key,
    required this.categories,
    this.onCategoryTap,
    this.crossAxisCount = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 1.2,
        crossAxisSpacing: AppDimensions.paddingM,
        mainAxisSpacing: AppDimensions.paddingM,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return ExpandedCategoryCard(
          category: category,
          onTap: () => onCategoryTap?.call(category),
        );
      },
    );
  }
}

// Expanded category card with more details
class ExpandedCategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback? onTap;

  const ExpandedCategoryCard({
    Key? key,
    required this.category,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.textSecondary.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Category icon
            Container(
              width: AppDimensions.iconXXL * 1.2,
              height: AppDimensions.iconXXL * 1.2,
              decoration: BoxDecoration(
                color: category.displayColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              ),
              child: Icon(
                category.displayIcon,
                color: category.displayColor,
                size: AppDimensions.iconXL,
              ),
            ),
            
            const SizedBox(height: AppDimensions.paddingM),
            
            // Category name
            Text(
              category.displayName,
              style: AppTextStyles.labelLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: AppDimensions.paddingS),
            
            // Product count
            Text(
              category.formattedProductCount,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Horizontal categories list
class HorizontalCategoriesList extends StatelessWidget {
  final List<Category> categories;
  final ValueChanged<Category>? onCategoryTap;

  const HorizontalCategoriesList({
    Key? key,
    required this.categories,
    this.onCategoryTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimensions.categoryItemSize,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPaddingH),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Container(
            width: AppDimensions.categoryItemSize,
            margin: EdgeInsets.only(
              right: index < categories.length - 1 
                  ? AppDimensions.paddingM 
                  : 0,
            ),
            child: GestureDetector(
              onTap: () => onCategoryTap?.call(category),
              child: Column(
                children: [
                  // Category icon
                  Container(
                    width: AppDimensions.categoryItemSize,
                    height: AppDimensions.categoryItemSize,
                    decoration: BoxDecoration(
                      color: category.displayColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                      border: Border.all(
                        color: category.displayColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      category.displayIcon,
                      color: category.displayColor,
                      size: AppDimensions.iconL,
                    ),
                  ),
                  
                  const SizedBox(height: AppDimensions.paddingS),
                  
                  // Category name
                  Text(
                    category.displayName.split(' ').first, // Show only first word
                    style: AppTextStyles.labelSmall,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}