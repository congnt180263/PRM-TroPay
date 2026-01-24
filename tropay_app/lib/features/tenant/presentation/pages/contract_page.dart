import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tenant_provider.dart';
import '../../../../core/utils/format_utils.dart';

class ContractPage extends StatelessWidget {
  const ContractPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hợp đồng'),
      ),
      body: Consumer<TenantProvider>(
        builder: (context, provider, child) {
          final contract = provider.activeContract;

          if (contract == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.description_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Không có hợp đồng nào',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          Color statusColor = contract.isActive
              ? Colors.green
              : contract.isExpired
                  ? Colors.orange
                  : Colors.red;

          return RefreshIndicator(
            onRefresh: () => provider.loadContract(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Card
                  Card(
                    color: statusColor.withValues(alpha: 0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Icon(
                            contract.isActive
                                ? Icons.check_circle
                                : contract.isExpired
                                    ? Icons.schedule
                                    : Icons.cancel,
                            color: statusColor,
                            size: 32,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  contract.isActive
                                      ? 'Hợp đồng đang hoạt động'
                                      : contract.isExpired
                                          ? 'Hợp đồng đã hết hạn'
                                          : 'Hợp đồng đã chấm dứt',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: statusColor,
                                      ),
                                ),
                                if (contract.isActive) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Còn ${contract.daysRemaining} ngày',
                                    style: TextStyle(color: statusColor),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Contract Information
                  Text(
                    'Thông tin hợp đồng',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildInfoRow(
                            context,
                            'Số hợp đồng',
                            contract.id,
                            Icons.numbers,
                          ),
                          const Divider(height: 24),
                          _buildInfoRow(
                            context,
                            'Phòng',
                            contract.roomNumber,
                            Icons.meeting_room,
                          ),
                          const Divider(height: 24),
                          _buildInfoRow(
                            context,
                            'Chủ nhà',
                            contract.ownerName,
                            Icons.person,
                          ),
                          const Divider(height: 24),
                          _buildInfoRow(
                            context,
                            'Người thuê',
                            contract.tenantName,
                            Icons.person_outline,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildInfoRow(
                            context,
                            'Giá thuê',
                            '\${FormatUtils.formatCurrency(contract.rentPrice)}/tháng',
                            Icons.payments,
                            valueColor: Theme.of(context).colorScheme.primary,
                          ),
                          const Divider(height: 24),
                          _buildInfoRow(
                            context,
                            'Tiền cọc',
                            FormatUtils.formatCurrency(contract.deposit),
                            Icons.account_balance_wallet,
                            valueColor: Colors.orange,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildInfoRow(
                            context,
                            'Ngày bắt đầu',
                            FormatUtils.formatDate(contract.startDate),
                            Icons.calendar_today,
                          ),
                          const Divider(height: 24),
                          _buildInfoRow(
                            context,
                            'Ngày kết thúc',
                            FormatUtils.formatDate(contract.endDate),
                            Icons.event,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Terms & Conditions
                  Text(
                    'Điều khoản hợp đồng',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: contract.terms.asMap().entries.map((entry) {
                          final index = entry.key;
                          final term = entry.value;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primaryContainer,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    term,
                                    style: const TextStyle(height: 1.5),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Download Contract Button
                  if (contract.documentUrl != null)
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          // TODO: Download contract document
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Chức năng tải xuống đang được phát triển'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.download),
                        label: const Text('Tải xuống hợp đồng'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: valueColor,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
