import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tropay_app/features/auth/presentation/providers/auth_provider.dart';

class OwnerHomePage extends StatelessWidget {
  const OwnerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ Chủ trọ'),
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
                Icons.business,
                size: 80,
                color: Color(0xFF3B82F6),
              ),
              const SizedBox(height: 24),
              Text(
                'Xin chào, ${user?.fullName ?? "Chủ trọ"}!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Đây là trang chủ dành cho Chủ trọ',
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
                        leading: Icon(Icons.meeting_room, color: Color(0xFF3B82F6)),
                        title: Text('Quản lý phòng trọ'),
                      ),
                      ListTile(
                        leading: Icon(Icons.description, color: Color(0xFF3B82F6)),
                        title: Text('Quản lý hợp đồng'),
                      ),
                      ListTile(
                        leading: Icon(Icons.receipt, color: Color(0xFF3B82F6)),
                        title: Text('Quản lý hóa đơn'),
                      ),
                      ListTile(
                        leading: Icon(Icons.bar_chart, color: Color(0xFF3B82F6)),
                        title: Text('Báo cáo doanh thu'),
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
