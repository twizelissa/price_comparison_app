import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String? id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final String localImagePath;
  final String storeName;
  final String storeLocation;
  final String storePhoneNumber;
  final String userId;
  final DateTime createdAt;
  final bool isActive;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.localImagePath,
    required this.storeName,
    required this.storeLocation,
    required this.storePhoneNumber,
    required this.userId,
    required this.createdAt,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
      'localImagePath': localImagePath,
      'storeName': storeName,
      'storeLocation': storeLocation,
      'storePhoneNumber': storePhoneNumber,
      'userId': userId,
      'createdAt': Timestamp.fromDate(createdAt),
      'isActive': isActive,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map, String id) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      category: map['category'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      localImagePath: map['localImagePath'] ?? '',
      storeName: map['storeName'] ?? '',
      storeLocation: map['storeLocation'] ?? '',
      storePhoneNumber: map['storePhoneNumber'] ?? '',
      userId: map['userId'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isActive: map['isActive'] ?? true,
    );
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? category,
    String? imageUrl,
    String? localImagePath,
    String? storeName,
    String? storeLocation,
    String? storePhoneNumber,
    String? userId,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      localImagePath: localImagePath ?? this.localImagePath,
      storeName: storeName ?? this.storeName,
      storeLocation: storeLocation ?? this.storeLocation,
      storePhoneNumber: storePhoneNumber ?? this.storePhoneNumber,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}

class FavoriteItem {
  final String? id;
  final String userId;
  final String productId;
  final DateTime createdAt;

  FavoriteItem({
    this.id,
    required this.userId,
    required this.productId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'productId': productId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory FavoriteItem.fromMap(Map<String, dynamic> map, String id) {
    return FavoriteItem(
      id: id,
      userId: map['userId'] ?? '',
      productId: map['productId'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
