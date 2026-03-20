import 'package:flutter/material.dart';

class TenantNotificationSettingsPage extends StatefulWidget {
  const TenantNotificationSettingsPage({super.key});

  @override
  State<TenantNotificationSettingsPage> createState() => _TenantNotificationSettingsPageState();
}

class _TenantNotificationSettingsPageState extends State<TenantNotificationSettingsPage> {
  bool _pushEnabled = true;
  bool _invoiceReminders = true;
  bool _incidentUpdates = true;
  bool _contractAlerts = true;
  bool _emailUpdates = false;
  bool _smsUpdates = false;
  bool _quietHoursEnabled = false;
  TimeOfDay _quietStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietEnd = const TimeOfDay(hour: 7, minute: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt thông báo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Thông báo đẩy'),
                  subtitle: const Text('Nhận thông báo trên thiết bị của bạn'),
                  value: _pushEnabled,
                  onChanged: (value) => setState(() => _pushEnabled = value),
                  secondary: const Icon(Icons.notifications_active_outlined),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Nhắc thanh toán hóa đơn'),
                  value: _invoiceReminders,
                  onChanged: !_pushEnabled
                      ? null
                      : (value) => setState(() => _invoiceReminders = value),
                  secondary: const Icon(Icons.receipt_long_outlined),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Cập nhật sự cố & bảo trì'),
                  value: _incidentUpdates,
                  onChanged: !_pushEnabled
                      ? null
                      : (value) => setState(() => _incidentUpdates = value),
                  secondary: const Icon(Icons.build_outlined),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Cảnh báo hợp đồng & phòng'),
                  value: _contractAlerts,
                  onChanged: !_pushEnabled
                      ? null
                      : (value) => setState(() => _contractAlerts = value),
                  secondary: const Icon(Icons.description_outlined),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Email'),
                  subtitle: const Text('Gửi thông báo đến email đăng ký'),
                  value: _emailUpdates,
                  onChanged: (value) => setState(() => _emailUpdates = value),
                  secondary: const Icon(Icons.email_outlined),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('SMS'),
                  subtitle: const Text('Chỉ dùng cho cảnh báo quan trọng'),
                  value: _smsUpdates,
                  onChanged: (value) => setState(() => _smsUpdates = value),
                  secondary: const Icon(Icons.sms_outlined),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Bật giờ yên lặng'),
                  subtitle: const Text('Tạm dừng thông báo trong khoảng thời gian đặt trước'),
                  value: _quietHoursEnabled,
                  onChanged: (value) => setState(() => _quietHoursEnabled = value),
                  secondary: const Icon(Icons.nightlight_round),
                ),
                if (_quietHoursEnabled) ...[
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.access_time),
                    title: Text('Bắt đầu: ${_quietStart.format(context)}'),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: _quietStart,
                      );
                      if (picked != null) {
                        setState(() => _quietStart = picked);
                      }
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.access_time_filled),
                    title: Text('Kết thúc: ${_quietEnd.format(context)}'),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: _quietEnd,
                      );
                      if (picked != null) {
                        setState(() => _quietEnd = picked);
                      }
                    },
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _saveSettings,
            icon: const Icon(Icons.save_outlined),
            label: const Text('Lưu cài đặt'),
            style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
          ),
        ],
      ),
    );
  }

  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã lưu cài đặt thông báo (cục bộ)')),
    );
  }
}
