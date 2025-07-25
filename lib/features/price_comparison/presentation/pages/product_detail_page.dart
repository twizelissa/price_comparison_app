import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/utils/currency_formatter.dart';
import '../../../home/data/models/product_model.dart';

class ProductDetailPage extends StatefulWidget {
  final String productId;
  final String productName;

  const ProductDetailPage({
    Key? key,
    required this.productId,
    required this.productName,
  }) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isSaved = false;
  ProductModel? _product;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadProductData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadProductData() {
    // In a real app, fetch from repository
    // For now, find from mock data
    final mockProducts = ProductModel.getMockProducts();
    _product = mockProducts.firstWhere(
      (p) => p.id == widget.productId,
      orElse: () => ProductModel(
        id: widget.productId,
        name: widget.productName,
        category: 'general',
        averagePrice: 1000,
        lastUpdated: DateTime.now(),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _product == null
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // App bar with product image
                _buildSliverAppBar(),

                // Product content
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      // Product info
                      _buildProductInfo(),

                      // Price section
                      _buildPriceSection(),

                      // Tabs
                      _buildTabSection(),
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: AppColors.surface,
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              _isSaved = !_isSaved;
            });
          },
          icon: Icon(
            _isSaved ? Icons.bookmark : Icons.bookmark_outline,
            color: _isSaved ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
        IconButton(
          onPressed: _shareProduct,
          icon: const Icon(Icons.share, color: AppColors.textSecondary),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: _product!.imageUrl != null
            ? CachedNetworkImage(
                imageUrl: _product!.imageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildImagePlaceholder(),
                errorWidget: (context, url, error) => _buildImagePlaceholder(),
              )
            : _buildImagePlaceholder(),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: AppColors.cardBackground,
      child: Center(
        child: Icon(
          _getCategoryIcon(),
          size: 80,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product name and category
          Text(
            _product!.name,
            style: AppTextStyles.h3,
          ),
          const SizedBox(height: AppDimensions.paddingS),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
              vertical: AppDimensions.paddingS,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            ),
            child: Text(
              _product!.category.toUpperCase(),
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingL),

          // Product stats
          Row(
            children: [
              _buildStatItem('Price Submissions', '${_product!.priceSubmissions}'),
              const SizedBox(width: AppDimensions.paddingXL),
              _buildStatItem('Stores', '${_product!.stores.length}'),
              const SizedBox(width: AppDimensions.paddingXL),
              _buildStatItem('Last Updated', _formatLastUpdated()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTextStyles.h6.copyWith(
            color: AppColors.primary,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.screenPaddingH),
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Price',
            style: AppTextStyles.labelLarge,
          ),
          const SizedBox(height: AppDimensions.paddingS),
          Row(
            children: [
              Text(
                CurrencyFormatter.formatRWF(_product!.averagePrice),
                style: AppTextStyles.h2.copyWith(
                  color: AppColors.primary,
                ),
              ),
              if (_product!.unit != 'piece') ...[
                Text(
                  '/${_product!.unit}',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
              const Spacer(),
              if (_product!.priceChange != null) _buildPriceTrend(),
            ],
          ),
          if (_product!.minPrice != null && _product!.maxPrice != null) ...[
            const SizedBox(height: AppDimensions.paddingS),
            Text(
              'Range: ${CurrencyFormatter.formatRWF(_product!.minPrice!)} - ${CurrencyFormatter.formatRWF(_product!.maxPrice!)}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPriceTrend() {
    if (_product!.priceChange == null) return const SizedBox.shrink();

    final isPositive = _product!.priceChange! > 0;
    final color = isPositive ? AppColors.priceUp : AppColors.priceDown;
    final icon = isPositive ? Icons.trending_up : Icons.trending_down;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingS,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppDimensions.iconM, color: color),
          const SizedBox(width: AppDimensions.paddingS),
          Text(
            _product!.priceChangeText,
            style: AppTextStyles.labelMedium.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSection() {
    return Column(
      children: [
        // Tab bar
        Container(
          margin: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPaddingH),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: const [
              Tab(text: 'Price History'),
              Tab(text: 'Stores'),
            ],
          ),
        ),

        // Tab content
        SizedBox(
          height: 400,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildPriceHistoryTab(),
              _buildStoresTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceHistoryTab() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
      child: Column(
        children: [
          // Mock price chart placeholder
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(color: AppColors.border),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.show_chart,
                    size: 48,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(height: AppDimensions.paddingM),
                  Text(
                    'Price Chart',
                    style: AppTextStyles.h6.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    'Coming Soon',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.paddingL),

          // Recent price submissions
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return _buildPriceSubmissionItem(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSubmissionItem(int index) {
    final prices = [1200, 1150, 1180, 1100, 1250];
    final stores = ['Kimironko Market', 'Nyabugogo Market', 'City Mall', 'Local Shop', 'Super Market'];
    final dates = ['2 hours ago', '1 day ago', '2 days ago', '3 days ago', '1 week ago'];

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingM),
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stores[index % stores.length],
                  style: AppTextStyles.labelMedium,
                ),
                Text(
                  dates[index % dates.length],
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            CurrencyFormatter.formatRWF(prices[index % prices.length].toDouble()),
            style: AppTextStyles.priceText.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildStoresTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
      itemCount: _product!.stores.length,
      itemBuilder: (context, index) {
        return _buildStoreItem(index);
      },
    );
  }

  Widget _buildStoreItem(int index) {
    final storeNames = ['Kimironko Market', 'Nyabugogo Market', 'City Mall'];
    final prices = [1200, 1150, 1300];
    final distances = ['1.2 km', '2.5 km', '3.1 km'];

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingM),
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Store icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            ),
            child: const Icon(
              Icons.store,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: AppDimensions.paddingM),

          // Store details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  storeNames[index % storeNames.length],
                  style: AppTextStyles.labelMedium,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: AppDimensions.iconS,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppDimensions.paddingXS),
                    Text(
                      distances[index % distances.length],
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Price
          Text(
            CurrencyFormatter.formatRWF(prices[index % prices.length].toDouble()),
            style: AppTextStyles.priceText.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.textSecondary.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _addPriceAlert,
              icon: const Icon(Icons.notifications_outlined),
              label: const Text('Price Alert'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.cardBackground,
                foregroundColor: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.paddingM),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _addPrice,
              icon: const Icon(Icons.add),
              label: const Text('Add Price'),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  IconData _getCategoryIcon() {
    switch (_product!.category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'electronics':
        return Icons.devices;
      case 'clothing':
        return Icons.checkroom;
      default:
        return Icons.shopping_bag;
    }
  }

  String _formatLastUpdated() {
    final now = DateTime.now();
    final difference = now.difference(_product!.lastUpdated);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }

  void _shareProduct() {
    // Implement share functionality
  }

  void _addPriceAlert() {
    // Navigate to price alert setup
  }

  void _addPrice() {
    Navigator.pushNamed(
      context,
      '/add-price',
      arguments: {
        'productName': _product!.name,
        'preFilledData': {
          'productId': _product!.id,
          'category': _product!.category,
        },
      },
    );
  }
}