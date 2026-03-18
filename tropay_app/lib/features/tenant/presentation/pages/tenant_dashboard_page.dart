import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tenant_provider.dart';
import '../../../../core/utils/format_utils.dart';
import 'incident_management_page.dart';
import 'invoice_overview_page.dart';
import 'service_management_page.dart';
import 'tenant_notifications_page.dart';

class TenantDashboardPage extends StatefulWidget {
  const TenantDashboardPage({super.key});

  @override
  State<TenantDashboardPage> createState() => _TenantDashboardPageState();
}

class _TenantDashboardPageState extends State<TenantDashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TenantProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              _openPage(const TenantNotificationsPage());
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<TenantProvider>().refreshAll(),
        child: Consumer<TenantProvider>(
          builder: (context, provider, child) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Card
                  _buildWelcomeCard(provider),
                  const SizedBox(height: 20),

                  // Quick Stats
                  _buildQuickStats(provider),
                  const SizedBox(height: 24),

                  // Recent Invoices
                  _buildSectionHeader('Hóa đơn gần đây', onSeeAll: () {
                    _openPage(const InvoiceOverviewPage());
                  }),
                  const SizedBox(height: 12),
                  _buildRecentInvoices(provider),
                  const SizedBox(height: 24),

                  // Recent Incidents
                  _buildSectionHeader('Sự cố đang xử lý', onSeeAll: () {
                    _openPage(const IncidentManagementPage());
                  }),
                  const SizedBox(height: 12),
                  _buildRecentIncidents(provider),
                  const SizedBox(height: 24),

                  // Quick Actions
                  _buildQuickActions(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(TenantProvider provider) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Xin chào! 👋',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Phòng ${provider.roomNumber}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.home,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(TenantProvider provider) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.receipt_long,
            label: 'Chưa thanh toán',
            value: FormatUtils.formatCurrency(provider.totalUnpaid),
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.warning_amber,
            label: 'Sự cố chờ xử lý',
            value: '${provider.pendingIncidents}',
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            child: const Text('Xem tất cả'),
          ),
      ],
    );
  }

  Widget _buildRecentInvoices(TenantProvider provider) {
    if (provider.isLoadingInvoices) {
      return const Center(child: CircularProgressIndicator());
    }

    final recentInvoices = provider.unpaidInvoices.take(3).toList();

    if (recentInvoices.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(
              'Không có hóa đơn chưa thanh toán',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ),
      );
    }

    return Column(
      children: recentInvoices.map<Widget>((invoice) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: invoice.isOverdue ? Colors.red : Colors.orange,
              child: const Icon(Icons.receipt, color: Colors.white),
            ),
            title: Text(invoice.month),
            subtitle: Text(
              invoice.isOverdue ? 'Quá hạn thanh toán' : 'Hạn: ${FormatUtils.formatDate(invoice.dueDate)}',
            ),
            trailing: Text(
              FormatUtils.formatCurrency(invoice.totalAmount),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            onTap: () {
              _openPage(const InvoiceOverviewPage());
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRecentIncidents(TenantProvider provider) {
    if (provider.isLoadingIncidents) {
      return const Center(child: CircularProgressIndicator());
    }

    final recentIncidents = provider.pendingIncidentsList.take(3).toList();

    if (recentIncidents.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(
              'Không có sự cố đang xử lý',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ),
      );
    }

    return Column(
      children: recentIncidents.map<Widget>((incident) {
        Color statusColor = incident.isPending
            ? Colors.orange
            : incident.isInProgress
                ? Colors.blue
                : Colors.green;

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: statusColor,
              child: const Icon(Icons.warning_amber, color: Colors.white),
            ),
            title: Text(incident.title),
            subtitle: Text(
              FormatUtils.formatTimeAgo(incident.createdAt),
            ),
            trailing: Chip(
              label: Text(
                incident.status == 'pending' ? 'Chờ xử lý' : 'Đang xử lý',
                style: const TextStyle(fontSize: 12),
              ),
              backgroundColor: statusColor.withValues(alpha: 0.2),
              labelStyle: TextStyle(color: statusColor),
            ),
            onTap: () {
              _openPage(const IncidentManagementPage());
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thao tác nhanh',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                icon: Icons.report_problem,
                label: 'Báo cáo sự cố',
                color: Colors.red,
                onTap: () {
                  _openPage(const IncidentManagementPage());
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                icon: Icons.history,
                label: 'Lịch sử',
                color: Colors.blue,
                onTap: () {
                  _openPage(const ServiceManagementPage(initialTabIndex: 1));
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _openPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
