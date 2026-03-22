import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/owner_provider.dart';
import '../../data/models/room_model.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../routes/app_router.dart';

class OwnerRoomManagementPage extends StatefulWidget {
  const OwnerRoomManagementPage({super.key});

  @override
  State<OwnerRoomManagementPage> createState() =>
      _OwnerRoomManagementPageState();
}

class _OwnerRoomManagementPageState extends State<OwnerRoomManagementPage> {
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    // Load rooms data when entering this page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OwnerProvider>().loadRooms();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý phòng'),
        actions: [
          PopupMenuButton<String>(
            initialValue: _selectedFilter,
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Text('Tất cả phòng'),
              ),
              const PopupMenuItem(
                value: 'available',
                child: Text('Phòng trống'),
              ),
              const PopupMenuItem(
                value: 'occupied',
                child: Text('Đã cho thuê'),
              ),
              const PopupMenuItem(
                value: 'maintenance',
                child: Text('Đang bảo trì'),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<OwnerProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingRooms && provider.rooms.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          List<RoomModel> rooms = provider.rooms;
          if (rooms.isEmpty) {
            return const Center(child: Text('Không có dữ liệu'));
          }

          if (_selectedFilter != 'all') {
            rooms = rooms.where((r) => r.status == _selectedFilter).toList();
          }

          if (rooms.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () => provider.refreshAll(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                final room = rooms[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () => _showRoomDetails(room),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(room.status)
                                        .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.meeting_room,
                                      color: _getStatusColor(room.status),
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        room.roomNumber,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        '${room.area.toStringAsFixed(0)} m²',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(room.status)
                                    .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _getStatusText(room.status),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: _getStatusColor(room.status),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (room.tenantName != null) ...[
                            Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  room.tenantName!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoChip(
                                  label: 'Giá phòng',
                                  value: FormatUtils.formatCurrency(room.price),
                                  icon: Icons.attach_money,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildInfoChip(
                                  label: 'Tiền cọc',
                                  value: FormatUtils.formatCurrency(room.deposit ?? 0),
                                  icon: Icons.account_balance_wallet,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          if (room.amenities.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: room.amenities.take(3).map((amenity) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    amenity,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddRoomDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Thêm phòng'),
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
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
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
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.meeting_room_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Chưa có phòng nào',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddRoomDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Thêm phòng đầu tiên'),
          ),
        ],
      ),
    );
  }

  void _showRoomDetails(dynamic room) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            controller: scrollController,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    room.roomNumber,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PopupMenuButton(
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
                        Navigator.pop(context);
                        _showEditRoomDialog(context, room);
                      } else if (value == 'delete') {
                        Navigator.pop(context);
                        _showDeleteConfirmDialog(context, room.id);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(room.status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getStatusIcon(room.status),
                      size: 16,
                      color: _getStatusColor(room.status),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _getStatusText(room.status),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(room.status),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Thông tin phòng',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildDetailRow('Diện tích', '${room.area.toStringAsFixed(0)} m²'),
                      const Divider(),
                      _buildDetailRow('Giá phòng', FormatUtils.formatCurrency(room.price)),
                      const Divider(),
                      _buildDetailRow('Tiền cọc', FormatUtils.formatCurrency(room.deposit)),
                      const Divider(),
                      _buildDetailRow('Tầng', room.floor.toString()),
                    ],
                  ),
                ),
              ),
              if (room.tenantName != null) ...[
                const SizedBox(height: 16),
                const Text(
                  'Thông tin người thuê',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildDetailRow('Tên', room.tenantName!),
                        const Divider(),
                        _buildDetailRow('Số điện thoại', room.tenantPhone ?? 'N/A'),
                      ],
                    ),
                  ),
                ),
              ],
              if (room.amenities.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Tiện nghi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: room.amenities.map<Widget>((amenity) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check, size: 16, color: Colors.blue),
                              const SizedBox(width: 6),
                              Text(
                                amenity,
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
              if (room.description.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Mô tả',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      room.description,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  void _showAddRoomDialog(BuildContext context) {
    final provider = context.read<OwnerProvider>();

    // Check if building exists
    if (provider.building == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Chưa thiết lập tòa nhà'),
          content: const Text(
            'Bạn cần thiết lập thông tin tòa nhà trước khi có thể thêm phòng. Hãy chọn "Thiết lập ngay" để bắt đầu.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                // Try to reload building data first
                await provider.loadBuilding();
                if (!context.mounted) return;

                // Check again if building loaded successfully
                if (provider.building == null) {
                  // Still no building, go to setup
                  Navigator.pushNamed(context, AppRouter.buildingSetup);
                }
              },
              child: const Text('Thử tải lại'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRouter.buildingSetup);
              },
              child: const Text('Thiết lập ngay'),
            ),
          ],
        ),
      );
      return;
    }

    final numberController = TextEditingController();
    final areaController = TextEditingController();
    final priceController = TextEditingController();
    final depositController = TextEditingController();
    final floorController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm phòng mới'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: numberController,
                decoration: const InputDecoration(
                  labelText: 'Số phòng',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: areaController,
                decoration: const InputDecoration(
                  labelText: 'Diện tích (m²)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Giá phòng',
                  border: OutlineInputBorder(),
                  suffixText: 'VND',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: depositController,
                decoration: const InputDecoration(
                  labelText: 'Tiền cọc',
                  border: OutlineInputBorder(),
                  suffixText: 'VND',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: floorController,
                decoration: const InputDecoration(
                  labelText: 'Tầng',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'Mô tả',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
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
              if (numberController.text.isEmpty || priceController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
                );
                return;
              }

              context.read<OwnerProvider>().addRoom(
                    roomNumber: numberController.text,
                    area: double.tryParse(areaController.text) ?? 25.0,
                    price: double.tryParse(priceController.text) ?? 0,
                    deposit: double.tryParse(depositController.text) ?? 0,
                    floor: int.tryParse(floorController.text) ?? 1,
                    description: descController.text,
                  );

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã thêm phòng mới')),
              );
            },
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
  }

  void _showEditRoomDialog(BuildContext context, room) {
    final numberController = TextEditingController(text: room.roomNumber);
    final areaController = TextEditingController(text: room.area.toString());
    final priceController = TextEditingController(text: room.price.toString());
    final depositController = TextEditingController(text: room.deposit.toString());
    final floorController = TextEditingController(text: room.floor.toString());
    final descController = TextEditingController(text: room.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chỉnh sửa phòng'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: numberController,
                decoration: const InputDecoration(
                  labelText: 'Số phòng',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: areaController,
                decoration: const InputDecoration(
                  labelText: 'Diện tích (m²)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Giá phòng',
                  border: OutlineInputBorder(),
                  suffixText: 'VND',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: depositController,
                decoration: const InputDecoration(
                  labelText: 'Tiền cọc',
                  border: OutlineInputBorder(),
                  suffixText: 'VND',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: floorController,
                decoration: const InputDecoration(
                  labelText: 'Tầng',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'Mô tả',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
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
              context.read<OwnerProvider>().updateRoom(
                    room.id,
                    roomNumber: numberController.text,
                    area: double.tryParse(areaController.text) ?? room.area,
                    price: double.tryParse(priceController.text) ?? room.price,
                    deposit: double.tryParse(depositController.text) ?? room.deposit,
                    floor: int.tryParse(floorController.text) ?? room.floor,
                    description: descController.text,
                  );

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã cập nhật phòng')),
              );
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, String roomId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa phòng này?'),
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
              context.read<OwnerProvider>().deleteRoom(roomId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã xóa phòng')),
              );
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'available':
        return 'Còn trống';
      case 'occupied':
        return 'Đã thuê';
      case 'maintenance':
        return 'Bảo trì';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'available':
        return Colors.green;
      case 'occupied':
        return Colors.blue;
      case 'maintenance':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'available':
        return Icons.check_circle;
      case 'occupied':
        return Icons.person;
      case 'maintenance':
        return Icons.build;
      default:
        return Icons.help;
    }
  }
}
