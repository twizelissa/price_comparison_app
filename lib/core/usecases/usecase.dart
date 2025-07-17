import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

abstract class StreamUseCase<Type, Params> {
  Stream<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}

class PaginationParams extends Equatable {
  final int page;
  final int limit;
  final Map<String, dynamic>? filters;
  final String? searchQuery;

  const PaginationParams({
    this.page = 1,
    this.limit = 20,
    this.filters,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [page, limit, filters, searchQuery];

  PaginationParams copyWith({
    int? page,
    int? limit,
    Map<String, dynamic>? filters,
    String? searchQuery,
  }) {
    return PaginationParams(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      filters: filters ?? this.filters,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}