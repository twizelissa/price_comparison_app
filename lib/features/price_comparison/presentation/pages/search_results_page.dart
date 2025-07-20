import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../../../home/presentation/bloc/home_event.dart';
import '../../../home/presentation/bloc/home_state.dart';
import '../../../home/presentation/widgets/product_card.dart';
import '../../../home/presentation/widgets/search_bar_widget.dart';

class SearchResultsPage extends StatefulWidget {
  final String query;
  final String? category;
  final Map<String, dynamic>? filters;

  const SearchResultsPage({
    Key? key,
    required this.query,
    this.category,
    this.filters,
  }) : super(key: key);

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _sortBy = 'relevance';
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.query;
    _performSearch();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _performSearch() {
    context.read<HomeBloc>().add(
      SearchProductsEvent(
        query: widget.query,
        categoryId: widget.category,
        sortBy: _sortBy,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Search Results',
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
            icon: Icon(
              Icons.tune,
              color: _showFilters ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
            child: SearchBarWidget(
              controller: _searchController,
              autofocus: false,
              onSearchPressed: () {
                final query = _searchController.text.trim();
                if (query.isNotEmpty) {
                  context.read<HomeBloc>().add(
                    SearchProductsEvent(query: query, sortBy: _sortBy),
                  );
                }
              },
            ),
          ),

          // Filters panel
          if (_showFilters) _buildFiltersPanel(),

          // Results
          Expanded(
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const LoadingWidget(message: 'Searching products...');
                }

                if (state is SearchError) {
                  return CustomErrorWidget(
                    message: state.message,
                    onRetry: _performSearch,
                  );
                }

                if (state is SearchEmpty) {
                  return NoSearchResultsWidget(
                    query: state.query,
                    onClearSearch: () {
                      _searchController.clear();
                      context.read<HomeBloc>().add(ClearSearchEvent());
                    },
                  );
                }

                if (state is SearchResultsLoaded) {
                  return _buildResults(state);
                }

                return const Center(
                  child: Text('Enter a search term to find products'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersPanel() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPaddingH),
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sort by',
            style: AppTextStyles.labelLarge,
          ),
          const SizedBox(height: AppDimensions.paddingS),
          Wrap(
            spacing: AppDimensions.paddingS,
            children: [
              _buildSortChip('Relevance', 'relevance'),
              _buildSortChip('Price: Low to High', 'price'),
              _buildSortChip('Price: High to Low', 'price_desc'),
              _buildSortChip('Most Popular', 'popularity'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(String label, String value) {
    final isSelected = _sortBy == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _sortBy = value;
          });
          _performSearch();
        }
      },
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
    );
  }

  Widget _buildResults(SearchResultsLoaded state) {
    return Column(
      children: [
        // Results header
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenPaddingH,
            vertical: AppDimensions.paddingS,
          ),
          child: Row(
            children: [
              Text(
                '${state.products.length} results for "${state.query}"',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                'Sorted by ${_getSortLabel()}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),

        // Products grid
        Expanded(
          child: GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: AppDimensions.paddingM,
              mainAxisSpacing: AppDimensions.paddingM,
            ),
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final product = state.products[index];
              return ProductCard(
                product: product,
                showSaveButton: true,
                onTap: () => _navigateToProductDetail(product),
              );
            },
          ),
        ),
      ],
    );
  }

  String _getSortLabel() {
    switch (_sortBy) {
      case 'price':
        return 'Price: Low to High';
      case 'price_desc':
        return 'Price: High to Low';
      case 'popularity':
        return 'Most Popular';
      default:
        return 'Relevance';
    }
  }

  void _navigateToProductDetail(dynamic product) {
    Navigator.pushNamed(
      context,
      '/product-detail',
      arguments: {
        'productId': product.id,
        'productName': product.name,
      },
    );
  }
}