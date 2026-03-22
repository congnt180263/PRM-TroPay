import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/building_constants.dart';
import '../../data/models/building_form_data.dart';
import '../providers/owner_provider.dart';

class BuildingEditPage extends StatefulWidget {
  const BuildingEditPage({super.key});

  @override
  State<BuildingEditPage> createState() => _BuildingEditPageState();
}

class _BuildingEditPageState extends State<BuildingEditPage> {
  final _formKey = GlobalKey<FormState>();
  late BuildingFormData _formData;
  bool _isLoading = true;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _loadBuildingData();
  }

  void _loadBuildingData() {
    final provider = Provider.of<OwnerProvider>(context, listen: false);
    final building = provider.building;

    if (building != null) {
      _formData = BuildingFormData(
        buildingName: building.buildingName,
        street: building.address.street,
        ward: building.address.ward,
        district: building.address.district,
        city: building.address.city,
        province: building.address.province,
        totalFloors: building.totalFloors,
        buildingType: building.buildingType,
        selectedAmenities: building.commonAmenities,
        description: building.description,
        phone: building.contactInfo.phone,
        email: building.contactInfo.email,
        emergencyContact: building.contactInfo.emergencyContact,
        electricityPrice: building.utilities.electricityPrice,
        waterPrice: building.utilities.waterPrice,
        internetPrice: building.utilities.internetPrice,
      );
    } else {
      _formData = BuildingFormData();
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return PopScope(
      canPop: !_hasChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _showDiscardDialog();
        if (!mounted) return;
        if (shouldPop == true) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
            onPressed: () async {
              if (_hasChanges) {
                final shouldPop = await _showDiscardDialog();
                if (!mounted) return;
                if (shouldPop == true) {
                  Navigator.of(context).pop();
                }
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          title: const Text(
            'Chỉnh sửa tòa nhà',
            style: TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton.icon(
              onPressed: _hasChanges ? _handleSave : null,
              icon: const Icon(Icons.save),
              label: const Text('Lưu'),
              style: TextButton.styleFrom(
                foregroundColor: _hasChanges ? AppColors.primary : AppColors.textLight,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Form(
          key: _formKey,
          onChanged: () {
            if (!_hasChanges) {
              setState(() {
                _hasChanges = true;
              });
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection(
                  icon: Icons.business,
                  title: 'Thông tin cơ bản',
                  children: [
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
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 16),
                    _buildFloorPicker(),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSection(
                  icon: Icons.location_on,
                  title: 'Địa chỉ',
                  children: [
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
                ),
                const SizedBox(height: 24),
                _buildSection(
                  icon: Icons.settings,
                  title: 'Tiện ích & Liên hệ',
                  children: [
                    _buildLabel('Tiện ích chung'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: BuildingConstants.commonAmenities.map((amenity) {
                        final isSelected =
                            _formData.selectedAmenities.contains(amenity.value);
                        return _buildAmenityChip(
                          label: amenity.label,
                          icon: amenity.icon,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              final amenities =
                                  List<String>.from(_formData.selectedAmenities);
                              if (isSelected) {
                                amenities.remove(amenity.value);
                              } else {
                                amenities.add(amenity.value);
                              }
                              _formData =
                                  _formData.copyWith(selectedAmenities: amenities);
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
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
                    const SizedBox(height: 20),
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
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _hasChanges
            ? Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: ElevatedButton(
                    onPressed: _handleSave,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.save),
                        SizedBox(width: 8),
                        Text(
                          'Lưu thay đổi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : null,
      ),
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

  Widget _buildSection({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 15,
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
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
      style: const TextStyle(fontSize: 15, color: AppColors.textDark),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isSelected
          ? AppColors.primary.withValues(alpha: 0.08)
          : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: isSelected ? 2 : 1,
        ),
      ),
      // The RadioListTile API marks groupValue/onChanged as deprecated in favor of RadioGroup.
      // Kept here for now; refactor to RadioGroup when available in widgets tree.
      // ignore: deprecated_member_use
      child: RadioListTile<String>(
        title: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : AppColors.textMedium, size: 20),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
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
              fontSize: 15,
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
                margin: const EdgeInsets.symmetric(horizontal: 14),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_formData.totalFloors}',
                  style: const TextStyle(
                    fontSize: 18,
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
        iconSize: 18,
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
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.primaryGradient : null,
          color: isSelected ? null : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.border,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
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
      padding: const EdgeInsets.all(14),
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
                fontSize: 14,
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
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                suffixText: unit,
                suffixStyle: const TextStyle(
                  fontSize: 12,
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
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showDiscardDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hủy thay đổi?'),
        content: const Text('Các thay đổi chưa lưu sẽ bị mất. Bạn có chắc muốn tiếp tục?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Ở lại'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hủy bỏ'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Xác nhận'),
        content: const Text('Bạn có chắc muốn lưu các thay đổi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    if (!mounted) return;

    final provider = Provider.of<OwnerProvider>(context, listen: false);

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
                'Đang cập nhật...',
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

    final success = await provider.updateBuilding(_formData.toJson());

    if (mounted) Navigator.pop(context);

    if (success) {
      if (mounted) {
        setState(() {
          _hasChanges = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật thành công'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.buildingError ?? 'Cập nhật thất bại'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
