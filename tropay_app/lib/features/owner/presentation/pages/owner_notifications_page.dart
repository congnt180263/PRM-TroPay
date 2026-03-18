import 'package:flutter/material.dart';

class OwnerNotificationsPage extends StatelessWidget {
  const OwnerNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = _notifications[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: item.color.withValues(alpha: 0.12),
                child: Icon(item.icon, color: item.color),
              ),
              title: Text(item.title),
              subtitle: Text(item.subtitle),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.time,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (item.isUnread)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
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
}

class _NotificationItem {
  const _NotificationItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.color,
    this.isUnread = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final Color color;
  final bool isUnread;
}

const List<_NotificationItem> _notifications = [
  _NotificationItem(
    icon: Icons.payment,
    title: 'Thanh toán thành công',
    subtitle: 'Hóa đơn phòng A202 - Tháng 1/2026',
    time: '2 giờ trước',
    color: Colors.green,
    isUnread: true,
  ),
  _NotificationItem(
    icon: Icons.report_problem,
    title: 'Sự cố mới được báo',
    subtitle: 'Máy lạnh A101 không hoạt động',
    time: '5 giờ trước',
    color: Colors.red,
    isUnread: true,
  ),
  _NotificationItem(
    icon: Icons.description,
    title: 'Hợp đồng mới',
    subtitle: 'Phòng A105 - Nguyễn Văn D',
    time: '1 ngày trước',
    color: Colors.blue,
  ),
  _NotificationItem(
    icon: Icons.miscellaneous_services,
    title: 'Dịch vụ Internet đã gia hạn',
    subtitle: 'Gia hạn dịch vụ tháng này',
    time: '2 ngày trước',
    color: Colors.purple,
  ),
];
