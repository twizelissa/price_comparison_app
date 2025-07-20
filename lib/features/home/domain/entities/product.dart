import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String category;
  final String? description;
  final String? imageUrl;
  final double averagePrice;
  final double? minPrice;
  final double? maxPrice;
  final String unit; // e.g., "kg", "piece", "liter"
  final int priceSubmissions;
  final DateTime lastUpdated;
  final bool isTrending;
  final double? priceChange; // Percentage change
  final PriceChangeDirection priceDirection;
  final List<String> stores;
  final ProductStatus status;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    this.description,
    this.imageUrl,
    required this.averagePrice,
    this.minPrice,
    this.maxPrice,
    this.unit = 'piece',
    this.priceSubmissions = 0,
    required this.lastUpdated,
    this.isTrending = false,
    this.priceChange,
    this.priceDirection = PriceChangeDirection.stable,
    this.stores = const [],
    this.status = ProductStatus.active,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        category,
        description,
        imageUrl,
        averagePrice,
        minPrice,
        maxPrice,
        unit,
        priceSubmissions,
        lastUpdated,
        isTrending,
        priceChange,
        priceDirection,
        stores,
        status,
      ];

  Product copyWith({
    String? id,
    String? name,
    String? category,
    String? description,
    String? imageUrl,
    double? averagePrice,
    double? minPrice,
    double? maxPrice,
    String? unit,
    int? priceSubmissions,
    DateTime? lastUpdated,
    bool? isTrending,
    double? priceChange,
    PriceChangeDirection? priceDirection,
    List<String>? stores,
    ProductStatus? status,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      averagePrice: averagePrice ?? this.averagePrice,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      unit: unit ?? this.unit,
      priceSubmissions: priceSubmissions ?? this.priceSubmissions,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isTrending: isTrending ?? this.isTrending,
      priceChange: priceChange ?? this.priceChange,
      priceDirection: priceDirection ?? this.priceDirection,
      stores: stores ?? this.stores,
      status: status ?? this.status,
    );
  }

  // Helper getters
  bool get hasPriceData => priceSubmissions > 0;
  
  String get formattedAveragePrice {
    return '${averagePrice.toStringAsFixed(0)} RWF${unit != 'piece' ? '/$unit' : ''}';
  }

  String get priceRangeText {
    if (minPrice == null || maxPrice == null) return formattedAveragePrice;
    if (minPrice == maxPrice) return formattedAveragePrice;
    return '${minPrice!.toStringAsFixed(0)} - ${maxPrice!.toStringAsFixed(0)} RWF${unit != 'piece' ? '/$unit' : ''}';
  }

  String get priceChangeText {
    if (priceChange == null) return '';
    final sign = priceChange! >= 0 ? '+' : '';
    return '$sign${priceChange!.toStringAsFixed(1)}%';
  }

  bool get isPriceIncreasing => priceDirection == PriceChangeDirection.up;
  bool get isPriceDecreasing => priceDirection == PriceChangeDirection.down;
  bool get isPriceStable => priceDirection == PriceChangeDirection.stable;
}

enum PriceChangeDirection {
  up,
  down,
  stable,
}

enum ProductStatus {
  active,
  inactive,
  discontinued,
}

extension PriceChangeDirectionExtension on PriceChangeDirection {
  String get symbol {
    switch (this) {
      case PriceChangeDirection.up:
        return '↑';
      case PriceChangeDirection.down:
        return '↓';
      case PriceChangeDirection.stable:
        return '→';
    }
  }

  String get displayName {
    switch (this) {
      case PriceChangeDirection.up:
        return 'Increasing';
      case PriceChangeDirection.down:
        return 'Decreasing';
      case PriceChangeDirection.stable:
        return 'Stable';
    }
  }
}

extension ProductStatusExtension on ProductStatus {
  String get displayName {
    switch (this) {
      case ProductStatus.active:
        return 'Active';
      case ProductStatus.inactive:
        return 'Inactive';
      case ProductStatus.discontinued:
        return 'Discontinued';
    }
  }

  bool get isActive => this == ProductStatus.active;
}