import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/owner_provider.dart';
import '../../data/models/dashboard_stats_model.dart';
import '../../../../core/utils/format_utils.dart';

class OwnerReportsPage extends StatelessWidget {
  const OwnerReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Báo cáo'),
      ),
      body: Consumer<OwnerProvider>(
        builder: (context, provider, child) {
          final stats = provider.dashboardStats;
          final revenueChart = provider.revenueChart;

          if (stats == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSummaryCards(context, stats),
              const SizedBox(height: 16),
              _buildRevenueBlock(context, revenueChart),
              const SizedBox(height: 16),
              _buildNotesCard(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context, DashboardStatsModel stats) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        _buildStatCard(
          context,
          icon: Icons.attach_money,
          label: 'Doanh thu tháng',
          value: FormatUtils.formatCurrency(stats.monthlyRevenue),
          color: Colors.green,
        ),
        _buildStatCard(
          context,
          icon: Icons.receipt_long,
          label: 'HĐ chưa thu',
          value: '${stats.unpaidInvoices}',
          color: Colors.orange,
        ),
        _buildStatCard(
          context,
          icon: Icons.warning_amber,
          label: 'Sự cố chờ',
          value: '${stats.pendingIncidents}',
          color: Colors.red,
        ),
        _buildStatCard(
          context,
          icon: Icons.analytics,
          label: 'Tỷ lệ lấp đầy',
          value: '${stats.occupancyRate.toStringAsFixed(1)}%',
          color: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
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
            Icon(icon, color: color),
            const SizedBox(height: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueBlock(
    BuildContext context,
    List<RevenueChartModel>? revenueChart,
  ) {
    if (revenueChart == null || revenueChart.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Chưa có dữ liệu doanh thu',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    final maxRevenue = revenueChart
        .map((e) => e.amount)
        .reduce((a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Doanh thu 6 tháng',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 160,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: revenueChart.map((data) {
                  final heightPercent = (data.amount / maxRevenue) * 100;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${(data.amount / 1000000).toStringAsFixed(0)}M',
                        style: const TextStyle(fontSize: 10),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 30,
                        height: heightPercent,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.6),
                            ],
                          ),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.month,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ghi chú',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Báo cáo chi tiết sẽ được tích hợp khi backend hoàn thiện. Bạn có thể theo dõi nhanh doanh thu, hóa đơn và sự cố ở đây.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
