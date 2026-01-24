import 'package:flutter/material.dart';
import '../../data/models/invoice_model.dart';
import '../../data/models/incident_model.dart';
import '../../data/models/service_model.dart';
import '../../data/models/contract_model.dart';

class TenantProvider with ChangeNotifier {
  // Dashboard data
  String _roomNumber = 'A101';
  double _totalUnpaid = 0.0;
  int _pendingIncidents = 0;
  ContractModel? _activeContract;

  // Invoices
  List<InvoiceModel> _invoices = [];
  bool _isLoadingInvoices = false;

  // Incidents
  List<IncidentModel> _incidents = [];
  bool _isLoadingIncidents = false;

  // Services
  List<ServiceModel> _services = [];
  List<ServiceHistoryModel> _serviceHistory = [];
  bool _isLoadingServices = false;

  // Getters
  String get roomNumber => _roomNumber;
  double get totalUnpaid => _totalUnpaid;
  int get pendingIncidents => _pendingIncidents;
  ContractModel? get activeContract => _activeContract;

  List<InvoiceModel> get invoices => _invoices;
  List<InvoiceModel> get unpaidInvoices => _invoices.where((i) => !i.isPaid).toList();
  List<InvoiceModel> get paidInvoices => _invoices.where((i) => i.isPaid).toList();
  bool get isLoadingInvoices => _isLoadingInvoices;

  List<IncidentModel> get incidents => _incidents;
  List<IncidentModel> get pendingIncidentsList => _incidents.where((i) => i.isPending).toList();
  bool get isLoadingIncidents => _isLoadingIncidents;

  List<ServiceModel> get services => _services;
  List<ServiceHistoryModel> get serviceHistory => _serviceHistory;
  bool get isLoadingServices => _isLoadingServices;

  // Initialize with mock data
  Future<void> initialize() async {
    await Future.wait([
      loadDashboardData(),
      loadInvoices(),
      loadIncidents(),
      loadServices(),
      loadContract(),
    ]);
  }

  Future<void> loadDashboardData() async {
    // Mock data - replace with actual API call
    await Future.delayed(const Duration(milliseconds: 500));
    _roomNumber = 'A101';
    _totalUnpaid = 3500000;
    _pendingIncidents = 2;
    notifyListeners();
  }

  Future<void> loadInvoices() async {
    _isLoadingInvoices = true;
    notifyListeners();

    // Mock data - replace with actual API call
    await Future.delayed(const Duration(seconds: 1));
    
    _invoices = [
      InvoiceModel(
        id: '1',
        roomNumber: 'A101',
        month: 'Tháng 1/2026',
        totalAmount: 3500000,
        electricCost: 350000,
        waterCost: 150000,
        roomCost: 2500000,
        serviceCost: 500000,
        status: 'unpaid',
        dueDate: DateTime(2026, 2, 5),
      ),
      InvoiceModel(
        id: '2',
        roomNumber: 'A101',
        month: 'Tháng 12/2025',
        totalAmount: 3200000,
        electricCost: 300000,
        waterCost: 120000,
        roomCost: 2500000,
        serviceCost: 280000,
        status: 'paid',
        dueDate: DateTime(2026, 1, 5),
        paidDate: DateTime(2026, 1, 3),
      ),
    ];

    _totalUnpaid = _invoices.where((i) => !i.isPaid).fold(0.0, (sum, i) => sum + i.totalAmount);
    _isLoadingInvoices = false;
    notifyListeners();
  }

  Future<void> loadIncidents() async {
    _isLoadingIncidents = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));
    
    _incidents = [
      IncidentModel(
        id: '1',
        title: 'Máy lạnh không hoạt động',
        description: 'Máy lạnh trong phòng không hoạt động từ sáng nay',
        category: 'electrical',
        status: 'pending',
        priority: 'high',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      IncidentModel(
        id: '2',
        title: 'Vòi nước bị rò rỉ',
        description: 'Vòi nước trong nhà tắm bị rò rỉ nhẹ',
        category: 'plumbing',
        status: 'in_progress',
        priority: 'medium',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];

    _pendingIncidents = _incidents.where((i) => i.isPending).length;
    _isLoadingIncidents = false;
    notifyListeners();
  }

  Future<void> loadServices() async {
    _isLoadingServices = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));
    
    _services = [
      ServiceModel(
        id: '1',
        name: 'Điện',
        description: 'Tiền điện hàng tháng',
        price: 3500,
        unit: 'kwh',
        iconName: 'electrical_services',
      ),
      ServiceModel(
        id: '2',
        name: 'Nước',
        description: 'Tiền nước hàng tháng',
        price: 15000,
        unit: 'm3',
        iconName: 'water_drop',
      ),
      ServiceModel(
        id: '3',
        name: 'Internet',
        description: 'Wifi tốc độ cao',
        price: 100000,
        unit: 'month',
        iconName: 'wifi',
      ),
      ServiceModel(
        id: '4',
        name: 'Vệ sinh',
        description: 'Dịch vụ vệ sinh chung',
        price: 50000,
        unit: 'month',
        iconName: 'cleaning_services',
      ),
    ];

    _serviceHistory = [
      ServiceHistoryModel(
        id: '1',
        serviceName: 'Điện - Tháng 12/2025',
        amount: 300000,
        date: DateTime(2025, 12, 31),
        description: '100 kWh x 3,000đ',
      ),
      ServiceHistoryModel(
        id: '2',
        serviceName: 'Nước - Tháng 12/2025',
        amount: 120000,
        date: DateTime(2025, 12, 31),
        description: '8 m³ x 15,000đ',
      ),
    ];

    _isLoadingServices = false;
    notifyListeners();
  }

  Future<void> loadContract() async {
    await Future.delayed(const Duration(milliseconds: 600));
    
    _activeContract = ContractModel(
      id: '1',
      roomNumber: 'A101',
      ownerName: 'Nguyễn Văn A',
      tenantName: 'Trần Thị B',
      rentPrice: 2500000,
      deposit: 5000000,
      startDate: DateTime(2025, 7, 1),
      endDate: DateTime(2026, 6, 30),
      status: 'active',
      terms: [
        'Thanh toán tiền thuê trước ngày 5 hàng tháng',
        'Không nuôi thú cưng',
        'Giữ gìn vệ sinh chung',
        'Báo trước 1 tháng khi chấm dứt hợp đồng',
      ],
    );
    notifyListeners();
  }

  Future<void> reportIncident({
    required String title,
    required String description,
    required String category,
    required String priority,
  }) async {
    final newIncident = IncidentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      category: category,
      status: 'pending',
      priority: priority,
      createdAt: DateTime.now(),
    );

    _incidents.insert(0, newIncident);
    _pendingIncidents = _incidents.where((i) => i.isPending).length;
    notifyListeners();

    // TODO: Call API to save incident
  }

  Future<void> payInvoice(String invoiceId) async {
    // TODO: Implement payment logic with MoMo integration
    await Future.delayed(const Duration(seconds: 2));
    
    final index = _invoices.indexWhere((i) => i.id == invoiceId);
    if (index != -1) {
      // In real app, update from API response
      notifyListeners();
    }
  }

  Future<void> refreshAll() async {
    await Future.wait([
      loadDashboardData(),
      loadInvoices(),
      loadIncidents(),
      loadServices(),
      loadContract(),
    ]);
  }
}
