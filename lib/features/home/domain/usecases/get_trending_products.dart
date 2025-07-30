import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/home_repository.dart';

class GetTrendingProducts implements UseCase<List<Product>, GetTrendingProductsParams> {
  final HomeRepository repository;

  GetTrendingProducts(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(GetTrendingProductsParams params) async {
    return await repository.getTrendingProducts(
      limit: params.limit,
    );
  }
}

class GetTrendingProductsParams extends Equatable {
  final int limit;

  const GetTrendingProductsParams({
    this.limit = 10,
  });

  @override
  List<Object> get props => [limit];
}