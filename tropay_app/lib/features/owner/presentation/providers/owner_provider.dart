import 'package:flutter/material.dart';
import '../../data/models/room_model.dart';
import '../../data/models/dashboard_stats_model.dart';
import '../../data/models/feedback_model.dart';
import '../../data/models/invoice_model.dart';
import '../../data/models/incident_model.dart';
import '../../data/models/service_model.dart';

class OwnerProvider with ChangeNotifier {
  // Dashboard Stats
  DashboardStatsModel? _dashboardStats;
  List<RevenueChartModel> _revenueChart = [];
  bool _isLoadingDashboard = false;

  // Rooms
  List<RoomModel> _rooms = [];
  bool _isLoadingRooms = false;

  // Invoices
  List<InvoiceModel> _invoices = [];
  bool _isLoadingInvoices = false;

  // Incidents
  List<IncidentModel> _incidents = [];
  bool _isLoadingIncidents = false;

  // Services
  List<ServiceModel> _services = [];
  bool _isLoadingServices = false;

  // Feedbacks
  List<FeedbackModel> _feedbacks = [];
  bool _isLoadingFeedbacks = false;

  // Getters
  DashboardStatsModel? get dashboardStats => _dashboardStats;
  List<RevenueChartModel> get revenueChart => _revenueChart;
  bool get isLoadingDashboard => _isLoadingDashboard;

  List<RoomModel> get rooms => _rooms;
  List<RoomModel> get availableRooms =>
      _rooms.where((r) => r.status == 'available').toList();
  List<RoomModel> get occupiedRooms =>
      _rooms.where((r) => r.status == 'occupied').toList();
  bool get isLoadingRooms => _isLoadingRooms;

  List<InvoiceModel> get invoices => _invoices;
  List<InvoiceModel> get unpaidInvoices =>
      _invoices.where((i) => !i.isPaid).toList();
  List<InvoiceModel> get paidInvoices =>
      _invoices.where((i) => i.isPaid).toList();
  bool get isLoadingInvoices => _isLoadingInvoices;

  List<IncidentModel> get incidents => _incidents;
  List<IncidentModel> get pendingIncidents =>
      _incidents.where((i) => i.isPending || i.isInProgress).toList();
  bool get isLoadingIncidents => _isLoadingIncidents;

  List<ServiceModel> get services => _services;
  bool get isLoadingServices => _isLoadingServices;

  List<FeedbackModel> get feedbacks => _feedbacks;
  List<FeedbackModel> get pendingFeedbacks =>
      _feedbacks.where((f) => f.status == 'pending').toList();
  bool get isLoadingFeedbacks => _isLoadingFeedbacks;

  // Initialize
  Future<void> initialize() async {
    await Future.wait([
      loadDashboardStats(),
      loadRooms(),
      loadInvoices(),
      loadIncidents(),
      loadServices(),
      loadFeedbacks(),
    ]);
  }

  // Refresh All
  Future<void> refreshAll() async {
    await initialize();
  }

