import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tenant_provider.dart';
import '../../data/models/invoice_model.dart';
import '../../../../core/utils/format_utils.dart';

class InvoiceOverviewPage extends StatelessWidget {
  const InvoiceOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hóa đơn'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Chưa thanh toán'),
              Tab(text: 'Đã thanh toán'),
            ],
          ),
        ),
        body: Consumer<TenantProvider>(
          builder: (context, provider, child) {
            if (provider.isLoadingInvoices) {
              return const Center(child: CircularProgressIndicator());
            }

            return TabBarView(
              children: [
                _buildInvoiceList(context, provider.unpaidInvoices, false),
                _buildInvoiceList(context, provider.paidInvoices, true),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildInvoiceList(BuildContext context, List<InvoiceModel> invoices, bool isPaid) {
    if (invoices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isPaid ? Icons.check_circle_outline : Icons.receipt_long_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              isPaid ? 'Chưa có hóa đơn đã thanh toán' : 'Không có hóa đơn chưa thanh toán',
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
      onRefresh: () => context.read<TenantProvider>().loadInvoices(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: invoices.length,
        itemBuilder: (context, index) {
          final invoice = invoices[index];
          return _buildInvoiceCard(context, invoice);
        },
      ),
    );
  }

  Widget _buildInvoiceCard(BuildContext context, InvoiceModel invoice) {
    final theme = Theme.of(context);
    Color statusColor = invoice.isPaid
        ? Colors.green
        : invoice.isOverdue
            ? Colors.red
            : Colors.orange;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          _showInvoiceDetail(context, invoice);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    invoice.month,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      invoice.isPaid
                          ? 'Đã thanh toán'
                          : invoice.isOverdue
                              ? 'Quá hạn'
                              : 'Chưa thanh toán',
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              _buildInvoiceRow('Tiền phòng:', FormatUtils.formatCurrency(invoice.roomCost)),
              const SizedBox(height: 8),
              _buildInvoiceRow('Tiền điện:', FormatUtils.formatCurrency(invoice.electricCost)),
              const SizedBox(height: 8),
              _buildInvoiceRow('Tiền nước:', FormatUtils.formatCurrency(invoice.waterCost)),
              const SizedBox(height: 8),
              _buildInvoiceRow('Dịch vụ:', FormatUtils.formatCurrency(invoice.serviceCost)),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tổng cộng:',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    FormatUtils.formatCurrency(invoice.totalAmount),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    invoice.isPaid
                        ? 'Đã thanh toán: ${FormatUtils.formatDate(invoice.paidDate!)}'
                        : 'Hạn thanh toán: ${FormatUtils.formatDate(invoice.dueDate)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  if (!invoice.isPaid)
                    TextButton.icon(
                      onPressed: () {
                        _handlePayment(context, invoice);
                      },
                      icon: const Icon(Icons.payment, size: 18),
                      label: const Text('Thanh toán'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInvoiceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey[700]),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  void _showInvoiceDetail(BuildContext context, InvoiceModel invoice) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(24),
          child: ListView(
            controller: scrollController,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Chi tiết hóa đơn',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Tháng', invoice.month),
              _buildDetailRow('Phòng', invoice.roomNumber),
              const Divider(height: 32),
              _buildDetailRow('Tiền phòng', FormatUtils.formatCurrency(invoice.roomCost)),
              _buildDetailRow('Tiền điện', FormatUtils.formatCurrency(invoice.electricCost)),
              _buildDetailRow('Tiền nước', FormatUtils.formatCurrency(invoice.waterCost)),
              _buildDetailRow('Dịch vụ', FormatUtils.formatCurrency(invoice.serviceCost)),
              const Divider(height: 32),
              _buildDetailRow(
                'Tổng cộng',
                FormatUtils.formatCurrency(invoice.totalAmount),
                isTotal: true,
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Hạn thanh toán', FormatUtils.formatDate(invoice.dueDate)),
              if (invoice.isPaid)
                _buildDetailRow('Đã thanh toán', FormatUtils.formatDate(invoice.paidDate!)),
              const SizedBox(height: 24),
              if (!invoice.isPaid)
                FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _handlePayment(context, invoice);
                  },
                  icon: const Icon(Icons.payment),
                  label: const Text('Thanh toán ngay'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 15,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 20 : 15,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _handlePayment(BuildContext context, InvoiceModel invoice) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thanh toán hóa đơn'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hóa đơn: ${invoice.month}'),
            const SizedBox(height: 8),
            Text(
              'Số tiền: ${FormatUtils.formatCurrency(invoice.totalAmount)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text('Chọn phương thức thanh toán:'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement MoMo payment
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Chức năng thanh toán MoMo đang được phát triển'),
                ),
              );
            },
            icon: const Icon(Icons.account_balance_wallet),
            label: const Text('MoMo'),
          ),
        ],
      ),
    );
  }
}
