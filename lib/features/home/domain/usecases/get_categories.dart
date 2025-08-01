import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/category.dart';
import '../repositories/home_repository.dart';
import '../entities/product.dart';
import 'package:equatable/equatable.dart';

class GetCategories extends UseCase<List<Category>, NoParams> {
  final HomeRepository repository;

  GetCategories(this.repository);

  @override
  Future<Either<Failure, List<Category>>> call(NoParams params) async {
    return await repository.getCategories();
  }
}

class GetPopularCategories extends UseCase<List<Category>, NoParams> {
  final HomeRepository repository;

  GetPopularCategories(this.repository);

  @override
  Future<Either<Failure, List<Category>>> call(NoParams params) async {
    return await repository.getPopularCategories();
  }
}

class SearchProducts extends UseCase<List<Product>, SearchProductsParams> {
  final HomeRepository repository;

  SearchProducts(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(SearchProductsParams params) async {
    return await repository.searchProducts(
      query: params.query,
      categoryId: params.categoryId,
      minPrice: params.minPrice,
      maxPrice: params.maxPrice,
      sortBy: params.sortBy,
      ascending: params.ascending,
      page: params.page,
      limit: params.limit,
    );
  }
}

// NoParams class definition
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchProductsParams extends Equatable {
  final String query;
  final String? categoryId;
  final double? minPrice;
  final double? maxPrice;
  final String? sortBy;
  final bool ascending;
  final int page;
  final int limit;

  const SearchProductsParams({
    required this.query,
    this.categoryId,
    this.minPrice,
    this.maxPrice,
    this.sortBy,
    this.ascending = true,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [
        query,
        categoryId,
        minPrice,
        maxPrice,
        sortBy,
        ascending,
        page,
        limit,
      ];
}