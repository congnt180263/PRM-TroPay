// Building Model for TroPay Application
// Contains address, contact, utilities, and building entities used across the app.

/// Represents the complete address of a building
class AddressModel {
  final String street;
  final String ward;
  final String district;
  final String city;
  final String province;

  AddressModel({
    required this.street,
    required this.ward,
    required this.district,
    required this.city,
    required this.province,
  });

  /// Creates an AddressModel from JSON data
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      street: json['street'] ?? '',
      ward: json['ward'] ?? '',
      district: json['district'] ?? '',
      city: json['city'] ?? '',
      province: json['province'] ?? '',
    );
  }

  /// Converts the AddressModel to JSON format
  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'ward': ward,
      'district': district,
      'city': city,
      'province': province,
    };
  }

  /// Returns the complete formatted address
  String get fullAddress => '$street, $ward, $district, $city, $province';

  /// Returns a shortened version of the address
  String get shortAddress => '$district, $city';
}

/// Represents contact information for a building
class ContactInfoModel {
  final String phone;
  final String? email;
  final String? emergencyContact;

  ContactInfoModel({
    required this.phone,
    this.email,
    this.emergencyContact,
  });

  /// Creates a ContactInfoModel from JSON data
  factory ContactInfoModel.fromJson(Map<String, dynamic> json) {
    return ContactInfoModel(
      phone: json['phone'] ?? '',
      email: json['email'],
      emergencyContact: json['emergencyContact'],
    );
  }

  /// Converts the ContactInfoModel to JSON format
  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      if (email != null) 'email': email,
      if (emergencyContact != null) 'emergencyContact': emergencyContact,
    };
  }
}

/// Represents utility pricing information for a building
class UtilitiesModel {
  final double electricityPrice; // VND per kWh
  final double waterPrice; // VND per m³
  final double internetPrice; // VND per month

  UtilitiesModel({
    required this.electricityPrice,
    required this.waterPrice,
    required this.internetPrice,
  });

  /// Creates a UtilitiesModel from JSON data
  factory UtilitiesModel.fromJson(Map<String, dynamic> json) {
    return UtilitiesModel(
      electricityPrice: (json['electricityPrice'] ?? 0).toDouble(),
      waterPrice: (json['waterPrice'] ?? 0).toDouble(),
      internetPrice: (json['internetPrice'] ?? 0).toDouble(),
    );
  }

  /// Converts the UtilitiesModel to JSON format
  Map<String, dynamic> toJson() {
    return {
      'electricityPrice': electricityPrice,
      'waterPrice': waterPrice,
      'internetPrice': internetPrice,
    };
  }
}

/// Main building model representing a rental property
class BuildingModel {
  final String id;
  final String ownerId;
  final String buildingName;
  final AddressModel address;
  final int totalFloors;
  final int totalRooms;
  final String buildingType; // 'apartment', 'house', 'dormitory'
  final List<String> commonAmenities;
  final String? description;
  final List<String> images;
  final ContactInfoModel contactInfo;
  final UtilitiesModel utilities;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  BuildingModel({
    required this.id,
    required this.ownerId,
    required this.buildingName,
    required this.address,
    required this.totalFloors,
    required this.totalRooms,
    required this.buildingType,
    required this.commonAmenities,
    this.description,
    required this.images,
    required this.contactInfo,
    required this.utilities,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a BuildingModel from JSON data
  factory BuildingModel.fromJson(Map<String, dynamic> json) {
    // Helper function to safely convert to List<String>
    List<String> toStringList(dynamic value) {
      if (value == null) return [];
      if (value is List) {
        return value
            .map((e) => e is String ? e : (e is Map ? '' : e.toString()))
            .where((e) => e.isNotEmpty)
            .toList();
      }
      return [];
    }

    // Helper function to safely extract ID from ownerId
    // Backend may return ownerId as String or as populated Object
    String extractOwnerId(dynamic ownerId) {
      if (ownerId == null) return '';
      if (ownerId is String) return ownerId;
      if (ownerId is Map) {
        // If ownerId is a populated User object, extract _id
        return ownerId['_id']?.toString() ?? ownerId['id']?.toString() ?? '';
      }
      return ownerId.toString();
    }

    return BuildingModel(
      id: json['id'] ?? json['_id'] ?? '',
      ownerId: extractOwnerId(json['ownerId']),
      buildingName: json['buildingName'] ?? '',
      address: AddressModel.fromJson(json['address'] ?? {}),
      totalFloors: json['totalFloors'] ?? 0,
      totalRooms: json['totalRooms'] ?? 0,
      buildingType: json['buildingType'] ?? 'apartment',
      commonAmenities: toStringList(json['commonAmenities']),
      description: json['description'],
      images: toStringList(json['images']),
      contactInfo: ContactInfoModel.fromJson(json['contactInfo'] ?? {}),
      utilities: UtilitiesModel.fromJson(json['utilities'] ?? {}),
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  /// Converts the BuildingModel to JSON format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'buildingName': buildingName,
      'address': address.toJson(),
      'totalFloors': totalFloors,
      'totalRooms': totalRooms,
      'buildingType': buildingType,
      'commonAmenities': commonAmenities,
      if (description != null) 'description': description,
      'images': images,
      'contactInfo': contactInfo.toJson(),
      'utilities': utilities.toJson(),
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Returns a localized display name for building type
  String get buildingTypeDisplay {
    switch (buildingType) {
      case 'apartment':
        return 'Chung cư';
      case 'house':
        return 'Nhà trọ';
      case 'dormitory':
        return 'Ký túc xá';
      default:
        return buildingType;
    }
  }

  /// Checks if the building has a specific amenity
  bool hasAmenity(String amenity) => commonAmenities.contains(amenity);

  /// Creates a copy of this BuildingModel with updated fields
  BuildingModel copyWith({
    String? id,
    String? ownerId,
    String? buildingName,
    AddressModel? address,
    int? totalFloors,
    int? totalRooms,
    String? buildingType,
    List<String>? commonAmenities,
    String? description,
    List<String>? images,
    ContactInfoModel? contactInfo,
    UtilitiesModel? utilities,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BuildingModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      buildingName: buildingName ?? this.buildingName,
      address: address ?? this.address,
      totalFloors: totalFloors ?? this.totalFloors,
      totalRooms: totalRooms ?? this.totalRooms,
      buildingType: buildingType ?? this.buildingType,
      commonAmenities: commonAmenities ?? this.commonAmenities,
      description: description ?? this.description,
      images: images ?? this.images,
      contactInfo: contactInfo ?? this.contactInfo,
      utilities: utilities ?? this.utilities,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Represents statistical data for a building
class BuildingStatsModel {
  final int totalRooms;
  final int occupiedRooms;
  final int availableRooms;
  final int maintenanceRooms;
  final double occupancyRate;

  BuildingStatsModel({
    required this.totalRooms,
    required this.occupiedRooms,
    required this.availableRooms,
    required this.maintenanceRooms,
    required this.occupancyRate,
  });

  /// Creates a BuildingStatsModel from JSON data
  factory BuildingStatsModel.fromJson(Map<String, dynamic> json) {
    return BuildingStatsModel(
      totalRooms: json['totalRooms'] ?? 0,
      occupiedRooms: json['occupiedRooms'] ?? 0,
      availableRooms: json['availableRooms'] ?? 0,
      maintenanceRooms: json['maintenanceRooms'] ?? 0,
      occupancyRate: (json['occupancyRate'] ?? 0).toDouble(),
    );
  }

  /// Returns a formatted display string for occupancy rate
  String get occupancyRateDisplay => '${occupancyRate.toStringAsFixed(1)}%';
}
