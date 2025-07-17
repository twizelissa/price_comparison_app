import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String phoneNumber;
  final String? location;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final int priceSubmissions;
  final int savedProducts;
  final UserRole role;
  final UserStatus status;

  const User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    this.location,
    this.profileImageUrl,
    required this.createdAt,
    this.updatedAt,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    this.priceSubmissions = 0,
    this.savedProducts = 0,
    this.role = UserRole.user,
    this.status = UserStatus.active,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        fullName,
        phoneNumber,
        location,
        profileImageUrl,
        createdAt,
        updatedAt,
        isEmailVerified,
        isPhoneVerified,
        priceSubmissions,
        savedProducts,
        role,
        status,
      ];

  User copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phoneNumber,
    String? location,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    int? priceSubmissions,
    int? savedProducts,
    UserRole? role,
    UserStatus? status,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      location: location ?? this.location,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      priceSubmissions: priceSubmissions ?? this.priceSubmissions,
      savedProducts: savedProducts ?? this.savedProducts,
      role: role ?? this.role,
      status: status ?? this.status,
    );
  }

  // Helper getters
  bool get isVerified => isEmailVerified && isPhoneVerified;
  String get displayName => fullName.isNotEmpty ? fullName : email;
  String get initials {
    if (fullName.isEmpty) return email.substring(0, 1).toUpperCase();
    List<String> names = fullName.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return fullName.substring(0, 1).toUpperCase();
  }
}

enum UserRole {
  user,
  moderator,
  admin,
}

enum UserStatus {
  active,
  inactive,
  suspended,
  deleted,
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.user:
        return 'User';
      case UserRole.moderator:
        return 'Moderator';
      case UserRole.admin:
        return 'Admin';
    }
  }
}

extension UserStatusExtension on UserStatus {
  String get displayName {
    switch (this) {
      case UserStatus.active:
        return 'Active';
      case UserStatus.inactive:
        return 'Inactive';
      case UserStatus.suspended:
        return 'Suspended';
      case UserStatus.deleted:
        return 'Deleted';
    }
  }

  bool get isActive => this == UserStatus.active;
}