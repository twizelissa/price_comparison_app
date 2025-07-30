import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' as math;
import '../../../../core/error/exceptions.dart';
import '../models/product_model.dart';
import '../models/store_model.dart';
import '../../domain/entities/category.dart';


abstract class HomeRemoteDataSource {
  Future<List<ProductModel>> getTrendingProducts({int limit = 10});
  Future<List<StoreModel>> getNearbyStores({
    required double latitude,
    required double longitude,
    double radiusInKm = 10.0,
    int limit = 20,
  });
  Future<List<Category>> getCategories();
  Future<List<Category>> getPopularCategories();
  Future<List<ProductModel>> getRecentPriceUpdates({int limit = 10});
  Future<List<String>> getSearchSuggestions({required String query, int limit = 5});
  Future<List<ProductModel>> searchProducts({
    required String query,
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    bool ascending = true,
    int page = 1,
    int limit = 20,
  });
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final FirebaseFirestore firestore;

  HomeRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<ProductModel>> getTrendingProducts({int limit = 10}) async {
    try {
      // For development, return mock data
      // In production, this would query Firestore
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
      
      final mockProducts = ProductModel.getMockProducts();
      return mockProducts.where((product) => product.isTrending).take(limit).toList();
      
      // Production implementation:
      /*
      final querySnapshot = await firestore
          .collection('products')
          .where('isTrending', isEqualTo: true)
          .where('status', isEqualTo: 'active')
          .orderBy('priceSubmissions', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc.data(), doc.id))
          .toList();
      */
    } catch (e) {
      throw ServerException(message: 'Failed to get trending products: ${e.toString()}');
    }
  }

  @override
  Future<List<StoreModel>> getNearbyStores({
    required double latitude,
    required double longitude,
    double radiusInKm = 10.0,
    int limit = 20,
  }) async {
    try {
      // For development, return mock data
      await Future.delayed(const Duration(milliseconds: 800)); // Simulate network delay
      
      final mockStores = StoreModel.getMockStores();
      return mockStores.where((store) => store.hasFairPricing).take(limit).toList();
      
      // Production implementation would use GeoFlutterFire or similar for location queries:
      /*
      // This is a simplified example - in production you'd use geospatial queries
      final querySnapshot = await firestore
          .collection('stores')
          .where('status', isEqualTo: 'active')
          .where('hasFairPricing', isEqualTo: true)
          .limit(limit)
          .get();

      final stores = querySnapshot.docs
          .map((doc) => StoreModel.fromFirestore(doc.data(), doc.id))
          .toList();

      // Filter by distance (simplified - in production use geospatial queries)
      final nearbyStores = stores.where((store) {
        final distance = _calculateDistance(
          latitude, longitude, 
          store.latitude, store.longitude
        );
        return distance <= radiusInKm;
      }).toList();

      // Sort by distance
      nearbyStores.sort((a, b) => 
        (a.distanceFromUser ?? 0).compareTo(b.distanceFromUser ?? 0));

      return nearbyStores;
      */
    } catch (e) {
      throw ServerException(message: 'Failed to get nearby stores: ${e.toString()}');
    }
  }

  @override
  Future<List<Category>> getCategories() async {
    try {
      // For development, return predefined categories
      await Future.delayed(const Duration(milliseconds: 300));
      return AppCategories.getAllActiveCategories();
      
      // Production implementation:
      /*
      final querySnapshot = await firestore
          .collection('categories')
          .where('status', isEqualTo: 'active')
          .orderBy('sortOrder')
          .get();

      return querySnapshot.docs
          .map((doc) => CategoryModel.fromFirestore(doc.data(), doc.id))
          .map((model) => model.toEntity())
          .toList();
      */
    } catch (e) {
      throw ServerException(message: 'Failed to get categories: ${e.toString()}');
    }
  }

