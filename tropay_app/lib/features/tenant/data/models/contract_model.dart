class ContractModel {
  final String id;
  final String roomNumber;
  final String ownerName;
  final String tenantName;
  final double rentPrice;
  final double deposit;
  final DateTime startDate;
  final DateTime endDate;
  final String status; // 'active', 'expired', 'terminated'
  final List<String> terms;
  final String? documentUrl;

  ContractModel({
    required this.id,
    required this.roomNumber,
    required this.ownerName,
    required this.tenantName,
    required this.rentPrice,
    required this.deposit,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.terms,
    this.documentUrl,
  });

  factory ContractModel.fromJson(Map<String, dynamic> json) {
    return ContractModel(
      id: json['id'] ?? '',
      roomNumber: json['roomNumber'] ?? '',
      ownerName: json['ownerName'] ?? '',
      tenantName: json['tenantName'] ?? '',
      rentPrice: (json['rentPrice'] ?? 0).toDouble(),
      deposit: (json['deposit'] ?? 0).toDouble(),
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      status: json['status'] ?? 'active',
      terms: List<String>.from(json['terms'] ?? []),
      documentUrl: json['documentUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomNumber': roomNumber,
      'ownerName': ownerName,
      'tenantName': tenantName,
      'rentPrice': rentPrice,
      'deposit': deposit,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status,
      'terms': terms,
      'documentUrl': documentUrl,
    };
  }

  bool get isActive => status == 'active';
  bool get isExpired => status == 'expired';
  bool get isTerminated => status == 'terminated';
  
  int get daysRemaining {
    if (!isActive) return 0;
    final now = DateTime.now();
    return endDate.difference(now).inDays;
  }
}
