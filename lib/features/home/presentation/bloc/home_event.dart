import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomeDataEvent extends HomeEvent {}

class RefreshHomeDataEvent extends HomeEvent {}

class GetTrendingProductsEvent extends HomeEvent {
  final int limit;

  const GetTrendingProductsEvent({this.limit = 10});

  @override
  List<Object> get props => [limit];
}

class GetNearbyStoresEvent extends HomeEvent {
  final double? latitude;
  final double? longitude;
  final double radiusInKm;
  final int limit;

  const GetNearbyStoresEvent({
    this.latitude,
    this.longitude,
    this.radiusInKm = 10.0,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [latitude, longitude, radiusInKm, limit];
}

class GetCategoriesEvent extends HomeEvent {}

class GetPopularCategoriesEvent extends HomeEvent {}

class SearchProductsEvent extends HomeEvent {
  final String query;
  final String? categoryId;
  final double? minPrice;
  final double? maxPrice;
  final String? sortBy;
  final bool ascending;
  final int page;
  final int limit;

  const SearchProductsEvent({
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

class GetSearchSuggestionsEvent extends HomeEvent {
  final String query;
  final int limit;

  const GetSearchSuggestionsEvent({
    required this.query,
    this.limit = 5,
  });

  @override
  List<Object> get props => [query, limit];
}

class ClearSearchEvent extends HomeEvent {}

class GetRecentPriceUpdatesEvent extends HomeEvent {
  final int limit;

  const GetRecentPriceUpdatesEvent({this.limit = 10});

  @override
  List<Object> get props => [limit];
}

class GetProductsByCategoryEvent extends HomeEvent {
  final String categoryId;
  final int page;
  final int limit;

  const GetProductsByCategoryEvent({
    required this.categoryId,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object> get props => [categoryId, page, limit];
}

class GetStoreDetailsEvent extends HomeEvent {
  final String storeId;

  const GetStoreDetailsEvent({required this.storeId});

  @override
  List<Object> get props => [storeId];
}

class UpdateUserLocationEvent extends HomeEvent {
  final double latitude;
  final double longitude;

  const UpdateUserLocationEvent({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [latitude, longitude];
}

class RequestLocationPermissionEvent extends HomeEvent {}

class SaveProductEvent extends HomeEvent {
  final String productId;

  const SaveProductEvent({required this.productId});

  @override
  List<Object> get props => [productId];
}

class UnsaveProductEvent extends HomeEvent {
  final String productId;

  const UnsaveProductEvent({required this.productId});

  @override
  List<Object> get props => [productId];
}

class ClearHomeErrorEvent extends HomeEvent {}
