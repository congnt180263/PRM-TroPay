import 'package:flutter/material.dart';
import '../../data/models/room_model.dart';
import '../../data/models/dashboard_stats_model.dart';
import '../../data/models/feedback_model.dart';
import '../../data/models/invoice_model.dart';
import '../../data/models/incident_model.dart';
import '../../data/models/service_model.dart';
import '../../data/models/building_model.dart';
import '../../data/services/owner_api_service.dart';
import '../../data/services/building_api_service.dart';

class OwnerProvider with ChangeNotifier {
  final OwnerApiService _api = OwnerApiService();
  final BuildingApiService _buildingService = BuildingApiService();

  // Dashboard Stats
  DashboardStatsModel? _dashboardStats;
  List<RevenueChartModel> _revenueChart = [];
  bool _isLoadingDashboard = false;
  String? _dashboardError;

  // Building State
  BuildingModel? _building;
  BuildingStatsModel? _buildingStats;
  bool _isLoadingBuilding = false;
  String? _buildingError;

  // Rooms
  List<RoomModel> _rooms = [];
  bool _isLoadingRooms = false;
  String? _roomsError;

  // Invoices
  List<InvoiceModel> _invoices = [];
  bool _isLoadingInvoices = false;
  String? _invoicesError;

  // Incidents
  List<IncidentModel> _incidents = [];
  bool _isLoadingIncidents = false;
  String? _incidentsError;

  // Services
  List<ServiceModel> _services = [];
  bool _isLoadingServices = false;
  String? _servicesError;

  // Feedbacks
  List<FeedbackModel> _feedbacks = [];
  bool _isLoadingFeedbacks = false;
  String? _feedbacksError;

  // Getters
  DashboardStatsModel? get dashboardStats => _dashboardStats;
  List<RevenueChartModel> get revenueChart => _revenueChart;
  bool get isLoadingDashboard => _isLoadingDashboard;

  BuildingModel? get building => _building;
  BuildingStatsModel? get buildingStats => _buildingStats;
  bool get isLoadingBuilding => _isLoadingBuilding;
  String? get buildingError => _buildingError;
  bool get hasBuilding => _building != null;

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
  String? get dashboardError => _dashboardError;
  String? get roomsError => _roomsError;
  String? get invoicesError => _invoicesError;
  String? get incidentsError => _incidentsError;
  String? get servicesError => _servicesError;
  String? get feedbacksError => _feedbacksError;

