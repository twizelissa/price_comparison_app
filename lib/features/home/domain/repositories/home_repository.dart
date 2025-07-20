import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/product.dart';
import '../entities/store.dart';
import '../entities/category.dart';

abstract class HomeRepository {
  // Trending products
  Future<Either<Failure, List<Product>>> getTrendingProducts({
    int limit = 10,
  });

  // Nearby stores
  Future<Either<Failure, List<Store>>> getNearbyStores({
    required double latitude,
    required double longitude,
    double radiusInKm = 10.0,
    int limit = 20,
  });

  // Categories
  Future<Either<Failure, List<Category>>> getCategories();

  Future<Either<Failure, List<Category>>> getPopularCategories();

  // Recent price updates
  Future<Either<Failure, List<Product>>> getRecentPriceUpdates({
    int limit = 10,
  });

  // Search suggestions
  Future<Either<Failure, List<String>>> getSearchSuggestions({
    required String query,
    int limit = 5,
  });

  // Products by category
  Future<Either<Failure, List<Product>>> getProductsByCategory({
    required String categoryId,
    int page = 1,
    int limit = 20,
  });

  // Store details
  Future<Either<Failure, Store>> getStoreById({
    required String storeId,
  });

  // Products by store
  Future<Either<Failure, List<Product>>> getProductsByStore({
    required String storeId,
    int page = 1,
    int limit = 20,
  });

  // Search products
  Future<Either<Failure, List<Product>>> searchProducts({
    required String query,
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    bool ascending = true,
    int page = 1,
    int limit = 20,
  });

  // Product recommendations
  Future<Either<Failure, List<Product>>> getRecommendedProducts({
    String? userId,
    int limit = 10,
  });

  // Dashboard stats
  Future<Either<Failure, DashboardStats>> getDashboardStats();

  // Featured stores
  Future<Either<Failure, List<Store>>> getFeaturedStores({
    int limit = 5,
  });

  // Price alerts for user
  Future<Either<Failure, List<PriceAlert>>> getUserPriceAlerts({
    required String userId,
  });

  // Save/unsave product
  Future<Either<Failure, void>> saveProduct({
    required String userId,
    required String productId,
  });

  Future<Either<Failure, void>> unsaveProduct({
    required String userId,
    required String productId,
  });

  // Get saved products
  Future<Either<Failure, List<Product>>> getSavedProducts({
    required String userId,
    int page = 1,
    int limit = 20,
  });

  // Report store/product
  Future<Either<Failure, void>> reportStore({
    required String storeId,
    required String reason,
    String? description,
  });

  Future<Either<Failure, void>> reportProduct({
    required String productId,
    required String reason,
    String? description,
  });
}

// Supporting classes
class DashboardStats {
  final int totalProducts;
  final int totalStores;
  final int totalPriceSubmissions;
  final int activeUsers;
  final double averagePriceSavings;

  const DashboardStats({
    required this.totalProducts,
    required this.totalStores,
    required this.totalPriceSubmissions,
    required this.activeUsers,
    required this.averagePriceSavings,
  });
}

class PriceAlert {
  final String id;
  final String userId;
  final String productId;
  final String productName;
  final double targetPrice;
  final double currentPrice;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? triggeredAt;

  const PriceAlert({
    required this.id,
    required this.userId,
    required this.productId,
    required this.productName,
    required this.targetPrice,
    required this.currentPrice,
    required this.isActive,
    required this.createdAt,
    this.triggeredAt,
  });

  bool get isTriggered => currentPrice <= targetPrice;
}