  @override
  Future<List<Category>> getPopularCategories() async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      return AppCategories.getPopularCategories();
    } catch (e) {
      throw ServerException(message: 'Failed to get popular categories: ${e.toString()}');
    }
  }

  @override
  Future<List<ProductModel>> getRecentPriceUpdates({int limit = 10}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      
      final mockProducts = ProductModel.getMockProducts();
      // Sort by last updated (most recent first)
      mockProducts.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
      return mockProducts.take(limit).toList();
      
      // Production implementation:
      /*
      final querySnapshot = await firestore
          .collection('products')
          .where('status', isEqualTo: 'active')
          .orderBy('lastUpdated', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc.data(), doc.id))
          .toList();
      */
    } catch (e) {
      throw ServerException(message: 'Failed to get recent price updates: ${e.toString()}');
    }
  }

  @override
  Future<List<String>> getSearchSuggestions({
    required String query,
    int limit = 5,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      
      // Mock search suggestions
      final allProducts = ProductModel.getMockProducts();
      final suggestions = allProducts
          .where((product) => 
              product.name.toLowerCase().contains(query.toLowerCase()))
          .map((product) => product.name)
          .take(limit)
          .toList();
      
      // Add some common search terms
      if (query.length >= 2) {
        final commonTerms = [
          'Tomatoes',
          'Onions',
          'Potatoes',
          'Rice',
          'Bread',
          'Milk',
          'Eggs',
          'Chicken',
          'Phone',
          'Laptop',
        ].where((term) => 
            term.toLowerCase().contains(query.toLowerCase()) &&
            !suggestions.contains(term))
         .take(limit - suggestions.length);
        
        suggestions.addAll(commonTerms);
      }
      
      return suggestions;
      
      // Production implementation would use Algolia or similar search service
    } catch (e) {
      throw ServerException(message: 'Failed to get search suggestions: ${e.toString()}');
    }
  }

  @override
  Future<List<ProductModel>> searchProducts({
    required String query,
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    bool ascending = true,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      
      var results = ProductModel.getMockProducts();
      
      // Filter by search query
      if (query.isNotEmpty) {
        results = results.where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()) ||
            product.category.toLowerCase().contains(query.toLowerCase())
        ).toList();
      }
      
      // Filter by category
      if (categoryId != null) {
        results = results.where((product) => 
            product.category == categoryId).toList();
      }
      
      // Filter by price range
      if (minPrice != null) {
        results = results.where((product) => 
            product.averagePrice >= minPrice).toList();
      }
      
      if (maxPrice != null) {
        results = results.where((product) => 
            product.averagePrice <= maxPrice).toList();
      }
      
      // Sort results
      if (sortBy != null) {
        switch (sortBy) {
          case 'price':
            results.sort((a, b) => ascending 
                ? a.averagePrice.compareTo(b.averagePrice)
                : b.averagePrice.compareTo(a.averagePrice));
            break;
          case 'name':
            results.sort((a, b) => ascending 
                ? a.name.compareTo(b.name)
                : b.name.compareTo(a.name));
            break;
          case 'updated':
            results.sort((a, b) => ascending 
                ? a.lastUpdated.compareTo(b.lastUpdated)
                : b.lastUpdated.compareTo(a.lastUpdated));
            break;
          case 'popularity':
            results.sort((a, b) => ascending 
                ? a.priceSubmissions.compareTo(b.priceSubmissions)
                : b.priceSubmissions.compareTo(a.priceSubmissions));
            break;
        }
      }
      
      // Pagination
      final startIndex = (page - 1) * limit;
      final endIndex = startIndex + limit;
      
      if (startIndex >= results.length) {
        return [];
      }
      
      return results.sublist(
        startIndex,
        endIndex > results.length ? results.length : endIndex,
      );
      
      // Production implementation would use proper search indexing
    } catch (e) {
      throw ServerException(message: 'Failed to search products: ${e.toString()}');
    }
  }

  // Helper method for calculating distance (simplified)
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    // This is a simplified distance calculation
    // In production, use a proper geospatial library
    const double earthRadius = 6371; // km
    
    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);
    
    final double a = 
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(lat1)) * 
        math.cos(_degreesToRadians(lat2)) * 
        math.sin(dLon / 2) * math.sin(dLon / 2);
    
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }
}

