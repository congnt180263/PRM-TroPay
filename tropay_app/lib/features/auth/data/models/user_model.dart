class UserModel {
  final String? id;
  final String fullName;
  final String phone;
  final String? email;
  final UserRole role;
  final String? token;

  UserModel({
    this.id,
    required this.fullName,
    required this.phone,
    this.email,
    required this.role,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString(),
      fullName: json['full_name'] ?? json['fullName'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'],
      role: UserRole.fromString(json['role'] ?? 'tenant'),
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'phone': phone,
      'email': email,
      'role': role.value,
      'token': token,
    };
  }

  UserModel copyWith({
    String? id,
    String? fullName,
    String? phone,
    String? email,
    UserRole? role,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      role: role ?? this.role,
      token: token ?? this.token,
    );
  }
}

enum UserRole {
  owner('owner'),
  tenant('tenant');

  final String value;
  const UserRole(this.value);

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => UserRole.tenant,
    );
  }

  String get displayName {
    switch (this) {
      case UserRole.owner:
        return 'Chủ trọ';
      case UserRole.tenant:
        return 'Người thuê';
    }
  }
}
