import '../../../authentication/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    super.profileImageUrl,
    super.createdAt,
    super.lastSignIn,
    super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      profileImageUrl: json['profileImageUrl'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'])
          : null,
      lastSignIn: json['lastSignIn'] != null 
          ? DateTime.parse(json['lastSignIn'])
          : null,
      role: _parseRole(json['role']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt?.toIso8601String(),
      'lastSignIn': lastSignIn?.toIso8601String(),
      'role': role.name,
    };
  }

  static UserRole _parseRole(dynamic roleValue) {
    if (roleValue == null) return UserRole.user;
    if (roleValue is String) {
      return roleValue.toLowerCase() == 'admin' ? UserRole.admin : UserRole.user;
    }
    return UserRole.user;
  }

  // Create admin user model
  factory UserModel.admin({
    required String id,
    required String email,
    String firstName = 'Admin',
    String lastName = 'User',
  }) {
    return UserModel(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      role: UserRole.admin,
      createdAt: DateTime.now(),
      lastSignIn: DateTime.now(),
    );
  }
}
