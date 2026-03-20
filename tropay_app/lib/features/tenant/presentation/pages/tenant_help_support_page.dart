import 'package:flutter/material.dart';

class TenantHelpSupportPage extends StatelessWidget {
  const TenantHelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      (
        'Làm sao để xem hóa đơn?',
        'Vào mục Hóa đơn ở thanh điều hướng, chọn hóa đơn cần xem hoặc tải PDF.',
      ),
      (
        'Cách báo sự cố?',
        'Mở mục Sự cố, nhấn "Báo sự cố" và điền mô tả chi tiết để quản lý xử lý.',
      ),
      (
        'Tôi muốn đổi phòng hoặc gia hạn hợp đồng',
        'Liên hệ chủ trọ qua hotline hoặc tạo yêu cầu trong mục Hợp đồng.',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trợ giúp & Hỗ trợ'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.chat_bubble_outline),
                  title: const Text('Trò chuyện với CSKH'),
                  subtitle: const Text('Nhận phản hồi trong vài phút (giờ hành chính)'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showSupportSheet(context, 'Trò chuyện'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: const Text('Gửi email hỗ trợ'),
                  subtitle: const Text('support@tropay.app'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showSupportSheet(context, 'Email'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.call_outlined),
                  title: const Text('Hotline khẩn cấp'),
                  subtitle: const Text('0123 456 789 (24/7)'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showSupportSheet(context, 'Gọi điện'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.help_outline),
                  title: Text('Câu hỏi thường gặp'),
                  subtitle: Text('Một số hướng dẫn nhanh cho người thuê'),
                ),
                ...faqs.map(
                  (item) => ExpansionTile(
                    title: Text(item.$1),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Text(item.$2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.article_outlined),
              title: const Text('Điều khoản & Chính sách'),
              subtitle: const Text('Xem điều khoản sử dụng và chính sách bảo mật'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showPolicyDialog(context),
            ),
          ),
        ],
      ),
    );
  }

  void _showSupportSheet(BuildContext context, String channel) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text('Gửi yêu cầu qua $channel', style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Mô tả vấn đề',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Đã gửi yêu cầu qua $channel')),
                  );
                },
                child: const Text('Gửi yêu cầu'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Điều khoản & Chính sách'),
        content: const Text(
          'Thông tin sử dụng và bảo vệ dữ liệu cá nhân sẽ được cập nhật sau.\n'
          '- Không chia sẻ thông tin đăng nhập.\n'
          '- Báo cáo sự cố kịp thời để được hỗ trợ.\n'
          '- Thanh toán đúng hạn để tránh phát sinh phí.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }
}
