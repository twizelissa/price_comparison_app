import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.category,
    super.description,
    super.imageUrl,
    required super.averagePrice,
    super.minPrice,
    super.maxPrice,
    super.unit,
    super.priceSubmissions,
    required super.lastUpdated,
    super.isTrending,
    super.priceChange,
    super.priceDirection,
    super.stores,
    super.status,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      description: json['description'],
      imageUrl: json['imageUrl'],
      averagePrice: (json['averagePrice'] ?? 0).toDouble(),
      minPrice: json['minPrice']?.toDouble(),
      maxPrice: json['maxPrice']?.toDouble(),
      unit: json['unit'] ?? 'piece',
      priceSubmissions: json['priceSubmissions'] ?? 0,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
      isTrending: json['isTrending'] ?? false,
      priceChange: json['priceChange']?.toDouble(),
      priceDirection: _parsePriceDirection(json['priceDirection']),
      stores: json['stores'] != null
          ? List<String>.from(json['stores'])
          : [],
      status: _parseProductStatus(json['status']),
    );
  }

  factory ProductModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    return ProductModel(
      id: documentId,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      description: data['description'],
      imageUrl: data['imageUrl'],
      averagePrice: (data['averagePrice'] ?? 0).toDouble(),
      minPrice: data['minPrice']?.toDouble(),
      maxPrice: data['maxPrice']?.toDouble(),
      unit: data['unit'] ?? 'piece',
      priceSubmissions: data['priceSubmissions'] ?? 0,
      lastUpdated: data['lastUpdated'] != null
          ? (data['lastUpdated'] as dynamic).toDate()
          : DateTime.now(),
      isTrending: data['isTrending'] ?? false,
      priceChange: data['priceChange']?.toDouble(),
      priceDirection: _parsePriceDirection(data['priceDirection']),
      stores: data['stores'] != null
          ? List<String>.from(data['stores'])
          : [],
      status: _parseProductStatus(data['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'imageUrl': imageUrl,
      'averagePrice': averagePrice,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'unit': unit,
      'priceSubmissions': priceSubmissions,
      'lastUpdated': lastUpdated.toIso8601String(),
      'isTrending': isTrending,
      'priceChange': priceChange,
      'priceDirection': priceDirection.name,
      'stores': stores,
      'status': status.name,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'category': category,
      'description': description,
      'imageUrl': imageUrl,
      'averagePrice': averagePrice,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'unit': unit,
      'priceSubmissions': priceSubmissions,
      'lastUpdated': lastUpdated,
      'isTrending': isTrending,
      'priceChange': priceChange,
      'priceDirection': priceDirection.name,
      'stores': stores,
      'status': status.name,
    };
  }

  ProductModel copyWith({
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
    return ProductModel(
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

  Product toEntity() {
    return Product(
      id: id,
      name: name,
      category: category,
      description: description,
      imageUrl: imageUrl,
      averagePrice: averagePrice,
      minPrice: minPrice,
      maxPrice: maxPrice,
      unit: unit,
      priceSubmissions: priceSubmissions,
      lastUpdated: lastUpdated,
      isTrending: isTrending,
      priceChange: priceChange,
      priceDirection: priceDirection,
      stores: stores,
      status: status,
    );
  }

  static PriceChangeDirection _parsePriceDirection(dynamic direction) {
    if (direction == null) return PriceChangeDirection.stable;
    
    if (direction is String) {
      switch (direction.toLowerCase()) {
        case 'up':
          return PriceChangeDirection.up;
        case 'down':
          return PriceChangeDirection.down;
        default:
          return PriceChangeDirection.stable;
      }
    }
    
    return PriceChangeDirection.stable;
  }

  static ProductStatus _parseProductStatus(dynamic status) {
    if (status == null) return ProductStatus.active;
    
    if (status is String) {
      switch (status.toLowerCase()) {
        case 'inactive':
          return ProductStatus.inactive;
        case 'discontinued':
          return ProductStatus.discontinued;
        default:
          return ProductStatus.active;
      }
    }
    
    return ProductStatus.active;
  }

  // Mock data for development
  static List<ProductModel> getMockProducts() {
    return [
      ProductModel(
        id: '1',
        name: 'Fresh Tomatoes',
        category: 'food',
        description: 'Fresh red tomatoes from local farmers',
        averagePrice: 500,
        minPrice: 400,
        maxPrice: 600,
        unit: 'kg',
        priceSubmissions: 15,
        lastUpdated: DateTime.now().subtract(const Duration(hours: 2)),
        isTrending: true,
        priceChange: -5.2,
        priceDirection: PriceChangeDirection.down,
        stores: ['store1', 'store2', 'store3'],
      ),
      ProductModel(
        id: '2',
        name: "Men's T-shirts",
        category: 'clothing',
        description: 'Cotton T-shirts for men',
        averagePrice: 10000,
        minPrice: 8000,
        maxPrice: 15000,
        unit: 'piece',
        priceSubmissions: 8,
        lastUpdated: DateTime.now().subtract(const Duration(hours: 5)),
        isTrending: true,
        priceChange: 2.1,
        priceDirection: PriceChangeDirection.up,
        stores: ['store2', 'store4'],
      ),
      ProductModel(
        id: '3',
        name: 'Samsung Galaxy Phone',
        category: 'electronics',
        description: 'Latest Samsung smartphone',
        averagePrice: 450000,
        minPrice: 420000,
        maxPrice: 500000,
        unit: 'piece',
        priceSubmissions: 12,
        lastUpdated: DateTime.now().subtract(const Duration(days: 1)),
        isTrending: false,
        priceChange: 0.0,
        priceDirection: PriceChangeDirection.stable,
        stores: ['store1', 'store3', 'store5'],
      ),
    ];
  }

  static ProductModel empty() {
    return ProductModel(
      id: '',
      name: '',
      category: '',
      averagePrice: 0,
      lastUpdated: DateTime.now(),
    );
  }

  bool get isEmpty => id.isEmpty && name.isEmpty;
  bool get isNotEmpty => !isEmpty;
}