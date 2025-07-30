import 'package:equatable/equatable.dart';

class Store extends Equatable {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double? distanceFromUser; // In kilometers
  final String? phoneNumber;
  final String? description;
  final String? imageUrl;
  final StoreType type;
  final List<String> categories; // Products categories available
  final double rating;
  final int totalReviews;
  final bool hasFairPricing;
  final DateTime? openTime;
  final DateTime? closeTime;
  final List<String> openDays;
  final StoreStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Store({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.distanceFromUser,
    this.phoneNumber,
    this.description,
    this.imageUrl,
    this.type = StoreType.market,
    this.categories = const [],
    this.rating = 0.0,
    this.totalReviews = 0,
    this.hasFairPricing = false,
    this.openTime,
    this.closeTime,
    this.openDays = const [],
    this.status = StoreStatus.active,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        latitude,
        longitude,
        distanceFromUser,
        phoneNumber,
        description,
        imageUrl,
        type,
        categories,
        rating,
        totalReviews,
        hasFairPricing,
        openTime,
        closeTime,
        openDays,
        status,
        createdAt,
        updatedAt,
      ];

  Store copyWith({
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
    return Store(
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

  // Helper getters
  String get formattedDistance {
    if (distanceFromUser == null) return '';
    if (distanceFromUser! < 1) {
      return '${(distanceFromUser! * 1000).round()}m';
    }
    return '${distanceFromUser!.toStringAsFixed(1)}km';
  }

  String get formattedRating {
    if (totalReviews == 0) return 'No ratings';
    return '${rating.toStringAsFixed(1)} (${totalReviews} reviews)';
  }

  bool get isNearby => distanceFromUser != null && distanceFromUser! <= 5.0;

  bool get isOpen {
    if (openTime == null || closeTime == null) return true;
    
    final now = DateTime.now();
    final currentDay = _getCurrentDayName();
    
    if (!openDays.contains(currentDay)) return false;
    
    final currentTime = TimeOfDay.fromDateTime(now);
    final openTimeOfDay = TimeOfDay.fromDateTime(openTime!);
    final closeTimeOfDay = TimeOfDay.fromDateTime(closeTime!);
    
    return _isTimeInRange(currentTime, openTimeOfDay, closeTimeOfDay);
  }

  String get operatingHours {
    if (openTime == null || closeTime == null) return 'Hours not specified';
    
    final openHour = TimeOfDay.fromDateTime(openTime!);
    final closeHour = TimeOfDay.fromDateTime(closeTime!);
    
    return '${openHour.format(null)} - ${closeHour.format(null)}';
  }

  String _getCurrentDayName() {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[DateTime.now().weekday - 1];
  }

  bool _isTimeInRange(TimeOfDay current, TimeOfDay start, TimeOfDay end) {
    final currentMinutes = current.hour * 60 + current.minute;
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    
    if (startMinutes <= endMinutes) {
      return currentMinutes >= startMinutes && currentMinutes <= endMinutes;
    } else {
      // Spans midnight
      return currentMinutes >= startMinutes || currentMinutes <= endMinutes;
    }
  }
}

enum StoreType {
  market,
  supermarket,
  shop,
  mall,
  pharmacy,
  restaurant,
  other,
}

enum StoreStatus {
  active,
  inactive,
  closed,
  pending,
}

extension StoreTypeExtension on StoreType {
  String get displayName {
    switch (this) {
      case StoreType.market:
        return 'Market';
      case StoreType.supermarket:
        return 'Supermarket';
      case StoreType.shop:
        return 'Shop';
      case StoreType.mall:
        return 'Mall';
      case StoreType.pharmacy:
        return 'Pharmacy';
      case StoreType.restaurant:
        return 'Restaurant';
      case StoreType.other:
        return 'Other';
    }
  }

  String get icon {
    switch (this) {
      case StoreType.market:
        return '🏪';
      case StoreType.supermarket:
        return '🏬';
      case StoreType.shop:
        return '🏪';
      case StoreType.mall:
        return '🏢';
      case StoreType.pharmacy:
        return '💊';
      case StoreType.restaurant:
        return '🍽️';
      case StoreType.other:
        return '🏪';
    }
  }
}

extension StoreStatusExtension on StoreStatus {
  String get displayName {
    switch (this) {
      case StoreStatus.active:
        return 'Open';
      case StoreStatus.inactive:
        return 'Temporarily Closed';
      case StoreStatus.closed:
        return 'Closed';
      case StoreStatus.pending:
        return 'Pending Approval';
    }
  }

  bool get isOperational => this == StoreStatus.active;
}