class RoomModel {
  final String id;
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
    return RoomModel(
      id: json['id'] ?? '',
      roomNumber: json['roomNumber'] ?? '',
      floor: json['floor'] ?? '',
      area: (json['area'] ?? 0).toDouble(),
      price: (json['price'] ?? 0).toDouble(),
      capacity: json['capacity'] ?? 1,
      status: json['status'] ?? 'available',
      tenantId: json['tenantId'],
      tenantName: json['tenantName'],
      tenantPhone: json['tenantPhone'],
      deposit: json['deposit'] != null ? (json['deposit'] as num).toDouble() : null,
      amenities: List<String>.from(json['amenities'] ?? []),
      description: json['description'],
      imageUrl: json['imageUrl'],
      lastMaintenanceDate: json['lastMaintenanceDate'] != null
          ? DateTime.parse(json['lastMaintenanceDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
