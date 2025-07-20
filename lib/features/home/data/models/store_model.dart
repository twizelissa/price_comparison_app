import '../../domain/entities/store.dart';

class StoreModel extends Store {
  const StoreModel({
    required super.id,
    required super.name,
    required super.address,
    required super.latitude,
    required super.longitude,
    super.distanceFromUser,
    super.phoneNumber,
    super.description,
    super.imageUrl,
    super.type,
    super.categories,
    super.rating,
    super.totalReviews,
    super.hasFairPricing,
    super.openTime,
    super.closeTime,
    super.openDays,
    super.status,
    required super.createdAt,
    super.updatedAt,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      distanceFromUser: json['distanceFromUser']?.toDouble(),
      phoneNumber: json['phoneNumber'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      type: _parseStoreType(json['type']),
      categories: json['categories'] != null
          ? List<String>.from(json['categories'])
          : [],
      rating: (json['rating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      hasFairPricing: json['hasFairPricing'] ?? false,
      openTime: json['openTime'] != null
          ? DateTime.parse(json['openTime'])
          : null,
      closeTime: json['closeTime'] != null
          ? DateTime.parse(json['closeTime'])
          : null,
      openDays: json['openDays'] != null
          ? List<String>.from(json['openDays'])
          : [],
      status: _parseStoreStatus(json['status']),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  factory StoreModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    return StoreModel(
      id: documentId,
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      latitude: (data['latitude'] ?? 0).toDouble(),
      longitude: (data['longitude'] ?? 0).toDouble(),
      distanceFromUser: data['distanceFromUser']?.toDouble(),
      phoneNumber: data['phoneNumber'],
      description: data['description'],
      imageUrl: data['imageUrl'],
      type: _parseStoreType(data['type']),
      categories: data['categories'] != null
          ? List<String>.from(data['categories'])
          : [],
      rating: (data['rating'] ?? 0).toDouble(),
      totalReviews: data['totalReviews'] ?? 0,
      hasFairPricing: data['hasFairPricing'] ?? false,
      openTime: data['openTime'] != null
          ? (data['openTime'] as dynamic).toDate()
          : null,
      closeTime: data['closeTime'] != null
          ? (data['closeTime'] as dynamic).toDate()
          : null,
      openDays: data['openDays'] != null
          ? List<String>.from(data['openDays'])
          : [],
      status: _parseStoreStatus(data['status']),
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as dynamic).toDate()
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as dynamic).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'distanceFromUser': distanceFromUser,
      'phoneNumber': phoneNumber,
      'description': description,
      'imageUrl': imageUrl,
      'type': type.name,
      'categories': categories,
      'rating': rating,
      'totalReviews': totalReviews,
      'hasFairPricing': hasFairPricing,
      'openTime': openTime?.toIso8601String(),
      'closeTime': closeTime?.toIso8601String(),
      'openDays': openDays,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'distanceFromUser': distanceFromUser,
      'phoneNumber': phoneNumber,
      'description': description,
      'imageUrl': imageUrl,
      'type': type.name,
      'categories': categories,
      'rating': rating,
      'totalReviews': totalReviews,
      'hasFairPricing': hasFairPricing,
      'openTime': openTime,
      'closeTime': closeTime,
      'openDays': openDays,
      'status': status.name,
      'createdAt': createdAt,
      'updatedAt': updatedAt ?? DateTime.now(),
    };
  }

  StoreModel copyWith({
    String? id,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    double? distanceFromUser,
    String? phoneNumber,
    String? description,
    String? imageUrl,
    StoreType? type,
    List<String>? categories,
    double? rating,
    int? totalReviews,
    bool? hasFairPricing,
    DateTime? openTime,
    DateTime? closeTime,
    List<String>? openDays,
    StoreStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StoreModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      distanceFromUser: distanceFromUser ?? this.distanceFromUser,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      categories: categories ?? this.categories,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      hasFairPricing: hasFairPricing ?? this.hasFairPricing,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      openDays: openDays ?? this.openDays,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Store toEntity() {
    return Store(
      id: id,
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
      distanceFromUser: distanceFromUser,
      phoneNumber: phoneNumber,
      description: description,
      imageUrl: imageUrl,
      type: type,
      categories: categories,
      rating: rating,
      totalReviews: totalReviews,
      hasFairPricing: hasFairPricing,
      openTime: openTime,
      closeTime: closeTime,
      openDays: openDays,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static StoreType _parseStoreType(dynamic type) {
    if (type == null) return StoreType.market;
    
    if (type is String) {
      switch (type.toLowerCase()) {
        case 'supermarket':
          return StoreType.supermarket;
        case 'shop':
          return StoreType.shop;
        case 'mall':
          return StoreType.mall;
        case 'pharmacy':
          return StoreType.pharmacy;
        case 'restaurant':
          return StoreType.restaurant;
        case 'other':
          return StoreType.other;
        default:
          return StoreType.market;
      }
    }
    
    return StoreType.market;
  }

  static StoreStatus _parseStoreStatus(dynamic status) {
    if (status == null) return StoreStatus.active;
    
    if (status is String) {
      switch (status.toLowerCase()) {
        case 'inactive':
          return StoreStatus.inactive;
        case 'closed':
          return StoreStatus.closed;
        case 'pending':
          return StoreStatus.pending;
        default:
          return StoreStatus.active;
      }
    }
    
    return StoreStatus.active;
  }

  // Mock data for development
  static List<StoreModel> getMockStores() {
    return [
      StoreModel(
        id: '1',
        name: 'Kimironko Market',
        address: 'Kimironko, Gasabo, Kigali',
        latitude: -1.944,
        longitude: 30.106,
        distanceFromUser: 1.2,
        type: StoreType.market,
        categories: ['food', 'groceries'],
        rating: 4.5,
        totalReviews: 128,
        hasFairPricing: true,
        status: StoreStatus.active,
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
      ),
      StoreModel(
        id: '2',
        name: 'Nyabugogo Market',
        address: 'Nyabugogo, Nyarugenge, Kigali',
        latitude: -1.971,
        longitude: 30.042,
        distanceFromUser: 2.5,
        type: StoreType.market,
        categories: ['food', 'clothing'],
        rating: 4.2,
        totalReviews: 89,
        hasFairPricing: true,
        status: StoreStatus.active,
        createdAt: DateTime.now().subtract(const Duration(days: 300)),
      ),
      StoreModel(
        id: '3',
        name: 'City Mall',
        address: 'City Center, Nyarugenge, Kigali',
        latitude: -1.950,
        longitude: 30.058,
        distanceFromUser: 3.1,
        type: StoreType.mall,
        categories: ['electronics', 'clothing', 'food'],
        rating: 4.0,
        totalReviews: 245,
        hasFairPricing: false,
        status: StoreStatus.active,
        createdAt: DateTime.now().subtract(const Duration(days: 180)),
      ),
    ];
  }

  static StoreModel empty() {
    return StoreModel(
      id: '',
      name: '',
      address: '',
      latitude: 0,
      longitude: 0,
      createdAt: DateTime.now(),
    );
  }

  bool get isEmpty => id.isEmpty && name.isEmpty;
  bool get isNotEmpty => !isEmpty;
}