import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String displayName;
  final String? description;
  final String? iconUrl;
  final IconData? iconData;
  final Color? color;
  final int productCount;
  final bool isPopular;
  final int sortOrder;
  final CategoryStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Category({
    required this.id,
    required this.name,
    required this.displayName,
    this.description,
    this.iconUrl,
    this.iconData,
    this.color,
    this.productCount = 0,
    this.isPopular = false,
    this.sortOrder = 0,
    this.status = CategoryStatus.active,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        displayName,
        description,
        iconUrl,
        iconData,
        color,
        productCount,
        isPopular,
        sortOrder,
        status,
        createdAt,
        updatedAt,
      ];

  Category copyWith({
    String? id,
    String? name,
    String? displayName,
    String? description,
    String? iconUrl,
    IconData? iconData,
    Color? color,
    int? productCount,
    bool? isPopular,
    int? sortOrder,
    CategoryStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      iconData: iconData ?? this.iconData,
      color: color ?? this.color,
      productCount: productCount ?? this.productCount,
      isPopular: isPopular ?? this.isPopular,
      sortOrder: sortOrder ?? this.sortOrder,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper getters
  String get formattedProductCount {
    if (productCount == 0) return 'No products';
    if (productCount == 1) return '1 product';
    return '$productCount products';
  }

  IconData get displayIcon {
    if (iconData != null) return iconData!;
    
    // Default icons based on category name
    switch (name.toLowerCase()) {
      case 'food':
      case 'groceries':
        return Icons.restaurant;
      case 'electronics':
        return Icons.devices;
      case 'clothing':
      case 'fashion':
        return Icons.checkroom;
      case 'health':
      case 'pharmacy':
        return Icons.local_pharmacy;
      case 'home':
      case 'furniture':
        return Icons.home;
      case 'sports':
        return Icons.sports;
      case 'books':
        return Icons.book;
      case 'toys':
        return Icons.toys;
      case 'automotive':
        return Icons.directions_car;
      case 'beauty':
        return Icons.face;
      default:
        return Icons.category;
    }
  }

  Color get displayColor {
    if (color != null) return color!;
    
    // Default colors based on category name
    switch (name.toLowerCase()) {
      case 'food':
      case 'groceries':
        return Colors.green;
      case 'electronics':
        return Colors.blue;
      case 'clothing':
      case 'fashion':
        return Colors.purple;
      case 'health':
      case 'pharmacy':
        return Colors.red;
      case 'home':
      case 'furniture':
        return Colors.brown;
      case 'sports':
        return Colors.orange;
      case 'books':
        return Colors.teal;
      case 'toys':
        return Colors.pink;
      case 'automotive':
        return Colors.grey;
      case 'beauty':
        return Colors.deepPurple;
      default:
        return Colors.blueGrey;
    }
  }
}

enum CategoryStatus {
  active,
  inactive,
  archived,
}

extension CategoryStatusExtension on CategoryStatus {
  String get displayName {
    switch (this) {
      case CategoryStatus.active:
        return 'Active';
      case CategoryStatus.inactive:
        return 'Inactive';
      case CategoryStatus.archived:
        return 'Archived';
    }
  }

  bool get isActive => this == CategoryStatus.active;
}

// Predefined categories for the app
class AppCategories {
  static const List<Category> defaultCategories = [
    Category(
      id: 'food',
      name: 'food',
      displayName: 'Food & Groceries',
      description: 'Fresh produce, packaged foods, and grocery items',
      iconData: Icons.restaurant,
      color: Colors.green,
      isPopular: true,
      sortOrder: 1,
      createdAt: _defaultDate,
    ),
    Category(
      id: 'electronics',
      name: 'electronics',
      displayName: 'Electronics',
      description: 'Phones, computers, appliances, and electronic devices',
      iconData: Icons.devices,
      color: Colors.blue,
      isPopular: true,
      sortOrder: 2,
      createdAt: _defaultDate,
    ),
    Category(
      id: 'clothing',
      name: 'clothing',
      displayName: 'Clothing & Fashion',
      description: 'Clothes, shoes, accessories, and fashion items',
      iconData: Icons.checkroom,
      color: Colors.purple,
      isPopular: false,
      sortOrder: 3,
      createdAt: _defaultDate,
    ),
    Category(
      id: 'health',
      name: 'health',
      displayName: 'Health & Pharmacy',
      description: 'Medicines, health products, and pharmacy items',
      iconData: Icons.local_pharmacy,
      color: Colors.red,
      isPopular: false,
      sortOrder: 4,
      createdAt: _defaultDate,
    ),
    Category(
      id: 'home',
      name: 'home',
      displayName: 'Home & Garden',
      description: 'Furniture, home decor, and garden supplies',
      iconData: Icons.home,
      color: Colors.brown,
      isPopular: false,
      sortOrder: 5,
      createdAt: _defaultDate,
    ),
    Category(
      id: 'sports',
      name: 'sports',
      displayName: 'Sports & Fitness',
      description: 'Sports equipment, fitness gear, and outdoor activities',
      iconData: Icons.sports,
      color: Colors.orange,
      isPopular: false,
      sortOrder: 6,
      createdAt: _defaultDate,
    ),
  ];

  static const DateTime _defaultDate = DateTime(2024, 1, 1);

  static Category? getCategoryById(String id) {
    try {
      return defaultCategories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  static Category? getCategoryByName(String name) {
    try {
      return defaultCategories.firstWhere(
        (category) => category.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  static List<Category> getPopularCategories() {
    return defaultCategories.where((category) => category.isPopular).toList();
  }

  static List<Category> getAllActiveCategories() {
    return defaultCategories.where((category) => category.status.isActive).toList();
  }
}