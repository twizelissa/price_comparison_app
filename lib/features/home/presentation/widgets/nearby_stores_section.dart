import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/store.dart';
import 'store_card.dart';

class NearbyStoresSection extends StatelessWidget {
  final List<Store> stores;
  final ValueChanged<Store>? onStoreTap;
  final VoidCallback? onSeeAllTap;

  const NearbyStoresSection({
    Key? key,
    required this.stores,
    this.onStoreTap,
    this.onSeeAllTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (stores.isEmpty) {
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
                AppStrings.nearbyStores,
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
          
          // Horizontal store list
          SizedBox(
            height: AppDimensions.storeCardHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: stores.length,
              itemBuilder: (context, index) {
                final store = stores[index];
                return Container(
                  width: 280,
                  margin: EdgeInsets.only(
                    right: index < stores.length - 1 
                        ? AppDimensions.paddingM 
                        : 0,
                  ),
                  child: StoreCard(
                    store: store,
                    onTap: () => onStoreTap?.call(store),
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