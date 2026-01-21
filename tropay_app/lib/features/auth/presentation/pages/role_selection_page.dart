import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import '../widgets/primary_button.dart';
import '../widgets/role_card.dart';

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  UserRole? _selectedRole;

  void _handleRoleSelect(UserRole role) {
    setState(() {
      _selectedRole = role;
    });
  }

  void _handleContinue() {
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn loại tài khoản'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.pushNamed(
      context,
      '/register',
      arguments: _selectedRole,
    );
  }

  void _handleLogin() {
    Navigator.pushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
          child: Column(
            children: [
              // Header
              Column(
                children: [
                  // Logo
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.home,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Title
                  const Text(
                    'Chọn loại tài khoản',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  
                  // Subtitle
                  const Text(
                    'Bạn muốn sử dụng TroPay với vai trò gì?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6B7280),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Role Cards
              Column(
                children: [
                  // Owner Role
                  RoleCard(
                    role: UserRole.owner,
                    isSelected: _selectedRole == UserRole.owner,
                    onTap: () => _handleRoleSelect(UserRole.owner),
                    icon: Icons.business,
                    features: const [
                      'Quản lý phòng trọ',
                      'Tạo hợp đồng thuê',
                      'Theo dõi thanh toán',
                      'Báo cáo doanh thu',
                    ],
                  ),
                  
                  // Tenant Role
                  RoleCard(
                    role: UserRole.tenant,
                    isSelected: _selectedRole == UserRole.tenant,
                    onTap: () => _handleRoleSelect(UserRole.tenant),
                    icon: Icons.person,
                    features: const [
                      'Tìm phòng trọ',
                      'Thanh toán tiền thuê',
                      'Xem hóa đơn',
                      'Báo cáo sự cố',
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Continue Button
              PrimaryButton(
                text: 'Tiếp tục',
                onPressed: _handleContinue,
                isDisabled: _selectedRole == null,
                icon: Icons.arrow_forward,
              ),
              const SizedBox(height: 24),

              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Đã có tài khoản? ',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  TextButton(
                    onPressed: _handleLogin,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Đăng nhập ngay',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF3B82F6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
