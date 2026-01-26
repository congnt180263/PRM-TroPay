class DashboardStatsModel {
  final int totalRooms;
  final int occupiedRooms;
  final int availableRooms;
  final int maintenanceRooms;
  final double totalRevenue;
  final double monthlyRevenue;
  final int totalTenants;
  final int pendingIncidents;
  final int unpaidInvoices;
  final double unpaidAmount;

  DashboardStatsModel({
    required this.totalRooms,
    required this.occupiedRooms,
    required this.availableRooms,
    required this.maintenanceRooms,
    required this.totalRevenue,
    required this.monthlyRevenue,
    required this.totalTenants,
    required this.pendingIncidents,
    required this.unpaidInvoices,
    required this.unpaidAmount,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      totalRooms: json['totalRooms'] ?? 0,
      occupiedRooms: json['occupiedRooms'] ?? 0,
      availableRooms: json['availableRooms'] ?? 0,
      maintenanceRooms: json['maintenanceRooms'] ?? 0,
      totalRevenue: (json['totalRevenue'] ?? 0).toDouble(),
      monthlyRevenue: (json['monthlyRevenue'] ?? 0).toDouble(),
      totalTenants: json['totalTenants'] ?? 0,
      pendingIncidents: json['pendingIncidents'] ?? 0,
      unpaidInvoices: json['unpaidInvoices'] ?? 0,
      unpaidAmount: (json['unpaidAmount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalRooms': totalRooms,
      'occupiedRooms': occupiedRooms,
      'availableRooms': availableRooms,
      'maintenanceRooms': maintenanceRooms,
      'totalRevenue': totalRevenue,
      'monthlyRevenue': monthlyRevenue,
      'totalTenants': totalTenants,
      'pendingIncidents': pendingIncidents,
      'unpaidInvoices': unpaidInvoices,
      'unpaidAmount': unpaidAmount,
    };
  }

  double get occupancyRate =>
      totalRooms > 0 ? (occupiedRooms / totalRooms) * 100 : 0;
}

class RevenueChartModel {
  final String month;
  final double amount;

  RevenueChartModel({
    required this.month,
    required this.amount,
  });

  factory RevenueChartModel.fromJson(Map<String, dynamic> json) {
    return RevenueChartModel(
      month: json['month'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'amount': amount,
    };
  }
}
