import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/owner_provider.dart';
import '../../../../core/utils/format_utils.dart';

class OwnerServicesPage extends StatelessWidget {
  const OwnerServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý dịch vụ'),
      ),
      body: Consumer<OwnerProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingServices && provider.services.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.services.isEmpty) {
            return _buildEmptyState(context);
          }

          return RefreshIndicator(
            onRefresh: () => provider.refreshAll(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.services.length,
              itemBuilder: (context, index) {
                final service = provider.services[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                        backgroundColor: _getServiceColor(service.name).withValues(alpha: 0.1),
                          child: Icon(
                            _getServiceIcon(service.name),
                            color: _getServiceColor(service.name),
                          ),
                        ),
                        title: Text(
                          service.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              service.description,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: service.isActive
                                      ? Colors.green.withValues(alpha: 0.1)
                                      : Colors.grey.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        service.isActive ? Icons.check_circle : Icons.cancel,
                                        size: 14,
                                        color: service.isActive ? Colors.green : Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        service.isActive ? 'Đang hoạt động' : 'Tạm dừng',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: service.isActive ? Colors.green : Colors.grey,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, size: 20),
                                  SizedBox(width: 8),
                                  Text('Chỉnh sửa'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'toggle',
                              child: Row(
                                children: [
                                  Icon(
                                    service.isActive ? Icons.pause : Icons.play_arrow,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(service.isActive ? 'Tạm dừng' : 'Kích hoạt'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, size: 20, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Xóa', style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 'edit') {
                              _showEditServiceDialog(context, service);
                            } else if (value == 'toggle') {
                              provider.updateService(
                                service.id,
                                name: service.name,
                                description: service.description,
                                price: service.price,
                                unit: service.unit,
                                isActive: !service.isActive,
                              );
                            } else if (value == 'delete') {
                              _showDeleteConfirmDialog(context, service.id);
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildInfoChip(
                                label: 'Đơn giá',
                                value: FormatUtils.formatCurrency(service.price),
                                icon: Icons.attach_money,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildInfoChip(
                                label: 'Đơn vị',
                                value: service.unit,
                                icon: Icons.assessment,
                                color: Colors.purple,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddServiceDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Thêm dịch vụ'),
      ),
    );
  }

  Widget _buildInfoChip({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.miscellaneous_services_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Chưa có dịch vụ nào',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Thêm dịch vụ để quản lý',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddServiceDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Thêm dịch vụ đầu tiên'),
          ),
        ],
      ),
    );
  }

  void _showAddServiceDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final priceController = TextEditingController();
    final unitController = TextEditingController(text: 'tháng');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm dịch vụ mới'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Tên dịch vụ',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'Mô tả',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Đơn giá',
                  border: OutlineInputBorder(),
                  suffixText: 'VND',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: unitController,
                decoration: const InputDecoration(
                  labelText: 'Đơn vị',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () {
              if (nameController.text.isEmpty || priceController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
                );
                return;
              }

              context.read<OwnerProvider>().addService(
                    name: nameController.text,
                    description: descController.text,
                    price: double.tryParse(priceController.text) ?? 0,
                    unit: unitController.text,
                  );

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã thêm dịch vụ')),
              );
            },
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
  }

  void _showEditServiceDialog(BuildContext context, service) {
    final nameController = TextEditingController(text: service.name);
    final descController = TextEditingController(text: service.description);
    final priceController = TextEditingController(text: service.price.toString());
    final unitController = TextEditingController(text: service.unit);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chỉnh sửa dịch vụ'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Tên dịch vụ',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'Mô tả',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Đơn giá',
                  border: OutlineInputBorder(),
                  suffixText: 'VND',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: unitController,
                decoration: const InputDecoration(
                  labelText: 'Đơn vị',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () {
              context.read<OwnerProvider>().updateService(
                    service.id,
                    name: nameController.text,
                    description: descController.text,
                    price: double.tryParse(priceController.text) ?? service.price,
                    unit: unitController.text,
                    isActive: service.isActive,
                  );

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã cập nhật dịch vụ')),
              );
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, String serviceId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa dịch vụ này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              context.read<OwnerProvider>().deleteService(serviceId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã xóa dịch vụ')),
              );
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  IconData _getServiceIcon(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('điện')) return Icons.electrical_services;
    if (lowerName.contains('nước')) return Icons.water_drop;
    if (lowerName.contains('internet') || lowerName.contains('wifi')) {
      return Icons.wifi;
    }
    if (lowerName.contains('vệ sinh')) return Icons.cleaning_services;
    if (lowerName.contains('bảo vệ')) return Icons.security;
    return Icons.miscellaneous_services;
  }

  Color _getServiceColor(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('điện')) return Colors.amber;
    if (lowerName.contains('nước')) return Colors.blue;
    if (lowerName.contains('internet') || lowerName.contains('wifi')) {
      return Colors.purple;
    }
    if (lowerName.contains('vệ sinh')) return Colors.green;
    if (lowerName.contains('bảo vệ')) return Colors.orange;
    return Colors.grey;
  }
}
