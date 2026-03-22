import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/building_constants.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/building_form_data.dart';
import '../providers/owner_provider.dart';
import '../../../../routes/app_router.dart';

class BuildingSetupPage extends StatefulWidget {
  const BuildingSetupPage({super.key});

  @override
  State<BuildingSetupPage> createState() => _BuildingSetupPageState();
}

class _BuildingSetupPageState extends State<BuildingSetupPage>
    with SingleTickerProviderStateMixin {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  late BuildingFormData _formData;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _formData = BuildingFormData();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            'Thiết lập tòa nhà',
            style: TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: AppColors.error),
              onPressed: _handleLogout,
              tooltip: 'Đăng xuất',
            ),
          ],
        ),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              _buildProgressIndicator(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildStepCard(),
                        const SizedBox(height: 24),
                        _buildNavigationButtons(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: List.generate(3, (index) {
              final isActive = index <= _currentStep;
              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 4,
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.primary : AppColors.border,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    if (index < 2) const SizedBox(width: 8),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bước ${_currentStep + 1}/3',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              Text(
                _getStepTitle(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return 'Thông tin cơ bản';
      case 1:
        return 'Địa chỉ';
      case 2:
        return 'Tiện ích & Liên hệ';
      default:
        return '';
    }
  }

  Widget _buildStepCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: _buildStepContent(),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStep1BasicInfo();
      case 1:
        return _buildStep2Address();
      case 2:
        return _buildStep3UtilitiesContact();
      default:
        return const SizedBox();
    }
  }

  Widget _buildStep1BasicInfo() {
    return Column(
      key: const ValueKey(0),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          icon: Icons.business,
          title: 'Thông tin cơ bản',
          subtitle: 'Nhập thông tin cơ bản về tòa nhà của bạn',
        ),
        const SizedBox(height: 24),

        // Building name
        _buildTextField(
          label: 'Tên tòa nhà',
          hint: 'VD: Chung cư Sunrise',
          icon: Icons.apartment,
          initialValue: _formData.buildingName,
          validator: (value) {
            if (value == null || value.length < 3) {
              return 'Tên tòa nhà phải có ít nhất 3 ký tự';
            }
            return null;
          },
          onChanged: (value) {
            _formData = _formData.copyWith(buildingName: value);
          },
        ),
        const SizedBox(height: 20),

        // Building type
        _buildLabel('Loại hình tòa nhà'),
        const SizedBox(height: 12),
        ...BuildingConstants.buildingTypeLabels.entries.map((entry) {
          return _buildRadioTile(
            title: entry.value,
            value: entry.key,
            groupValue: _formData.buildingType,
            icon: _getBuildingTypeIcon(entry.key),
            onChanged: (value) {
              setState(() {
                _formData = _formData.copyWith(buildingType: value);
              });
            },
          );
        }),
        const SizedBox(height: 20),

        // Total floors
        _buildLabel('Số tầng'),
        const SizedBox(height: 12),
        _buildFloorPicker(),
      ],
    );
  }

  IconData _getBuildingTypeIcon(String type) {
    switch (type) {
      case 'apartment':
        return Icons.apartment;
      case 'house':
        return Icons.house;
      case 'dormitory':
        return Icons.domain;
      default:
        return Icons.business;
    }
  }

  Widget _buildFloorPicker() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Tổng số tầng',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textDark,
            ),
          ),
          Row(
            children: [
              _buildFloorButton(
                icon: Icons.remove,
                onPressed: _formData.totalFloors > 1
                    ? () {
                        setState(() {
                          _formData = _formData.copyWith(
                            totalFloors: _formData.totalFloors - 1,
                          );
                        });
                      }
                    : null,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_formData.totalFloors}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              _buildFloorButton(
                icon: Icons.add,
                onPressed: _formData.totalFloors < 50
                    ? () {
                        setState(() {
                          _formData = _formData.copyWith(
                            totalFloors: _formData.totalFloors + 1,
                          );
                        });
                      }
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFloorButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: onPressed != null ? AppColors.primary : AppColors.border,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
        iconSize: 20,
      ),
    );
  }

  Widget _buildStep2Address() {
    return Column(
      key: const ValueKey(1),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          icon: Icons.location_on,
          title: 'Địa chỉ',
          subtitle: 'Nhập địa chỉ chi tiết của tòa nhà',
        ),
        const SizedBox(height: 24),

        _buildTextField(
          label: 'Số nhà, tên đường',
          hint: 'VD: 123 Lê Văn Việt',
          icon: Icons.signpost,
          initialValue: _formData.street,
          validator: (value) =>
              value?.isEmpty == true ? 'Vui lòng nhập địa chỉ' : null,
          onChanged: (value) {
            _formData = _formData.copyWith(street: value);
          },
        ),
        const SizedBox(height: 16),

        _buildTextField(
          label: 'Phường/Xã',
          hint: 'VD: Tăng Nhơn Phú A',
          icon: Icons.location_city,
          initialValue: _formData.ward,
          validator: (value) =>
              value?.isEmpty == true ? 'Vui lòng nhập phường/xã' : null,
          onChanged: (value) {
            _formData = _formData.copyWith(ward: value);
          },
        ),
        const SizedBox(height: 16),

        _buildTextField(
          label: 'Quận/Huyện',
          hint: 'VD: Quận 9',
          icon: Icons.map,
          initialValue: _formData.district,
          validator: (value) =>
              value?.isEmpty == true ? 'Vui lòng nhập quận/huyện' : null,
          onChanged: (value) {
            _formData = _formData.copyWith(district: value);
          },
        ),
        const SizedBox(height: 16),

        _buildDropdown(
          label: 'Thành phố',
          value: _formData.city,
          icon: Icons.location_city,
          items: BuildingConstants.provinces,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _formData = _formData.copyWith(city: value, province: value);
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildStep3UtilitiesContact() {
    return Column(
      key: const ValueKey(2),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          icon: Icons.settings,
          title: 'Tiện ích & Liên hệ',
          subtitle: 'Chọn tiện ích và thông tin liên hệ',
        ),
        const SizedBox(height: 24),

        // Amenities
        _buildLabel('Tiện ích chung'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: BuildingConstants.commonAmenities.map((amenity) {
            final isSelected = _formData.selectedAmenities.contains(amenity.value);
            return _buildAmenityChip(
              label: amenity.label,
              icon: amenity.icon,
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  final amenities = List<String>.from(_formData.selectedAmenities);
                  if (isSelected) {
                    amenities.remove(amenity.value);
                  } else {
                    amenities.add(amenity.value);
                  }
                  _formData = _formData.copyWith(selectedAmenities: amenities);
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 24),

        // Contact info
        _buildLabel('Thông tin liên hệ'),
        const SizedBox(height: 12),
        _buildTextField(
          label: 'Số điện thoại',
          hint: '0901234567',
          icon: Icons.phone,
          initialValue: _formData.phone,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.length < 10) {
              return 'Số điện thoại không hợp lệ';
            }
            return null;
          },
          onChanged: (value) {
            _formData = _formData.copyWith(phone: value);
          },
        ),
        const SizedBox(height: 16),

        _buildTextField(
          label: 'Email (tùy chọn)',
          hint: 'contact@example.com',
          icon: Icons.email,
          initialValue: _formData.email ?? '',
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            _formData = _formData.copyWith(email: value.isEmpty ? null : value);
          },
        ),
        const SizedBox(height: 24),

        // Utilities
        _buildLabel('Đơn giá tiện ích'),
        const SizedBox(height: 12),
        _buildUtilityPriceField(
          label: '⚡ Điện',
          unit: 'đ/kWh',
          value: _formData.electricityPrice,
          onChanged: (value) {
            setState(() {
              _formData = _formData.copyWith(
                electricityPrice: double.tryParse(value) ?? 0,
              );
            });
          },
        ),
        const SizedBox(height: 12),
        _buildUtilityPriceField(
          label: '💧 Nước',
          unit: 'đ/m³',
          value: _formData.waterPrice,
          onChanged: (value) {
            setState(() {
              _formData = _formData.copyWith(
                waterPrice: double.tryParse(value) ?? 0,
              );
            });
          },
        ),
        const SizedBox(height: 12),
        _buildUtilityPriceField(
          label: '📶 Internet',
          unit: 'đ/tháng',
          value: _formData.internetPrice,
          onChanged: (value) {
            setState(() {
              _formData = _formData.copyWith(
                internetPrice: double.tryParse(value) ?? 0,
              );
            });
          },
        ),
      ],
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          height: 3,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    String? initialValue,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primary),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: validator,
      onChanged: onChanged,
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required IconData icon,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      style: const TextStyle(fontSize: 16, color: AppColors.textDark),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildRadioTile({
    required String title,
    required String value,
    required String groupValue,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    final isSelected = value == groupValue;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.1)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: isSelected ? 2 : 1,
        ),
      ),
      // Temporary suppression until RadioGroup refactor lands.
      // ignore: deprecated_member_use
      child: RadioListTile<String>(
        title: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : AppColors.textMedium),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.primary : AppColors.textDark,
              ),
            ),
          ],
        ),
        value: value,
        groupValue: groupValue,
        activeColor: AppColors.primary,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildAmenityChip({
    required String label,
    required String icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.primaryGradient : null,
          color: isSelected ? null : AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.border,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? Colors.white : AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUtilityPriceField({
    required String label,
    required String unit,
    required double value,
    required Function(String) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: TextFormField(
              initialValue: value.toStringAsFixed(0),
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                suffixText: unit,
                suffixStyle: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textMedium,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        if (_currentStep > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  _currentStep--;
                  _animationController.reset();
                  _animationController.forward();
                });
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Quay lại',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (_currentStep > 0) const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _handleContinue,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _currentStep == 2 ? 'Hoàn tất' : 'Tiếp tục',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  _currentStep == 2 ? Icons.check : Icons.arrow_forward,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _handleContinue() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
        _animationController.reset();
        _animationController.forward();
      });
    } else {
      _handleSubmit();
    }
  }

  Future<void> _handleSubmit() async {
    final ownerProvider = Provider.of<OwnerProvider>(context, listen: false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Đang tạo tòa nhà...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final success = await ownerProvider.createBuilding(_formData.toJson());

    if (mounted) Navigator.pop(context);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tạo tòa nhà thành công!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pushReplacementNamed(context, AppRouter.ownerHome);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ownerProvider.buildingError ?? 'Đã xảy ra lỗi'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Xác nhận đăng xuất'),
        content: const Text('Bạn có chắc muốn đăng xuất? Thông tin chưa lưu sẽ bị mất.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.logout();
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRouter.login);
      }
    }
  }
}
