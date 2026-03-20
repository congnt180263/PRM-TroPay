import 'package:flutter/material.dart';
import '../../data/models/invoice_model.dart';
import '../../data/models/incident_model.dart';
import '../../data/models/service_model.dart';
import '../../data/models/contract_model.dart';
import '../../data/models/payment_intent.dart';
import '../../data/services/tenant_api_service.dart';

class TenantProvider with ChangeNotifier {
  final TenantApiService _api = TenantApiService();

  // Dashboard data
  String _roomNumber = 'A101';
  double _totalUnpaid = 0.0;
  int _pendingIncidents = 0;
  ContractModel? _activeContract;
  String? _dashboardError;

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
  List<ServiceHistoryModel> _serviceHistory = [];
  bool _isLoadingServices = false;
  String? _servicesError;

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
  String? get dashboardError => _dashboardError;
  String? get invoicesError => _invoicesError;
  String? get incidentsError => _incidentsError;
  String? get servicesError => _servicesError;

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
    _dashboardError = null;
    try {
      final data = await _api.fetchDashboard();
      final summary = data['summary'] as Map<String, dynamic>? ?? {};
      _roomNumber = summary['roomNumber']?.toString() ?? _roomNumber;
      _totalUnpaid = (summary['totalUnpaid'] ?? 0).toDouble();
      _pendingIncidents = summary['pendingIncidents'] ?? 0;
      _activeContract = _api.extractContractFromDashboard(data);
    } catch (e) {
      _dashboardError = e.toString();
    }
    notifyListeners();
  }

  Future<void> loadInvoices() async {
    _isLoadingInvoices = true;
    _invoicesError = null;
    notifyListeners();

    try {
      final result = await _api.fetchInvoices(limit: 50);
      _invoices = result.items;
      _totalUnpaid = _invoices
          .where((i) => !i.isPaid)
          .fold(0.0, (sum, i) => sum + i.totalAmount);
    } catch (e) {
      _invoices = [];
      _totalUnpaid = 0;
      _invoicesError = e.toString();
    } finally {
      _isLoadingInvoices = false;
      notifyListeners();
    }
  }

  Future<void> loadIncidents() async {
    _isLoadingIncidents = true;
    _incidentsError = null;
    notifyListeners();

    try {
      final result = await _api.fetchMaintenanceRequests(limit: 50);
      _incidents = result.items;
      _pendingIncidents = _incidents.where((i) => i.isPending).length;
    } catch (e) {
      _incidents = [];
      _pendingIncidents = 0;
      _incidentsError = e.toString();
    } finally {
      _isLoadingIncidents = false;
      notifyListeners();
    }
  }

  Future<void> loadServices() async {
    _isLoadingServices = true;
    _servicesError = null;
    notifyListeners();

    try {
      await _api.fetchServiceUsage();
      final history = await _api.fetchServiceHistory(limit: 50);
      _serviceHistory = history.items;
      _services = [];
    } catch (e) {
      _services = [];
      _serviceHistory = [];
      _servicesError = e.toString();
    } finally {
      _isLoadingServices = false;
      notifyListeners();
    }
  }

  Future<void> loadContract() async {
    try {
      final data = await _api.fetchDashboard();
      _activeContract = _api.extractContractFromDashboard(data);
    } catch (e) {
      _dashboardError = e.toString();
    }
    notifyListeners();
  }

  Future<void> reportIncident({
    required String title,
    required String description,
    required String category,
    required String priority,
  }) async {
    try {
      final created = await _api.createMaintenanceRequest({
        'title': title,
        'description': description,
        'category': category,
        'priority': priority,
      });

      _incidents.insert(0, created);
      _pendingIncidents = _incidents.where((i) => i.isPending).length;
    } catch (e) {
      _incidentsError = e.toString();
      rethrow;
    }

    notifyListeners();
  }

  Future<void> payInvoice(String invoiceId) async {
    final invoice = _invoices.firstWhere(
      (i) => i.id == invoiceId,
      orElse: () => InvoiceModel(
        id: invoiceId,
        roomNumber: '',
        month: '',
        totalAmount: 0,
        electricCost: 0,
        waterCost: 0,
        roomCost: 0,
        serviceCost: 0,
        status: 'unpaid',
        dueDate: DateTime.now(),
      ),
    );

    try {
      await _api.payInvoice(
        invoiceId: invoiceId,
        amount: invoice.totalAmount,
        paymentMethod: 'bank_transfer',
      );
      await loadInvoices();
    } catch (e) {
      _invoicesError = e.toString();
      rethrow;
    }
  }

  Future<PaymentIntent> initiateMomoPayment(InvoiceModel invoice) async {
    try {
      return await _api.createMomoPayment(
        invoiceId: invoice.id,
        amount: invoice.totalAmount,
      );
    } catch (e) {
      _invoicesError = e.toString();
      rethrow;
    }
  }

  Future<bool> refreshPaymentStatus(String paymentId) async {
    try {
      final payment = await _api.getPayment(paymentId);
      final status = payment['status']?.toString().toLowerCase();
      const successStatuses = {'success', 'succeeded', 'paid', 'completed'};
      if (successStatuses.contains(status)) {
        await loadInvoices();
        return true;
      }
      return false;
    } catch (e) {
      _invoicesError = e.toString();
      return false;
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
