import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/models/product_model.dart';
import '../../../../core/services/sample_data_service.dart';
import '../../../../core/services/hybrid_database_service.dart';
import '../../../../core/utils/image_handler.dart';
import '../../../../shared/utils/auth_helper.dart';
import '../../../../config/routes/route_names.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _isDarkMode = false;
  int _cartItemCount = 0;
  
  final List<String> _categories = [
    'All',
    'Electronics',
    'Clothing',
    'Food & Beverages',
    'Home & Garden',
    'Health & Beauty',
    'Sports & Outdoors',
    'Books & Media',
    'Automotive',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    // Initialize sample data with hybrid approach
    HybridDatabaseService.initializeSampleData();
  }

  void _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _cartItemCount = prefs.getInt('cartItemCount') ?? 0;
    });
  }

  void _toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    await prefs.setBool('isDarkMode', _isDarkMode);
  }

  void _addToCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _cartItemCount++;
    });
    await prefs.setInt('cartItemCount', _cartItemCount);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added to cart'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Future<void> _editProduct(Product product) async {
    // Navigate to edit page (which is the same as add page but with pre-filled data)
    final result = await Navigator.pushNamed(
      context,
      RouteNames.addPrice,
      arguments: product, // Pass the product to pre-fill the form
    );
    
    if (result == true) {
      // Refresh is automatic due to stream
      setState(() {});
    }
  }

  Future<void> _deleteProduct(Product product) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true && product.id != null) {
      try {
        await HybridDatabaseService.deleteProduct(product.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting product: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _toggleFavorite(Product product, bool isFavorite) async {
    if (!AuthHelper.isLoggedIn) {
      _showSignInDialog();
      return;
    }

    if (product.id == null) return;

    try {
      if (isFavorite) {
        await HybridDatabaseService.removeFavorite(AuthHelper.currentUserId!, product.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Removed from favorites'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } else {
        await HybridDatabaseService.addFavorite(AuthHelper.currentUserId!, product.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Added to favorites'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
      setState(() {}); // Refresh the UI
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating favorites: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Stream<List<Product>> get _filteredProducts {
    return HybridDatabaseService.getProductsStream().map((products) {
      return products.where((product) {
        bool matchesSearch = product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                           product.storeName.toLowerCase().contains(_searchQuery.toLowerCase());
        bool matchesCategory = _selectedCategory == 'All' || product.category == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      'Price Comparison',
                      style: AppTextStyles.h2.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Find the best deals around',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
                onPressed: _toggleTheme,
                color: Colors.white,
              ),
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cart feature coming soon!')),
                      );
                    },
                    color: Colors.white,
                  ),
                  if (_cartItemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$_cartItemCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  if (AuthHelper.isLoggedIn) {
                    Navigator.pushNamed(context, RouteNames.profile);
                  } else {
                    _showSignInDialog();
                  }
                },
                color: Colors.white,
              ),
            ],
          ),
          
          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: _isDarkMode ? Colors.grey[800] : Colors.white,
                ),
              ),
            ),
          ),
          
          // Category Filter
          SliverToBoxAdapter(
            child: Container(
              height: 50,
              margin: const EdgeInsets.only(bottom: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = category == _selectedCategory;
                  
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      selectedColor: AppColors.primary.withOpacity(0.2),
                      checkmarkColor: AppColors.primary,
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Products Grid/List
          StreamBuilder<List<Product>>(
            stream: _filteredProducts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(50.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              }
              
              List<Product> products = [];
              
              if (snapshot.hasError || !snapshot.hasData) {
                // Use local sample data when Firestore fails
                print('Using local sample data due to Firestore issue: ${snapshot.error}');
                products = SampleDataService.getLocalSampleProducts();
                
                // Apply search and category filters to local data
                if (_searchQuery.isNotEmpty) {
                  products = products.where((product) =>
                    product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                    product.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                    product.storeName.toLowerCase().contains(_searchQuery.toLowerCase())
                  ).toList();
                }
                
                if (_selectedCategory != 'All') {
                  products = products.where((product) =>
                    product.category == _selectedCategory
                  ).toList();
                }
              } else {
                products = snapshot.data ?? [];
              }
              
              if (products.isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'No products found',
                            style: AppTextStyles.h3.copyWith(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _searchQuery.isNotEmpty || _selectedCategory != 'All'
                                ? 'Try adjusting your search or filter'
                                : 'Be the first to add a product!',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (!AuthHelper.isLoggedIn) ...[
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _showSignInDialog,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Sign In to Add Products'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              }
              
              // Check orientation and return appropriate sliver
              if (MediaQuery.of(context).orientation == Orientation.landscape) {
                // List view for landscape
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _buildProductListItem(products[index]);
                    },
                    childCount: products.length,
                  ),
                );
              } else {
                // Grid view for portrait
                return SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85, // Increased from 0.75 to give more height
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _buildProductCard(products[index]);
                    },
                    childCount: products.length,
                  ),
                );
              }
            },
          ),
          
          // Bottom spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
      
      // Floating Action Button for adding products - requires authentication
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (AuthHelper.isLoggedIn) {
            Navigator.pushNamed(context, RouteNames.addPrice);
          } else {
            _showSignInDialog();
          }
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: 'Add Product',
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    final canEdit = AuthHelper.canEditProduct(product.userId);
    
    return Container(
      margin: const EdgeInsets.all(6),
      child: Card(
        elevation: 4,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.pushNamed(
              context,
              RouteNames.productDetails,
              arguments: product,
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image with edit menu
              Expanded(
                flex: 4, // Increased from 3 to give more space to image
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: ImageHandler.displayProductImage(
                          product.imageUrl,
                          product.localImagePath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if (canEdit)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: PopupMenuButton<String>(
                            onSelected: (value) async {
                              if (value == 'edit') {
                                await _editProduct(product);
                              } else if (value == 'delete') {
                                await _deleteProduct(product);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, size: 20),
                                    SizedBox(width: 8),
                                    Text('Edit'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, size: 20, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Delete', style: TextStyle(color: Colors.red)),
                                  ],
                                ),
                              ),
                            ],
                            child: const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Icon(Icons.more_vert, size: 20, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              // Product Info - Clean and minimal design
              Expanded(
                flex: 3, // Reduced from 2 to balance with larger image space
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min, // Add this to prevent overflow
                    children: [
                      // Product name and price
                      Flexible( // Wrap in Flexible to prevent overflow
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              product.name,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1, // Reduced from 2 to save space
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2), // Reduced from 4
                            Text(
                              'RWF ${product.price.toStringAsFixed(0)}',
                              style: AppTextStyles.h6.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 4), // Small spacing
                      
                      // Action buttons - Save and Add to Cart
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Favorite button
                          FutureBuilder<bool>(
                            future: AuthHelper.isLoggedIn 
                                ? HybridDatabaseService.isFavorite(AuthHelper.currentUserId!, product.id ?? '')
                                : Future.value(false),
                            builder: (context, snapshot) {
                              bool isFavorite = snapshot.data ?? false;
                              return GestureDetector(
                                onTap: () => _toggleFavorite(product, isFavorite),
                                child: Container(
                                  padding: const EdgeInsets.all(6), // Reduced from 8
                                  decoration: BoxDecoration(
                                    color: isFavorite ? Colors.red.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6), // Reduced from 8
                                  ),
                                  child: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border,
                                    color: isFavorite ? Colors.red : Colors.grey[600],
                                    size: 18, // Reduced from 20
                                  ),
                                ),
                              );
                            },
                          ),
                          
                          // Add to cart button
                          GestureDetector(
                            onTap: _addToCart,
                            child: Container(
                              padding: const EdgeInsets.all(6), // Reduced from 8
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6), // Reduced from 8
                              ),
                              child: Icon(
                                Icons.add_shopping_cart,
                                color: AppColors.primary,
                                size: 18, // Reduced from 20
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductListItem(Product product) {
    final canEdit = AuthHelper.canEditProduct(product.userId);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
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
            padding: const EdgeInsets.all(12),
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
                    child: ImageHandler.displayProductImage(
                      product.imageUrl,
                      product.localImagePath,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              style: AppTextStyles.h5.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (canEdit)
                            PopupMenuButton<String>(
                              onSelected: (value) async {
                                if (value == 'edit') {
                                  await _editProduct(product);
                                } else if (value == 'delete') {
                                  await _deleteProduct(product);
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit, size: 20),
                                      SizedBox(width: 8),
                                      Text('Edit'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, size: 20, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text('Delete', style: TextStyle(color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ],
                              child: const Icon(Icons.more_vert, color: Colors.grey),
                            ),
                        ],
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
                
                // Add to Cart Button
                IconButton(
                  onPressed: _addToCart,
                  icon: const Icon(Icons.add_shopping_cart),
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSignInDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign In Required'),
          content: const Text(
            'You need to sign in to access this feature. Would you like to go to the authentication page?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, RouteNames.signIn);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Sign In'),
            ),
          ],
        );
      },
    );
  }
}
