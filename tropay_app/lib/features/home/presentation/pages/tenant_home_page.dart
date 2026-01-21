import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tropay_app/features/auth/presentation/providers/auth_provider.dart';

class TenantHomePage extends StatelessWidget {
  const TenantHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ Người thuê'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.person,
                size: 80,
                color: Color(0xFF34C759),
              ),
              const SizedBox(height: 24),
              Text(
                'Xin chào, ${user?.fullName ?? "Người thuê"}!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Đây là trang chủ dành cho Người thuê',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6B7280),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Các tính năng sẽ có:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      ListTile(
                        leading: Icon(Icons.search, color: Color(0xFF34C759)),
                        title: Text('Tìm phòng trọ'),
                      ),
                      ListTile(
                        leading: Icon(Icons.payment, color: Color(0xFF34C759)),
                        title: Text('Thanh toán tiền thuê'),
                      ),
                      ListTile(
                        leading: Icon(Icons.receipt_long, color: Color(0xFF34C759)),
                        title: Text('Xem hóa đơn'),
                      ),
                      ListTile(
                        leading: Icon(Icons.report_problem, color: Color(0xFF34C759)),
                        title: Text('Báo cáo sự cố'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
