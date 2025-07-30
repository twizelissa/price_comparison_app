import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/store.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Product>>> getTrendingProducts({int limit = 10}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final productModels = await remoteDataSource.getTrendingProducts(limit: limit);
      final products = productModels.map((model) => model.toEntity()).toList();
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Store>>> getNearbyStores({
    required double latitude,
    required double longitude,
    double radiusInKm = 10.0,
    int limit = 20,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final storeModels = await remoteDataSource.getNearbyStores(
        latitude: latitude,
        longitude: longitude,
        radiusInKm: radiusInKm,
        limit: limit,
      );
      final stores = storeModels.map((model) => model.toEntity()).toList();
      return Right(stores);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();
      return Right(categories);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get categories: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getPopularCategories() async {
    try {
      final categories = await remoteDataSource.getPopularCategories();
      return Right(categories);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get popular categories: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getRecentPriceUpdates({int limit = 10}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final productModels = await remoteDataSource.getRecentPriceUpdates(limit: limit);
      final products = productModels.map((model) => model.toEntity()).toList();
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get recent price updates: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getSearchSuggestions({
    required String query,
    int limit = 5,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final suggestions = await remoteDataSource.getSearchSuggestions(
        query: query,
        limit: limit,
      );
      return Right(suggestions);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get search suggestions: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> searchProducts({
    required String query,
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    bool ascending = true,
    int page = 1,
    int limit = 20,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final productModels = await remoteDataSource.searchProducts(
        query: query,
        categoryId: categoryId,
        minPrice: minPrice,
        maxPrice: maxPrice,
        sortBy: sortBy,
        ascending: ascending,
        page: page,
        limit: limit,
      );
      final products = productModels.map((model) => model.toEntity()).toList();
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to search products: ${e.toString()}'));
    }
  }

  // Not implemented methods (would be implemented based on requirements)
  @override
  Future<Either<Failure, List<Product>>> getProductsByCategory({
    required String categoryId,
    int page = 1,
    int limit = 20,
  }) async {
    return const Left(ServerFailure(message: 'Get products by category not implemented'));
  }

  @override
  Future<Either<Failure, Store>> getStoreById({required String storeId}) async {
    return const Left(ServerFailure(message: 'Get store by ID not implemented'));
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByStore({
    required String storeId,
    int page = 1,
    int limit = 20,
  }) async {
    return const Left(ServerFailure(message: 'Get products by store not implemented'));
  }

  @override
  Future<Either<Failure, List<Product>>> getRecommendedProducts({
    String? userId,
    int limit = 10,
  }) async {
    return const Left(ServerFailure(message: 'Get recommended products not implemented'));
  }

  @override
  Future<Either<Failure, DashboardStats>> getDashboardStats() async {
    return const Left(ServerFailure(message: 'Get dashboard stats not implemented'));
  }

  @override
  Future<Either<Failure, List<Store>>> getFeaturedStores({int limit = 5}) async {
    return const Left(ServerFailure(message: 'Get featured stores not implemented'));
  }

  @override
  Future<Either<Failure, List<PriceAlert>>> getUserPriceAlerts({
    required String userId,
  }) async {
    return const Left(ServerFailure(message: 'Get user price alerts not implemented'));
  }

  @override
  Future<Either<Failure, void>> saveProduct({
    required String userId,
    required String productId,
  }) async {
    return const Left(ServerFailure(message: 'Save product not implemented'));
  }

  @override
  Future<Either<Failure, void>> unsaveProduct({
    required String userId,
    required String productId,
  }) async {
    return const Left(ServerFailure(message: 'Unsave product not implemented'));
  }

  @override
  Future<Either<Failure, List<Product>>> getSavedProducts({
    required String userId,
    int page = 1,
    int limit = 20,
  }) async {
    return const Left(ServerFailure(message: 'Get saved products not implemented'));
  }

  @override
  Future<Either<Failure, void>> reportStore({
    required String storeId,
    required String reason,
    String? description,
  }) async {
    return const Left(ServerFailure(message: 'Report store not implemented'));
  }

  @override
  Future<Either<Failure, void>> reportProduct({
    required String productId,
    required String reason,
    String? description,
  }) async {
    return const Left(ServerFailure(message: 'Report product not implemented'));
  }
}