class InvoiceModel {
  final String id;
  final String roomNumber;
  final String month;
  final double totalAmount;
  final double electricCost;
  final double waterCost;
  final double roomCost;
  final double serviceCost;
  final String status; // 'paid', 'unpaid', 'overdue'
  final DateTime dueDate;
  final DateTime? paidDate;
  final String? tenantId;

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
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'] ?? '',
      roomNumber: json['roomNumber'] ?? '',
      month: json['month'] ?? '',
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      electricCost: (json['electricCost'] ?? 0).toDouble(),
      waterCost: (json['waterCost'] ?? 0).toDouble(),
      roomCost: (json['roomCost'] ?? 0).toDouble(),
      serviceCost: (json['serviceCost'] ?? 0).toDouble(),
      status: json['status'] ?? 'unpaid',
      dueDate: DateTime.parse(json['dueDate']),
      paidDate: json['paidDate'] != null ? DateTime.parse(json['paidDate']) : null,
      tenantId: json['tenantId'],
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
    );
  }
}
