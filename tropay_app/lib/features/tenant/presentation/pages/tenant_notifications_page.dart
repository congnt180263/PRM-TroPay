import 'package:flutter/material.dart';

class TenantNotificationsPage extends StatelessWidget {
  const TenantNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final demoNotifications = [
      (
        'Hóa đơn mới',
        'Hóa đơn tháng này đã sẵn sàng. Vui lòng kiểm tra và thanh toán trước hạn.',
        Icons.receipt_long,
      ),
      (
        'Cập nhật sự cố',
        'Yêu cầu bảo trì "Rò rỉ nước" đang được xử lý.',
        Icons.build,
      ),
      (
        'Thông báo hệ thống',
        'Ứng dụng sẽ bảo trì từ 22:00 đến 23:00 hôm nay.',
        Icons.info_outline,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: demoNotifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final item = demoNotifications[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  item.$3,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              title: Text(item.$1),
              subtitle: Text(item.$2),
            ),
          );
        },
      ),
    );
  }
}
