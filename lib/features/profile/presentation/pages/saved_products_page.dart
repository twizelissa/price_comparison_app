import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/models/product_model.dart';
import '../../../../core/services/hybrid_database_service.dart';
import '../../../../shared/utils/auth_helper.dart';
import '../../../../config/routes/route_names.dart';

class SavedProductsPage extends StatefulWidget {
  const SavedProductsPage({Key? key}) : super(key: key);

  @override
  State<SavedProductsPage> createState() => _SavedProductsPageState();
}

class _SavedProductsPageState extends State<SavedProductsPage> {
  List<FavoriteItem> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthAndLoadFavorites();
  }

  void _checkAuthAndLoadFavorites() {
    if (!AuthHelper.isLoggedIn) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    _loadFavorites();
  }

  void _loadFavorites() async {
    setState(() {
      _isLoading = true;
    });

    try {
      HybridDatabaseService.getFavorites(AuthHelper.currentUserId!).listen((favorites) {
        if (mounted) {
          setState(() {
            _favorites = favorites;
            _isLoading = false;
          });
        }
      }, onError: (error) {
        print('Error loading favorites: $error');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    } catch (e) {
      print('Error setting up favorites stream: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _removeFavorite(String productId) async {
    try {
      await HybridDatabaseService.removeFavorite(AuthHelper.currentUserId!, productId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Removed from favorites'),
          backgroundColor: Colors.orange,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error removing favorite: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'My Favorites',
          style: AppTextStyles.h4.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        automaticallyImplyLeading: false, // No back button for navigation tab
      ),
      body: !AuthHelper.isLoggedIn
          ? _buildSignInRequired()
          : _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _favorites.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: () async {
                        _loadFavorites();
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _favorites.length,
                        itemBuilder: (context, index) {
                          return _buildFavoriteCard(_favorites[index]);
                        },
                      ),
                    ),
    );
  }

  Widget _buildSignInRequired() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'Sign In Required',
            style: AppTextStyles.h3.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please sign in to view your favorites',
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, RouteNames.signIn),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'No favorites yet',
            style: AppTextStyles.h3.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start browsing products and add some to your favorites!',
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteCard(FavoriteItem favorite) {
    return FutureBuilder<Product?>(
      future: HybridDatabaseService.getProduct(favorite.productId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox.shrink();
        }

        Product product = snapshot.data!;
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.pushNamed(
                context,
                RouteNames.productDetails,
                arguments: product,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Product Image
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: product.localImagePath.isNotEmpty
                          ? Image.asset(
                              product.localImagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(Icons.image_not_supported),
                                );
                              },
                            )
                          : product.imageUrl.isNotEmpty
                              ? Image.network(
                                  product.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(Icons.image_not_supported),
                                    );
                                  },
                                )
                              : const Center(
                                  child: Icon(Icons.shopping_bag, size: 40),
                                ),
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Product Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: AppTextStyles.h5.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'RWF ${product.price.toStringAsFixed(0)}',
                          style: AppTextStyles.h5.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.storeName,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            product.category,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Remove Button
                  IconButton(
                    onPressed: () => _removeFavorite(favorite.productId),
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    tooltip: 'Remove from favorites',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
