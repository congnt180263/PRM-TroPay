class InvoiceModel {
  final String id;
  final String roomNumber;
  final String month;
  final double totalAmount;
  final double electricCost;
  final double waterCost;
  final double roomCost;
  final double serviceCost;
  final String status; // 'paid', 'unpaid', 'overdue', 'pending'
  final DateTime dueDate;
  final DateTime? paidDate;
  final String? tenantId;
  final DateTime createdAt;

  InvoiceModel({
    required this.id,
    required this.roomNumber,
    required this.month,
    required this.totalAmount,
    required this.electricCost,
    required this.waterCost,
    required this.roomCost,
    required this.serviceCost,
    required this.status,
    required this.dueDate,
    this.paidDate,
    this.tenantId,
    required this.createdAt,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    // Helper to safely extract ID from nested objects
    String extractId(dynamic value) {
      if (value == null) return '';
      if (value is String) return value;
      if (value is Map) return value['_id']?.toString() ?? value['id']?.toString() ?? '';
      return value.toString();
    }

    // Extract room data - might be nested object or plain data
    final roomId = json['roomId'];
    String roomNumber = '';
    if (roomId is Map) {
      roomNumber = roomId['roomNumber']?.toString() ?? '';
    } else if (json['roomNumber'] != null) {
      roomNumber = json['roomNumber'].toString();
    }

    return InvoiceModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      roomNumber: roomNumber,
      month: json['periodMonth']?.toString() ?? json['month']?.toString() ?? '',
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      electricCost: (json['electricityCost'] ?? json['electricCost'] ?? 0).toDouble(),
      waterCost: (json['waterCost'] ?? 0).toDouble(),
      roomCost: (json['roomPrice'] ?? json['roomCost'] ?? 0).toDouble(),
      serviceCost: (json['serviceCost'] ?? 0).toDouble(),
      status: json['status']?.toString() ?? 'unpaid',
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'].toString())
          : DateTime.now(),
      paidDate: (json['paidAt'] != null || json['paidDate'] != null)
          ? DateTime.parse((json['paidAt'] ?? json['paidDate']).toString())
          : null,
      tenantId: extractId(json['tenantId']),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomNumber': roomNumber,
      'month': month,
      'totalAmount': totalAmount,
      'electricCost': electricCost,
      'waterCost': waterCost,
      'roomCost': roomCost,
      'serviceCost': serviceCost,
      'status': status,
      'dueDate': dueDate.toIso8601String(),
      'paidDate': paidDate?.toIso8601String(),
      'tenantId': tenantId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  bool get isPaid => status == 'paid';
  bool get isOverdue => status == 'overdue';
  bool get isUnpaid => status == 'unpaid';

  InvoiceModel copyWith({
    String? id,
    String? roomNumber,
    String? month,
    double? totalAmount,
    double? electricCost,
    double? waterCost,
    double? roomCost,
    double? serviceCost,
    String? status,
    DateTime? dueDate,
    DateTime? paidDate,
    String? tenantId,
    DateTime? createdAt,
  }) {
    return InvoiceModel(
      id: id ?? this.id,
      roomNumber: roomNumber ?? this.roomNumber,
      month: month ?? this.month,
      totalAmount: totalAmount ?? this.totalAmount,
      electricCost: electricCost ?? this.electricCost,
      waterCost: waterCost ?? this.waterCost,
      roomCost: roomCost ?? this.roomCost,
      serviceCost: serviceCost ?? this.serviceCost,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      paidDate: paidDate ?? this.paidDate,
      tenantId: tenantId ?? this.tenantId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
