import 'package:dio/dio.dart';
import '../../../../core/constants/api_config.dart';
import '../../../../core/models/paginated_result.dart';
import '../../../../core/services/http_client_service.dart';
import '../models/incident_model.dart';
import '../models/invoice_model.dart';
import '../models/contract_model.dart';
import '../models/service_model.dart';
import '../models/payment_intent.dart';

class TenantApiService {
  final HttpClientService _http = HttpClientService();

  void _ensureSuccess(Response response) {
    if (response.data is Map && response.data['success'] == true) {
      return;
    }
    throw Exception(response.data['message'] ?? 'Request failed');
  }

  Future<Map<String, dynamic>> fetchDashboard() async {
    final response = await _http.get('${ApiConfig.tenant}/dashboard');
    _ensureSuccess(response);
    return response.data['data'] as Map<String, dynamic>? ?? {};
  }

  Future<PaginatedResult<InvoiceModel>> fetchInvoices({
    String? status,
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _http.get(
      '${ApiConfig.tenant}/invoices',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (status != null) 'status': status,
        if (search != null) 'search': search,
      },
    );
    _ensureSuccess(response);

    final payload = response.data['data'] as Map<String, dynamic>? ?? {};
    final invoices = (payload['invoices'] as List<dynamic>? ?? <dynamic>[])
        .map((item) => InvoiceModel.fromJson(item as Map<String, dynamic>))
        .toList();
    final pagination = Pagination.fromJson(payload['pagination'] as Map<String, dynamic>?);

    return PaginatedResult<InvoiceModel>(items: invoices, pagination: pagination);
  }

  Future<PaginatedResult<IncidentModel>> fetchMaintenanceRequests({
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _http.get(
      '${ApiConfig.tenant}/maintenance-requests',
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

  Future<IncidentModel> createMaintenanceRequest(Map<String, dynamic> payload) async {
    final response = await _http.post(
      '${ApiConfig.tenant}/maintenance-requests',
      data: payload,
    );
    _ensureSuccess(response);
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    return IncidentModel.fromJson(data);
  }

  Future<Map<String, dynamic>> fetchServiceUsage({int months = 6}) async {
    final response = await _http.get(
      '${ApiConfig.tenant}/services/usage',
      queryParameters: {'months': months},
    );
    _ensureSuccess(response);
    return response.data['data'] as Map<String, dynamic>? ?? {};
  }

  Future<PaginatedResult<ServiceHistoryModel>> fetchServiceHistory({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _http.get(
      '${ApiConfig.tenant}/services/history',
      queryParameters: {'page': page, 'limit': limit},
    );
    _ensureSuccess(response);

    final payload = response.data['data'] as Map<String, dynamic>? ?? {};
    final history = (payload['data'] as List<dynamic>? ?? <dynamic>[]).map((item) {
      final map = item as Map<String, dynamic>? ?? {};
      final order = map['orderId'] as Map<String, dynamic>?;
      final invoice = map['invoiceId'] as Map<String, dynamic>?;
      final description = order?['items']?.toString() ?? map['metadata']?.toString() ?? '';
      final name = order?['orderNumber'] ?? invoice?['invoiceNumber'] ?? 'Payment';
      return ServiceHistoryModel(
        id: map['id'] ?? map['_id'] ?? '',
        serviceName: name,
        amount: (map['amount'] ?? 0).toDouble(),
        date: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
        description: description,
      );
    }).toList();

    final pagination = Pagination.fromJson(payload['pagination'] as Map<String, dynamic>?);
    return PaginatedResult<ServiceHistoryModel>(items: history, pagination: pagination);
  }

  Future<List<ServiceModel>> fetchServices() async {
    final response = await _http.get('${ApiConfig.tenant}/services/usage');
    _ensureSuccess(response);

    final payload = response.data['data'] as Map<String, dynamic>? ?? {};
    final services = (payload['services'] as List<dynamic>? ?? <dynamic>[])
        .map((item) => ServiceModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return services;
  }

  Future<void> payInvoice({
    required String invoiceId,
    required double amount,
    String paymentMethod = 'bank_transfer',
    String? paymentGateway,
  }) async {
    final response = await _http.post(
      ApiConfig.payments,
      data: {
        'invoiceId': invoiceId,
        'amount': amount,
        'paymentMethod': paymentMethod,
        if (paymentGateway != null) 'paymentGateway': paymentGateway,
      },
    );
    _ensureSuccess(response);
  }

  Future<PaymentIntent> createMomoPayment({
    required String invoiceId,
    required double amount,
  }) async {
    final response = await _http.post(
      ApiConfig.payments,
      data: {
        'invoiceId': invoiceId,
        'amount': amount,
        'paymentMethod': 'e_wallet',
        'paymentGateway': 'momo',
      },
    );
    _ensureSuccess(response);

    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    return PaymentIntent.fromJson(data);
  }

  Future<Map<String, dynamic>> getPayment(String paymentId) async {
    final response = await _http.get('${ApiConfig.payments}/$paymentId');
    _ensureSuccess(response);
    return response.data['data'] as Map<String, dynamic>? ?? {};
  }

  Future<void> updateInvoiceStatus(String invoiceId, String status) async {
    final response = await _http.patch(
      '${ApiConfig.tenant}/invoices/$invoiceId/status',
      data: {'status': status},
    );
    _ensureSuccess(response);
  }

  ContractModel? extractContractFromDashboard(Map<String, dynamic> data) {
    final lease = data['activeLease'] as Map<String, dynamic>?;
    if (lease == null) return null;
    return ContractModel.fromJson(lease);
  }
}
