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
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    // Backend may return roomId as an object (populated) or just an ID string.
    final roomIdField = json['roomId'];
    String roomNumber = json['roomNumber'] ?? '';
    if (roomNumber.isEmpty && roomIdField is Map) {
      roomNumber = roomIdField['roomNumber'] ?? '';
    }

    // 'month' may come as 'periodMonth' from the backend
    final month = json['month'] ?? json['periodMonth'] ?? '';

    // Handle dueDate safely
    DateTime dueDate;
    try {
      dueDate = DateTime.parse(json['dueDate'] ?? DateTime.now().toIso8601String());
    } catch (_) {
      dueDate = DateTime.now();
    }

    // Handle paidDate safely (may not be present)
    DateTime? paidDate;
    if (json['paidDate'] != null) {
      try {
        paidDate = DateTime.parse(json['paidDate']);
      } catch (_) {
        paidDate = null;
      }
    }

    return InvoiceModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      roomNumber: roomNumber,
      month: month,
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      // Backend uses electricityCost; fallback to electricCost
      electricCost: (json['electricCost'] ?? json['electricityCost'] ?? 0).toDouble(),
      waterCost: (json['waterCost'] ?? 0).toDouble(),
      // Backend uses roomPrice; fallback to roomCost
      roomCost: (json['roomCost'] ?? json['roomPrice'] ?? 0).toDouble(),
      serviceCost: (json['serviceCost'] ?? 0).toDouble(),
      status: json['status'] ?? 'unpaid',
      dueDate: dueDate,
      paidDate: paidDate,
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
    };
  }

  bool get isPaid => status == 'paid';
  bool get isOverdue => status == 'overdue';
  bool get isUnpaid => status == 'unpaid';
}
