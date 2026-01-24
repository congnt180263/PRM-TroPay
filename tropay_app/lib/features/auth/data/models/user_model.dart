class UserModel {
  final String? id;
  final String fullName;
  final String phone;
  final String? email;
  final UserRole role;
  final String? token;
  final String? dateOfBirth;
  final String? identityCard;
  final String? address;

  UserModel({
    this.id,
    required this.fullName,
    required this.phone,
    this.email,
    required this.role,
    this.token,
    this.dateOfBirth,
    this.identityCard,
    this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString(),
      fullName: json['full_name'] ?? json['fullName'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'],
      role: UserRole.fromString(json['role'] ?? 'tenant'),
      token: json['token'],
      dateOfBirth: json['date_of_birth'] ?? json['dateOfBirth'],
      identityCard: json['identity_card'] ?? json['identityCard'],
      address: json['address'],
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
      'date_of_birth': dateOfBirth,
      'identity_card': identityCard,
      'address': address,
    };
  }

  UserModel copyWith({
    String? id,
    String? fullName,
    String? phone,
    String? email,
    UserRole? role,
    String? token,
    String? dateOfBirth,
    String? identityCard,
    String? address,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      role: role ?? this.role,
      token: token ?? this.token,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      identityCard: identityCard ?? this.identityCard,
      address: address ?? this.address,
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