  // Initialize
  Future<void> initialize() async {
    await Future.wait([
      loadBuilding(),
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
    _dashboardError = null;
    notifyListeners();

    try {
      final result = await _api.fetchDashboard();
      _dashboardStats = result.stats;
      _revenueChart = result.revenueChart;
    } catch (e) {
      _dashboardStats = null;
      _revenueChart = [];
      _dashboardError = e.toString();
    } finally {
      _isLoadingDashboard = false;
      notifyListeners();
    }
  }

  // ==================== Building Management ====================

  /// Load building data for the current owner
  Future<void> loadBuilding() async {
    _isLoadingBuilding = true;
    _buildingError = null;
    notifyListeners();

    try {
      _building = await _buildingService.getMyBuilding();

      if (_building != null) {
        // Load stats if building exists
        _buildingStats = await _buildingService.getBuildingStats(_building!.id);
      }

      _buildingError = null;
    } catch (e) {
      _buildingError = e.toString();
      print('Error loading building: $e');
    } finally {
      _isLoadingBuilding = false;
      notifyListeners();
    }
  }

  /// Create a new building
  Future<bool> createBuilding(Map<String, dynamic> buildingData) async {
    _isLoadingBuilding = true;
    _buildingError = null;
    notifyListeners();

    try {
      _building = await _buildingService.createBuilding(buildingData);
      _buildingError = null;
      notifyListeners();

      // Load stats after creation
      await loadBuildingStats();

      return true;
    } catch (e) {
      _buildingError = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoadingBuilding = false;
      notifyListeners();
    }
  }

  /// Update building information
  Future<bool> updateBuilding(Map<String, dynamic> updates) async {
    if (_building == null) return false;

    _isLoadingBuilding = true;
    _buildingError = null;
    notifyListeners();

    try {
      _building = await _buildingService.updateBuilding(_building!.id, updates);
      _buildingError = null;
      notifyListeners();
      return true;
    } catch (e) {
      _buildingError = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoadingBuilding = false;
      notifyListeners();
    }
  }

  /// Refresh building statistics
  Future<void> loadBuildingStats() async {
    if (_building == null) return;

    try {
      _buildingStats = await _buildingService.getBuildingStats(_building!.id);
      notifyListeners();
    } catch (e) {
      print('Error loading building stats: $e');
    }
  }

  /// Clear building data (e.g., on logout)
  void clearBuilding() {
    _building = null;
    _buildingStats = null;
    _buildingError = null;
    _isLoadingBuilding = false;
    notifyListeners();
  }

  // Load Rooms
  Future<void> loadRooms() async {
    _isLoadingRooms = true;
    _roomsError = null;
    notifyListeners();

    try {
      final result = await _api.fetchRooms(limit: 100);
      _rooms = result.items;
    } catch (e) {
      _rooms = [];
      _roomsError = e.toString();
    } finally {
      _isLoadingRooms = false;
      notifyListeners();
    }
  }

  // Load Invoices
  Future<void> loadInvoices() async {
    _isLoadingInvoices = true;
    _invoicesError = null;
    notifyListeners();

    try {
      final result = await _api.fetchInvoices(
        buildingId: _building?.id,
        limit: 100,
      );
      _invoices = result.items;
    } catch (e) {
      _invoices = [];
      _invoicesError = e.toString();
    } finally {
      _isLoadingInvoices = false;
      notifyListeners();
    }
  }

  // Load Incidents
  Future<void> loadIncidents() async {
    _isLoadingIncidents = true;
    _incidentsError = null;
    notifyListeners();

    try {
      final result = await _api.fetchIncidents(limit: 50);
      _incidents = result.items;
    } catch (e) {
      _incidents = [];
      _incidentsError = e.toString();
    } finally {
      _isLoadingIncidents = false;
      notifyListeners();
    }
  }

  // Load Services
  Future<void> loadServices() async {
    _isLoadingServices = true;
    _servicesError = null;
    notifyListeners();

    try {
      final result = await _api.fetchServices(limit: 200);
      _services = result.items;
    } catch (e) {
      _services = [];
      _servicesError = e.toString();
    } finally {
      _isLoadingServices = false;
      notifyListeners();
    }
  }

  // Load Feedbacks
  Future<void> loadFeedbacks() async {
    _isLoadingFeedbacks = true;
    _feedbacksError = null;
    notifyListeners();

    try {
      // Feedback API not available in current backend implementation
      _feedbacks = [];
      _feedbacksError = 'Feedback API is not available yet.';
    } finally {
      _isLoadingFeedbacks = false;
      notifyListeners();
    }
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
    // Ensure building exists before creating room
    if (_building == null) {
      _roomsError = 'You must create a building before adding rooms';
      throw Exception(_roomsError);
    }

    try {
      final room = await _api.createRoom({
        'buildingId': _building!.id,
        'roomNumber': roomNumber,
        'area': area,
        'price': price,
        'capacity': capacity,
        'deposit': deposit,
        'status': 'available',
        'floor': floor,
        'amenities': amenities ?? [],
        'description': description,
      });
      _rooms.add(room);
    } catch (e) {
      _roomsError = e.toString();
      rethrow;
    }
    notifyListeners();
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
    final payload = <String, dynamic>{};
    if (roomNumber != null) payload['roomNumber'] = roomNumber;
    if (area != null) payload['area'] = area;
    if (price != null) payload['price'] = price;
    if (deposit != null) payload['deposit'] = deposit;
    if (floor != null) payload['floor'] = floor;
    if (description != null) payload['description'] = description;
    if (status != null) payload['status'] = status;
    if (capacity != null) payload['capacity'] = capacity;
    if (tenantId != null) payload['currentTenantId'] = tenantId;
    if (amenities != null) payload['amenities'] = amenities;

    try {
      final updated = await _api.updateRoom(id, payload);
      final index = _rooms.indexWhere((r) => r.id == id);
      if (index != -1) {
        _rooms[index] = updated;
      }
    } catch (e) {
      _roomsError = e.toString();
      rethrow;
    }
    notifyListeners();
  }

  Future<void> deleteRoom(String roomId) async {
    try {
      await _api.deleteRoom(roomId);
      _rooms.removeWhere((r) => r.id == roomId);
    } catch (e) {
      _roomsError = e.toString();
      rethrow;
    }
    notifyListeners();
  }

  // Invoice Management
  Future<void> createInvoice(InvoiceModel invoice) async {
    if (invoice.tenantId == null || invoice.roomNumber.isEmpty) {
      _invoicesError = 'Creating invoice requires tenant and room information.';
      throw Exception(_invoicesError);
    }

    try {
      final roomId = _rooms
          .cast<RoomModel?>()
          .firstWhere((r) => r?.roomNumber == invoice.roomNumber, orElse: () => null)
          ?.id;

      if (roomId == null) {
        throw Exception('Room not found for invoice ${invoice.roomNumber}');
      }

      final payload = {
        'tenantId': invoice.tenantId,
        'roomId': roomId,
        'totalAmount': invoice.totalAmount,
        'serviceCost': invoice.serviceCost,
        'electricityCost': invoice.electricCost,
        'waterCost': invoice.waterCost,
        'roomPrice': invoice.roomCost,
        'status': invoice.status,
        'dueDate': invoice.dueDate.toIso8601String(),
        'periodMonth': invoice.month,
      };

      final created = await _api.createInvoice(payload);
      _invoices.insert(0, created);
    } catch (e) {
      _invoicesError = e.toString();
      rethrow;
    }

    notifyListeners();
  }

  Future<void> updateInvoice(String id, {String? status}) async {
    final payload = <String, dynamic>{};
    if (status != null) payload['status'] = status;

    try {
      final updated = await _api.updateInvoice(id, payload);
      final index = _invoices.indexWhere((invoice) => invoice.id == id);
      if (index != -1) {
        _invoices[index] = updated;
      }
    } catch (e) {
      _invoicesError = e.toString();
      rethrow;
    }

    notifyListeners();
  }

  // Incident Management
  Future<void> updateIncident(String id, {String? status}) async {
    try {
      final updated = await _api.updateIncidentStatus(id, status ?? 'pending');
      final index = _incidents.indexWhere((incident) => incident.id == id);
      if (index != -1) {
        _incidents[index] = updated;
      }
    } catch (e) {
      _incidentsError = e.toString();
      rethrow;
    }

    notifyListeners();
  }

  // Service Management
  Future<void> addService({
    required String name,
    required String description,
    required double price,
    required String unit,
  }) async {
    try {
      final service = await _api.createService({
        'name': name,
        'description': description,
        'price': price,
        'unit': unit,
        'isActive': true,
      });
      _services.add(service);
    } catch (e) {
      _servicesError = e.toString();
      rethrow;
    }
    notifyListeners();
  }

  Future<void> updateService(
    String id, {
    required String name,
    required String description,
    required double price,
    required String unit,
    required bool isActive,
  }) async {
    try {
      final updated = await _api.updateService(id, {
        'name': name,
        'description': description,
        'price': price,
        'unit': unit,
        'isActive': isActive,
      });
      final index = _services.indexWhere((service) => service.id == id);
      if (index != -1) {
        _services[index] = updated;
      }
    } catch (e) {
      _servicesError = e.toString();
      rethrow;
    }
    notifyListeners();
  }

  Future<void> deleteService(String serviceId) async {
    try {
      await _api.deleteService(serviceId);
      _services.removeWhere((s) => s.id == serviceId);
    } catch (e) {
      _servicesError = e.toString();
      rethrow;
    }
    notifyListeners();
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
    _feedbacksError = 'Feedback API is not available yet.';
  }
}
