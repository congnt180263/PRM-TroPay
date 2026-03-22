class RoomModel {
  final String id;
  final String buildingId;
  final String roomNumber;
  final dynamic floor; // Can be int or String
  final double area; // m2
  final double price;
  final int capacity;
  final String status; // 'available', 'occupied', 'maintenance'
  final String? tenantId;
  final String? tenantName;
  final String? tenantPhone;
  final double? deposit;
  final List<String> amenities;
  final String? description;
  final String? imageUrl;
  final DateTime? lastMaintenanceDate;

  RoomModel({
    required this.id,
    required this.buildingId,
    required this.roomNumber,
    required this.floor,
    required this.area,
    required this.price,
    required this.capacity,
    required this.status,
    this.tenantId,
    this.tenantName,
    this.tenantPhone,
    this.deposit,
    required this.amenities,
    this.description,
    this.imageUrl,
    this.lastMaintenanceDate,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    // Helper to safely extract tenant info from nested object or string
    String? _extractTenantField(dynamic tenantData, String field) {
      if (tenantData == null) return null;
      if (tenantData is Map) {
        return tenantData[field]?.toString();
      }
      // If tenantData is just an ID string, we can't extract other fields
      return null;
    }

    // Handle currentTenantId - can be String (ID only) or Map (populated object)
    String? tenantId = json['tenantId'];
    String? tenantName;
    String? tenantPhone;

    final currentTenantData = json['currentTenantId'];
    if (currentTenantData != null) {
      if (currentTenantData is Map) {
        tenantId = currentTenantData['_id']?.toString() ?? currentTenantData['id']?.toString();
        tenantName = currentTenantData['fullName']?.toString();
        tenantPhone = currentTenantData['phoneNumber']?.toString();
      } else if (currentTenantData is String) {
        // If it's just a string ID
        tenantId = currentTenantData;
      }
    }

    return RoomModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      buildingId: json['buildingId']?.toString() ?? '',
      roomNumber: json['roomNumber']?.toString() ?? '',
      floor: json['floor'] ?? '',
      area: (json['area'] ?? 0).toDouble(),
      price: (json['price'] ?? 0).toDouble(),
      capacity: json['capacity'] ?? 1,
      status: json['status']?.toString() ?? 'available',
      tenantId: tenantId ?? json['tenantName'],
      tenantName: tenantName ?? json['tenantName'],
      tenantPhone: tenantPhone ?? json['tenantPhone'],
      deposit: json['deposit'] != null ? (json['deposit'] as num).toDouble() : null,
      amenities: List<String>.from(json['amenities'] ?? []),
      description: json['description'],
      imageUrl: json['imageUrl'],
      lastMaintenanceDate: json['lastMaintenanceDate'] != null
          ? DateTime.parse(json['lastMaintenanceDate'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buildingId': buildingId,
      'roomNumber': roomNumber,
      'floor': floor,
      'area': area,
      'price': price,
      'capacity': capacity,
      'status': status,
      'tenantId': tenantId,
      'tenantName': tenantName,
      'tenantPhone': tenantPhone,
      'deposit': deposit,
      'amenities': amenities,
      'description': description,
      'imageUrl': imageUrl,
      'lastMaintenanceDate': lastMaintenanceDate?.toIso8601String(),
    };
  }

  bool get isAvailable => status == 'available';
  bool get isOccupied => status == 'occupied';
  bool get isInMaintenance => status == 'maintenance';

  RoomModel copyWith({
    String? id,
    String? buildingId,
    String? roomNumber,
    dynamic floor,
    double? area,
    double? price,
    int? capacity,
    String? status,
    String? tenantId,
    String? tenantName,
    String? tenantPhone,
    double? deposit,
    List<String>? amenities,
    String? description,
    String? imageUrl,
    DateTime? lastMaintenanceDate,
  }) {
    return RoomModel(
      id: id ?? this.id,
      buildingId: buildingId ?? this.buildingId,
      roomNumber: roomNumber ?? this.roomNumber,
      floor: floor ?? this.floor,
      area: area ?? this.area,
      price: price ?? this.price,
      capacity: capacity ?? this.capacity,
      status: status ?? this.status,
      tenantId: tenantId ?? this.tenantId,
      tenantName: tenantName ?? this.tenantName,
      tenantPhone: tenantPhone ?? this.tenantPhone,
      deposit: deposit ?? this.deposit,
      amenities: amenities ?? this.amenities,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      lastMaintenanceDate: lastMaintenanceDate ?? this.lastMaintenanceDate,
    );
  }
}