  // Load Dashboard Stats
  Future<void> loadDashboardStats() async {
    _isLoadingDashboard = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));

    _dashboardStats = DashboardStatsModel(
      totalRooms: 20,
      occupiedRooms: 15,
      availableRooms: 4,
      maintenanceRooms: 1,
      totalRevenue: 125000000,
      monthlyRevenue: 37500000,
      totalTenants: 15,
      pendingIncidents: 3,
      unpaidInvoices: 5,
      unpaidAmount: 17500000,
    );

    _revenueChart = [
      RevenueChartModel(month: 'T7', amount: 35000000),
      RevenueChartModel(month: 'T8', amount: 36500000),
      RevenueChartModel(month: 'T9', amount: 37000000),
      RevenueChartModel(month: 'T10', amount: 38000000),
      RevenueChartModel(month: 'T11', amount: 36000000),
      RevenueChartModel(month: 'T12', amount: 37500000),
    ];

    _isLoadingDashboard = false;
    notifyListeners();
  }

  // Load Rooms
  Future<void> loadRooms() async {
    _isLoadingRooms = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1000));

    _rooms = [
      RoomModel(
        id: '1',
        roomNumber: 'A101',
        floor: 1,
        area: 25.0,
        price: 2500000,
        capacity: 1,
        deposit: 5000000,
        status: 'occupied',
        tenantName: 'Nguyễn Văn A',
        tenantPhone: '0901234567',
        amenities: ['Điều hòa', 'Nóng lạnh', 'WiFi'],
        description: 'Phòng rộng rãi, thoáng mát',
      ),
      RoomModel(
        id: '2',
        roomNumber: 'A102',
        floor: 1,
        area: 20.0,
        price: 2000000,
        capacity: 1,
        deposit: 4000000,
        status: 'available',
        amenities: ['Điều hòa', 'WiFi'],
        description: 'Phòng nhỏ, phù hợp sinh viên',
      ),
      RoomModel(
        id: '3',
        roomNumber: 'A103',
        floor: 1,
        area: 30.0,
        price: 3000000,
        capacity: 1,
        deposit: 6000000,
        status: 'occupied',
        tenantName: 'Trần Thị B',
        tenantPhone: '0912345678',
        amenities: ['Điều hòa', 'Nóng lạnh', 'WiFi', 'Ban công'],
        description: 'Phòng cao cấp có ban công',
      ),
      RoomModel(
        id: '4',
        roomNumber: 'A201',
        floor: 2,
        area: 25.0,
        price: 2500000,
        capacity: 1,
        deposit: 5000000,
        status: 'maintenance',
        amenities: ['Điều hòa', 'WiFi'],
        description: 'Đang sửa chữa điều hòa',
      ),
      RoomModel(
        id: '5',
        roomNumber: 'A202',
        floor: 2,
        area: 28.0,
        price: 2800000,
        capacity: 1,
        deposit: 5600000,
        status: 'occupied',
        tenantName: 'Lê Văn C',
        tenantPhone: '0923456789',
        amenities: ['Điều hòa', 'Nóng lạnh', 'WiFi', 'Ban công'],
        description: 'Phòng view đẹp',
      ),
    ];

    _isLoadingRooms = false;
    notifyListeners();
  }

  // Load Invoices
  Future<void> loadInvoices() async {
    _isLoadingInvoices = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 900));

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
        roomNumber: 'A103',
        month: 'Tháng 1/2026',
        totalAmount: 3800000,
        electricCost: 400000,
        waterCost: 200000,
        roomCost: 3000000,
        serviceCost: 200000,
        status: 'unpaid',
        dueDate: DateTime(2026, 2, 5),
      ),
      InvoiceModel(
        id: '3',
        roomNumber: 'A202',
        month: 'Tháng 1/2026',
        totalAmount: 3200000,
        electricCost: 300000,
        waterCost: 120000,
        roomCost: 2500000,
        serviceCost: 280000,
        status: 'paid',
        dueDate: DateTime(2026, 2, 5),
        paidDate: DateTime(2026, 1, 20),
      ),
      InvoiceModel(
        id: '4',
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

    _isLoadingInvoices = false;
    notifyListeners();
  }

  // Load Incidents
  Future<void> loadIncidents() async {
    _isLoadingIncidents = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 700));

    _incidents = [
      IncidentModel(
        id: '1',
        roomNumber: 'A101',
        title: 'Máy lạnh không mát',
        description: 'Máy lạnh chạy nhưng không làm mát phòng',
        category: 'appliances',
        priority: 'high',
        status: 'pending',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      IncidentModel(
        id: '2',
        roomNumber: 'A103',
        title: 'Vòi nước bị rò rỉ',
        description: 'Vòi nước trong phòng tắm bị rò rỉ từ sáng nay',
        category: 'plumbing',
        priority: 'medium',
        status: 'in_progress',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      IncidentModel(
        id: '3',
        roomNumber: 'A202',
        title: 'Đèn hành lang hỏng',
        description: 'Đèn hành lang tầng 2 không sáng',
        category: 'electrical',
        priority: 'low',
        status: 'resolved',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];

    _isLoadingIncidents = false;
    notifyListeners();
  }

  // Load Services
  Future<void> loadServices() async {
    _isLoadingServices = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    _services = [
      ServiceModel(
        id: '1',
        name: 'Điện',
        description: 'Tiền điện hàng tháng',
        price: 3500,
        unit: 'kWh',
        isActive: true,
      ),
      ServiceModel(
        id: '2',
        name: 'Nước',
        description: 'Tiền nước hàng tháng',
        price: 20000,
        unit: 'm³',
        isActive: true,
      ),
      ServiceModel(
        id: '3',
        name: 'Internet',
        description: 'Dịch vụ internet WiFi',
        price: 150000,
        unit: 'tháng',
        isActive: true,
      ),
      ServiceModel(
        id: '4',
        name: 'Vệ sinh',
        description: 'Dịch vụ vệ sinh khu vực chung',
        price: 50000,
        unit: 'tháng',
        isActive: true,
      ),
      ServiceModel(
        id: '5',
        name: 'Bảo vệ',
        description: 'Dịch vụ bảo vệ 24/7',
        price: 100000,
        unit: 'tháng',
        isActive: false,
      ),
    ];

    _isLoadingServices = false;
    notifyListeners();
  }

  // Load Feedbacks
  Future<void> loadFeedbacks() async {
    _isLoadingFeedbacks = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _feedbacks = [
      FeedbackModel(
        id: '1',
        tenantId: 't1',
        tenantName: 'Nguyễn Văn A',
        roomNumber: 'A101',
        subject: 'Phòng sạch sẽ',
        content: 'Phòng rất sạch sẽ, thoáng mát',
        rating: 5,
        category: 'room',
        status: 'reviewed',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        response: 'Cảm ơn bạn đã đánh giá',
        respondedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      FeedbackModel(
        id: '2',
        tenantId: 'tenant_002',
        tenantName: 'Trần Thị B',
        roomNumber: 'A103',
        subject: 'Yêu cầu thêm gương',
        content: 'Mong chủ trọ lắp thêm gương lớn trong phòng',
        rating: 4,
        category: 'request',
        status: 'pending',
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      ),
      FeedbackModel(
        id: '3',
        tenantId: 't3',
        tenantName: 'Lê Văn C',
        roomNumber: 'A202',
        subject: 'Wifi chậm',
        content: 'Tốc độ wifi không ổn định vào buổi tối',
        rating: 3,
        category: 'service',
        status: 'resolved',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        response: 'Đã nâng cấp router wifi, vui lòng kiểm tra lại',
        respondedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];

    _isLoadingFeedbacks = false;
    notifyListeners();
  }

  // Room Management
  Future<void> addRoom({
    required String roomNumber,
    required double area,
    required double price,
    required double deposit,
    required int floor,
    required String description,
    int capacity = 1,
    List<String>? amenities,
  }) async {
    final room = RoomModel(
      id: 'room_${DateTime.now().millisecondsSinceEpoch}',
      roomNumber: roomNumber,
      area: area,
      price: price,
      capacity: capacity,
      deposit: deposit,
      status: 'available',
      floor: floor,
      amenities: amenities ?? [],
      description: description,
    );
    _rooms.add(room);
    notifyListeners();
    // TODO: Call API
  }

  Future<void> updateRoom(
    String id, {
    String? roomNumber,
    double? area,
    double? price,
    double? deposit,
    int? floor,
    String? description,
    String? status,
    int? capacity,
    String? tenantId,
    String? tenantName,
    String? tenantPhone,
    List<String>? amenities,
  }) async {
    final index = _rooms.indexWhere((r) => r.id == id);
    if (index != -1) {
      final room = _rooms[index];
      _rooms[index] = RoomModel(
        id: room.id,
        roomNumber: roomNumber ?? room.roomNumber,
        area: area ?? room.area,
        price: price ?? room.price,
        capacity: capacity ?? room.capacity,
        deposit: deposit ?? room.deposit,
        status: status ?? room.status,
        floor: floor ?? room.floor,
        amenities: amenities ?? room.amenities,
        tenantId: tenantId ?? room.tenantId,
        tenantName: tenantName ?? room.tenantName,
        tenantPhone: tenantPhone ?? room.tenantPhone,
        description: description ?? room.description,
      );
      notifyListeners();
    }
    // TODO: Call API
  }

  Future<void> deleteRoom(String roomId) async {
    _rooms.removeWhere((r) => r.id == roomId);
    notifyListeners();
    // TODO: Call API
  }

  // Invoice Management
  Future<void> createInvoice(InvoiceModel invoice) async {
    _invoices.insert(0, invoice);
    notifyListeners();
    // TODO: Call API
  }

  Future<void> updateInvoice(String id, {String? status}) async {
    final index = _invoices.indexWhere((invoice) => invoice.id == id);
    if (index != -1) {
      final invoice = _invoices[index];
      _invoices[index] = InvoiceModel(
        id: invoice.id,
        roomNumber: invoice.roomNumber,
        month: invoice.month,
        totalAmount: invoice.totalAmount,
        electricCost: invoice.electricCost,
        waterCost: invoice.waterCost,
        roomCost: invoice.roomCost,
        serviceCost: invoice.serviceCost,
        status: status ?? invoice.status,
        dueDate: invoice.dueDate,
        paidDate: invoice.paidDate,
      );
      notifyListeners();
    }
    // TODO: Call API
  }

  // Incident Management
  Future<void> updateIncident(String id, {String? status}) async {
    final index = _incidents.indexWhere((incident) => incident.id == id);
    if (index != -1) {
      final incident = _incidents[index];
      _incidents[index] = IncidentModel(
        id: incident.id,
        roomNumber: incident.roomNumber,
        title: incident.title,
        description: incident.description,
        category: incident.category,
        priority: incident.priority,
        status: status ?? incident.status,
        createdAt: incident.createdAt,
      );
      notifyListeners();
    }
    // TODO: Call API
  }

  // Service Management
  Future<void> addService({
    required String name,
    required String description,
    required double price,
    required String unit,
  }) async {
    final service = ServiceModel(
      id: 'service_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      description: description,
      price: price,
      unit: unit,
      isActive: true,
    );
    _services.add(service);
    notifyListeners();
    // TODO: Call API
  }

  Future<void> updateService(
    String id, {
    required String name,
    required String description,
    required double price,
    required String unit,
    required bool isActive,
  }) async {
    final index = _services.indexWhere((service) => service.id == id);
    if (index != -1) {
      _services[index] = ServiceModel(
        id: id,
        name: name,
        description: description,
        price: price,
        unit: unit,
        isActive: isActive,
      );
      notifyListeners();
    }
    // TODO: Call API
  }

  Future<void> deleteService(String serviceId) async {
    _services.removeWhere((s) => s.id == serviceId);
    notifyListeners();
    // TODO: Call API
  }

  // Feedback Management
  Future<void> updateFeedback(String id, {String? status, String? response}) async {
    final index = _feedbacks.indexWhere((f) => f.id == id);
    if (index != -1) {
      final feedback = _feedbacks[index];
      _feedbacks[index] = FeedbackModel(
        id: feedback.id,
        tenantId: feedback.tenantId,
        tenantName: feedback.tenantName,
        roomNumber: feedback.roomNumber,
        subject: feedback.subject,
        content: feedback.content,
        rating: feedback.rating,
        category: feedback.category,
        status: status ?? feedback.status,
        createdAt: feedback.createdAt,
        response: response ?? feedback.response,
        respondedAt: response != null ? DateTime.now() : feedback.respondedAt,
      );
      notifyListeners();
    }
    // TODO: Call API
  }
}
