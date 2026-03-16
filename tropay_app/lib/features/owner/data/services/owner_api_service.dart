import 'package:dio/dio.dart';
import '../../../../core/constants/api_config.dart';
import '../../../../core/models/paginated_result.dart';
import '../../../../core/services/http_client_service.dart';
import '../models/dashboard_stats_model.dart';
import '../models/incident_model.dart';
import '../models/invoice_model.dart';
import '../models/room_model.dart';
import '../models/service_model.dart';

class OwnerDashboardData {
  final DashboardStatsModel stats;
  final List<RevenueChartModel> revenueChart;

  OwnerDashboardData({
    required this.stats,
    required this.revenueChart,
  });
}

class OwnerApiService {
  final HttpClientService _http = HttpClientService();

  void _ensureSuccess(Response response) {
    if (response.data is Map && response.data['success'] == true) {
      return;
    }
    throw Exception(response.data['message'] ?? 'Request failed');
  }

  Future<OwnerDashboardData> fetchDashboard() async {
    final response = await _http.get('${ApiConfig.rooms}/dashboard');
    _ensureSuccess(response);

    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    final stats = DashboardStatsModel.fromJson(data);
    final chart = (data['revenueChart'] as List<dynamic>? ?? <dynamic>[])
        .map((item) => RevenueChartModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return OwnerDashboardData(stats: stats, revenueChart: chart);
  }

  Future<PaginatedResult<RoomModel>> fetchRooms({
    String? status,
    int page = 1,
    int limit = 50,
  }) async {
    final response = await _http.get(
      ApiConfig.rooms,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (status != null) 'status': status,
      },
    );
    _ensureSuccess(response);

    final payload = response.data['data'] as Map<String, dynamic>? ?? {};
    return PaginatedResult<RoomModel>.fromJson(
      payload,
      (json) => RoomModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<PaginatedResult<InvoiceModel>> fetchInvoices({
    String? status,
    String? roomId,
    String? tenantId,
    int page = 1,
    int limit = 50,
  }) async {
    final response = await _http.get(
      ApiConfig.invoices,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (status != null) 'status': status,
        if (roomId != null) 'roomId': roomId,
        if (tenantId != null) 'tenantId': tenantId,
      },
    );
    _ensureSuccess(response);

    final payload = response.data['data'] as Map<String, dynamic>? ?? {};
    return PaginatedResult<InvoiceModel>.fromJson(
      payload,
      (json) => InvoiceModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<PaginatedResult<IncidentModel>> fetchIncidents({
    String? status,
    int page = 1,
    int limit = 50,
  }) async {
    final response = await _http.get(
      '${ApiConfig.tenant}/maintenance-requests/owner',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (status != null) 'status': status,
      },
    );
    _ensureSuccess(response);

    final payload = response.data['data'] as Map<String, dynamic>? ?? {};
    return PaginatedResult<IncidentModel>.fromJson(
      payload,
      (json) => IncidentModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<PaginatedResult<ServiceModel>> fetchServices({
    bool? isActive,
    int page = 1,
    int limit = 100,
  }) async {
    final response = await _http.get(
      ApiConfig.services,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (isActive != null) 'isActive': isActive,
      },
    );
    _ensureSuccess(response);

    final payload = response.data['data'] as Map<String, dynamic>? ?? {};
    return PaginatedResult<ServiceModel>.fromJson(
      payload,
      (json) => ServiceModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<RoomModel> createRoom(Map<String, dynamic> payload) async {
    final response = await _http.post(ApiConfig.rooms, data: payload);
    _ensureSuccess(response);
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    return RoomModel.fromJson(data);
  }

  Future<RoomModel> updateRoom(String id, Map<String, dynamic> payload) async {
    final response = await _http.put('${ApiConfig.rooms}/$id', data: payload);
    _ensureSuccess(response);
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    return RoomModel.fromJson(data);
  }

  Future<void> deleteRoom(String id) async {
    final response = await _http.delete('${ApiConfig.rooms}/$id');
    _ensureSuccess(response);
  }

  Future<InvoiceModel> createInvoice(Map<String, dynamic> payload) async {
    final response = await _http.post(ApiConfig.invoices, data: payload);
    _ensureSuccess(response);
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    return InvoiceModel.fromJson(data);
  }

  Future<InvoiceModel> updateInvoice(String id, Map<String, dynamic> payload) async {
    final response = await _http.put('${ApiConfig.invoices}/$id', data: payload);
    _ensureSuccess(response);
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    return InvoiceModel.fromJson(data);
  }

  Future<IncidentModel> updateIncidentStatus(String id, String status) async {
    final response = await _http.put(
      '${ApiConfig.tenant}/maintenance-requests/owner/$id/status',
      data: {'status': status},
    );
    _ensureSuccess(response);
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    return IncidentModel.fromJson(data);
  }

  Future<ServiceModel> createService(Map<String, dynamic> payload) async {
    final response = await _http.post(ApiConfig.services, data: payload);
    _ensureSuccess(response);
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    return ServiceModel.fromJson(data);
  }

  Future<ServiceModel> updateService(String id, Map<String, dynamic> payload) async {
    final response = await _http.put('${ApiConfig.services}/$id', data: payload);
    _ensureSuccess(response);
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    return ServiceModel.fromJson(data);
  }

  Future<void> deleteService(String id) async {
    final response = await _http.delete('${ApiConfig.services}/$id');
    _ensureSuccess(response);
  }
}
