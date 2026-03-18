import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tenant_provider.dart';
import '../../data/models/service_model.dart';
import '../../../../core/utils/format_utils.dart';

class ServiceManagementPage extends StatelessWidget {
  const ServiceManagementPage({super.key, this.initialTabIndex = 0});

  final int initialTabIndex;

  @override
  Widget build(BuildContext context) {
    final tabIndex = initialTabIndex < 0
        ? 0
        : initialTabIndex > 1
            ? 1
            : initialTabIndex;

    return DefaultTabController(
      length: 2,
      initialIndex: tabIndex,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dịch vụ'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Dịch vụ hiện tại'),
              Tab(text: 'Lịch sử'),
            ],
          ),
        ),
        body: Consumer<TenantProvider>(
          builder: (context, provider, child) {
            if (provider.isLoadingServices) {
              return const Center(child: CircularProgressIndicator());
            }

            return TabBarView(
              children: [
                _buildServicesList(context, provider),
                _buildServiceHistory(context, provider),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildServicesList(BuildContext context, TenantProvider provider) {
    if (provider.services.isEmpty) {
      return const Center(
        child: Text('Không có dịch vụ nào'),
      );
    }

    return RefreshIndicator(
      onRefresh: () => provider.loadServices(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: provider.services.length,
        itemBuilder: (context, index) {
          final service = provider.services[index];
          return _buildServiceCard(context, service);
        },
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, ServiceModel service) {
    IconData icon;
    Color color;

    switch (service.iconName) {
      case 'electrical_services':
        icon = Icons.electrical_services;
        color = Colors.amber;
        break;
      case 'water_drop':
        icon = Icons.water_drop;
        color = Colors.blue;
        break;
      case 'wifi':
        icon = Icons.wifi;
        color = Colors.purple;
        break;
      case 'cleaning_services':
        icon = Icons.cleaning_services;
        color = Colors.green;
        break;
      default:
        icon = Icons.miscellaneous_services;
        color = Colors.grey;
    }

    String unitText;
    switch (service.unit) {
      case 'kwh':
        unitText = 'kWh';
        break;
      case 'm3':
        unitText = 'm³';
        break;
      case 'month':
        unitText = 'tháng';
        break;
      default:
        unitText = 'lần';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    service.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: service.isActive ? Colors.green.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          service.isActive ? 'Đang sử dụng' : 'Không hoạt động',
                          style: TextStyle(
                            color: service.isActive ? Colors.green : Colors.grey,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  FormatUtils.formatCurrency(service.price),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '/$unitText',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceHistory(BuildContext context, TenantProvider provider) {
    if (provider.serviceHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Chưa có lịch sử sử dụng dịch vụ',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => provider.loadServices(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: provider.serviceHistory.length,
        itemBuilder: (context, index) {
          final history = provider.serviceHistory[index];
          return _buildHistoryCard(context, history);
        },
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, ServiceHistoryModel history) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.receipt_long,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(history.serviceName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(history.description),
            const SizedBox(height: 4),
            Text(
              FormatUtils.formatDate(history.date),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: Text(
          FormatUtils.formatCurrency(history.amount),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        isThreeLine: true,
      ),
    );
  }
}
