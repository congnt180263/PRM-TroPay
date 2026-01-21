import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';

class RoleCard extends StatelessWidget {
  final UserRole role;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData icon;
  final List<String> features;

  const RoleCard({
    super.key,
    required this.role,
    required this.isSelected,
    required this.onTap,
    required this.icon,
    required this.features,
  });

  Color get _roleColor {
    return role == UserRole.owner 
        ? const Color(0xFF007AFF) 
        : const Color(0xFF34C759);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0F8FF) : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFF007AFF) : const Color(0xFFE5E7EB),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: isSelected ? _roleColor : const Color(0xFFF2F2F7),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Icon(
                icon,
                size: 32,
                color: isSelected ? Colors.white : const Color(0xFF8E8E93),
              ),
            ),
            const SizedBox(height: 16),
            
            // Title
            Text(
              role.displayName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isSelected ? const Color(0xFF007AFF) : const Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            
            // Description
            Text(
              _getDescription(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            
            // Features
            Column(
              children: features.map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check,
                      size: 16,
                      color: Color(0xFF34C759),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feature,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF374151),
                        ),
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  String _getDescription() {
    return role == UserRole.owner
        ? 'Quản lý phòng trọ, hợp đồng thuê và thu tiền từ người thuê'
        : 'Thuê phòng trọ, thanh toán tiền thuê và quản lý hợp đồng';
  }
}
