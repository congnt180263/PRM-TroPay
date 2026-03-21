import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/data/models/auth_models.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class TenantEditProfilePage extends StatefulWidget {
  const TenantEditProfilePage({super.key});

  @override
  State<TenantEditProfilePage> createState() => _TenantEditProfilePageState();
}

class _TenantEditProfilePageState extends State<TenantEditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _dobController;
  late final TextEditingController _identityController;
  late final TextEditingController _addressController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser;
    _fullNameController = TextEditingController(text: user?.fullName ?? '');
    _phoneController = TextEditingController(text: user?.phoneNumber ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _dobController = TextEditingController(text: user?.dateOfBirth ?? '');
    _identityController = TextEditingController(text: user?.identityCard ?? '');
    _addressController = TextEditingController(text: user?.address ?? '');
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _identityController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa hồ sơ'),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.currentUser;
          if (user == null) {
            return const Center(child: Text('Không tìm thấy thông tin người dùng'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildTextField(
                            controller: _fullNameController,
                            label: 'Họ và tên',
                            icon: Icons.person_outline,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Vui lòng nhập họ tên';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildTextField(
                            controller: _phoneController,
                            label: 'Số điện thoại',
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Vui lòng nhập số điện thoại';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildTextField(
                            controller: _emailController,
                            label: 'Email',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 12),
                          _buildTextField(
                            controller: _dobController,
                            label: 'Ngày sinh',
                            icon: Icons.cake_outlined,
                            hintText: 'dd/mm/yyyy',
                          ),
                          const SizedBox(height: 12),
                          _buildTextField(
                            controller: _identityController,
                            label: 'CCCD',
                            icon: Icons.badge_outlined,
                          ),
                          const SizedBox(height: 12),
                          _buildTextField(
                            controller: _addressController,
                            label: 'Địa chỉ',
                            icon: Icons.location_on_outlined,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: const Text('Thông tin sẽ được lưu cục bộ'),
                      subtitle: const Text('Đồng bộ với máy chủ sẽ được thêm sau khi API sẵn sàng.'),
                      trailing: IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () async {
                          await authProvider.refreshProfile();
                          final refreshed = authProvider.currentUser;
                          if (refreshed != null) {
                            _fullNameController.text = refreshed.fullName;
                            _phoneController.text = refreshed.phoneNumber ?? '';
                            _emailController.text = refreshed.email;
                            _dobController.text = refreshed.dateOfBirth ?? '';
                            _identityController.text = refreshed.identityCard ?? '';
                            _addressController.text = refreshed.address ?? '';
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      icon: _isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.save_outlined),
                      label: Text(_isSaving ? 'Đang lưu...' : 'Lưu thay đổi'),
                      onPressed: _isSaving ? null : () => _save(user),
                      style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? hintText,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }

  Future<void> _save(UserData user) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 400));

    final updatedUser = UserData(
      id: user.id,
      email: _emailController.text.trim(),
      fullName: _fullNameController.text.trim(),
      role: user.role,
      phoneNumber: _phoneController.text.trim(),
      dateOfBirth: _dobController.text.trim().isEmpty ? null : _dobController.text.trim(),
      identityCard: _identityController.text.trim().isEmpty ? null : _identityController.text.trim(),
      address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
    );

    if (!mounted) return;
    context.read<AuthProvider>().updateLocalProfile(updatedUser);

    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã lưu thay đổi hồ sơ (cục bộ)')),
      );
      Navigator.pop(context, updatedUser);
    }
  }
}
