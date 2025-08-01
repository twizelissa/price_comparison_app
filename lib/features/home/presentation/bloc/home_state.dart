import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];

  bool get hasError => this is HomeError;
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<dynamic> trendingProducts;
  final List<dynamic> nearbyStores;
  final List<dynamic> categories;
  final List<dynamic> recentPriceUpdates;
  final double? userLatitude;
  final double? userLongitude;

  const HomeLoaded({
    required this.trendingProducts,
    required this.nearbyStores,
    required this.categories,
    required this.recentPriceUpdates,
    this.userLatitude,
    this.userLongitude,
  });

  @override
  List<Object?> get props => [
        trendingProducts,
        nearbyStores,
        categories,
        recentPriceUpdates,
        userLatitude,
        userLongitude,
      ];
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object> get props => [message];
}

// Trending Products States
class TrendingProductsLoading extends HomeState {}

class TrendingProductsLoaded extends HomeState {
  final List<dynamic> products;

  const TrendingProductsLoaded({required this.products});

  @override
  List<Object> get props => [products];
}

class TrendingProductsError extends HomeState {
  final String message;

  const TrendingProductsError({required this.message});

  @override
  List<Object> get props => [message];
}

class NoTrendingProducts extends HomeState {}

// Nearby Stores States
class NearbyStoresLoading extends HomeState {}

class NearbyStoresLoaded extends HomeState {
  final List<dynamic> stores;

  const NearbyStoresLoaded({required this.stores});

  @override
  List<Object> get props => [stores];
}

class NearbyStoresError extends HomeState {
  final String message;

  const NearbyStoresError({required this.message});

  @override
  List<Object> get props => [message];
}

class NoNearbyStores extends HomeState {}

// Categories States
class CategoriesLoading extends HomeState {}

class CategoriesLoaded extends HomeState {
  final List<dynamic> categories;

  const CategoriesLoaded({required this.categories});

  @override
  List<Object> get props => [categories];
}

class CategoriesError extends HomeState {
  final String message;

  const CategoriesError({required this.message});

  @override
  List<Object> get props => [message];
}

// Search States
class SearchLoading extends HomeState {}

class SearchResultsLoaded extends HomeState {
  final List<dynamic> products;
  final String query;
  final int totalResults;
  final bool hasMoreResults;

  const SearchResultsLoaded({
    required this.products,
    required this.query,
    required this.totalResults,
    required this.hasMoreResults,
  });

  @override
  List<Object> get props => [products, query, totalResults, hasMoreResults];
}

class SearchError extends HomeState {
  final String message;
  final String query;

  const SearchError({
    required this.message,
    required this.query,
  });

  @override
  List<Object> get props => [message, query];
}

class SearchEmpty extends HomeState {
  final String query;

  const SearchEmpty({required this.query});

  @override
  List<Object> get props => [query];
}

class SearchSuggestionsLoaded extends HomeState {
  final List<String> suggestions;
  final String query;

  const SearchSuggestionsLoaded({
    required this.suggestions,
    required this.query,
  });

  @override
  List<Object> get props => [suggestions, query];
}

// Recent Price Updates States
class RecentPriceUpdatesLoading extends HomeState {}

class RecentPriceUpdatesLoaded extends HomeState {
  final List<dynamic> products;

  const RecentPriceUpdatesLoaded({required this.products});

  @override
  List<Object> get props => [products];
}

// Products by Category States
class ProductsByCategoryLoaded extends HomeState {
  final List<dynamic> products;
  final String categoryId;
  final bool hasMoreResults;

  const ProductsByCategoryLoaded({
    required this.products,
    required this.categoryId,
    required this.hasMoreResults,
  });

  @override
  List<Object> get props => [products, categoryId, hasMoreResults];
}

// Store Details States
class StoreDetailsLoaded extends HomeState {
  final dynamic store;

  const StoreDetailsLoaded({required this.store});

  @override
  List<Object> get props => [store];
}

// Location States
class LocationUpdated extends HomeState {
  final double latitude;
  final double longitude;

  const LocationUpdated({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [latitude, longitude];
}

class LocationError extends HomeState {
  final String message;

  const LocationError({required this.message});

  @override
  List<Object> get props => [message];
}

// Product Save States
class ProductSaved extends HomeState {
  final String productId;

  const ProductSaved({required this.productId});

  @override
  List<Object> get props => [productId];
}

class ProductUnsaved extends HomeState {
  final String productId;

  const ProductUnsaved({required this.productId});

  @override
  List<Object> get props => [productId];
}
