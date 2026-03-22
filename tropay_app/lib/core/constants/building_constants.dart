/// Building Constants
///
/// This file contains all constant values related to buildings,
/// including types, amenities, validation rules, and utility prices.

/// Represents an amenity option for buildings
class AmenityOption {
  final String value;
  final String label;
  final String icon;

  const AmenityOption({
    required this.value,
    required this.label,
    required this.icon,
  });
}

/// Building-related constants and configuration
class BuildingConstants {
  BuildingConstants._();

  // ==================== Building Types ====================

  static const String typeApartment = 'apartment';
  static const String typeHouse = 'house';
  static const String typeDormitory = 'dormitory';

  static const Map<String, String> buildingTypeLabels = {
    typeApartment: 'Chung cư',
    typeHouse: 'Nhà trọ',
    typeDormitory: 'Ký túc xá',
  };

  // ==================== Common Amenities ====================

  static const List<AmenityOption> commonAmenities = [
    AmenityOption(
      value: 'parking',
      label: 'Bãi đỗ xe',
      icon: '🅿️',
    ),
    AmenityOption(
      value: 'elevator',
      label: 'Thang máy',
      icon: '🛗',
    ),
    AmenityOption(
      value: 'wifi',
      label: 'WiFi',
      icon: '📶',
    ),
    AmenityOption(
      value: 'security',
      label: 'Bảo vệ 24/7',
      icon: '🔒',
    ),
    AmenityOption(
      value: 'laundry',
      label: 'Giặt là',
      icon: '👕',
    ),
    AmenityOption(
      value: 'cctv',
      label: 'Camera an ninh',
      icon: '📹',
    ),
    AmenityOption(
      value: 'generator',
      label: 'Máy phát điện',
      icon: '⚡',
    ),
    AmenityOption(
      value: 'water_tank',
      label: 'Bồn nước dự trữ',
      icon: '💧',
    ),
  ];

  // Helper method to get amenity label by value
  static String getAmenityLabel(String value) {
    final amenity = commonAmenities.firstWhere(
      (a) => a.value == value,
      orElse: () => const AmenityOption(value: '', label: '', icon: ''),
    );
    return amenity.label;
  }

  // Helper method to get amenity icon by value
  static String getAmenityIcon(String value) {
    final amenity = commonAmenities.firstWhere(
      (a) => a.value == value,
      orElse: () => const AmenityOption(value: '', label: '', icon: '🏢'),
    );
    return amenity.icon;
  }

  // ==================== Default Utility Prices (VND) ====================

  /// Default electricity price per kWh in VND
  static const double defaultElectricityPrice = 3500;

  /// Default water price per m³ in VND
  static const double defaultWaterPrice = 15000;

  /// Default internet price per month in VND
  static const double defaultInternetPrice = 100000;

  // ==================== Validation Constraints ====================

  static const int minBuildingNameLength = 3;
  static const int maxBuildingNameLength = 100;
  static const int minFloors = 1;
  static const int maxFloors = 50;
  static const int minPhoneLength = 10;

  // ==================== Vietnamese Provinces ====================

  static const List<String> provinces = [
    'Hồ Chí Minh',
    'Hà Nội',
    'Đà Nẵng',
    'Cần Thơ',
    'Hải Phòng',
    'Biên Hòa',
    'Nha Trang',
    'Huế',
    'Vũng Tàu',
    'Quy Nhơn',
    'Đà Lạt',
    'Buôn Ma Thuột',
    'Phan Thiết',
    'Thái Nguyên',
    'Nam Định',
    'Vinh',
    'Pleiku',
    'Long Xuyên',
    'Mỹ Tho',
    'Bến Tre',
    'Rạch Giá',
    'Cà Mau',
    'Sóc Trăng',
    'Vĩnh Long',
    'Trà Vinh',
    'Hậu Giang',
    'Kiên Giang',
    'An Giang',
    'Tiền Giang',
    'Đồng Tháp',
    'Bình Dương',
    'Bình Phước',
    'Tây Ninh',
    'Long An',
    'Bà Rịa - Vũng Tàu',
    'Khánh Hòa',
    'Ninh Thuận',
    'Bình Thuận',
    'Lâm Đồng',
    'Đắk Lắk',
    'Đắk Nông',
    'Gia Lai',
    'Kon Tum',
    'Quảng Nam',
    'Quảng Ngãi',
    'Bình Định',
    'Phú Yên',
    'Thừa Thiên - Huế',
    'Quảng Trị',
    'Quảng Bình',
    'Hà Tĩnh',
    'Nghệ An',
    'Thanh Hóa',
    'Ninh Bình',
    'Hà Nam',
    'Thái Bình',
    'Hưng Yên',
    'Hà Giang',
    'Cao Bằng',
    'Bắc Kạn',
    'Tuyên Quang',
    'Lào Cai',
    'Yên Bái',
    'Sơn La',
    'Điện Biên',
    'Lai Châu',
    'Phú Thọ',
    'Vĩnh Phúc',
    'Bắc Giang',
    'Bắc Ninh',
    'Hải Dương',
    'Quảng Ninh',
    'Lạng Sơn',
  ];

  // ==================== Popular Districts in HCMC ====================

  static const List<String> hcmcDistricts = [
    'Quận 1',
    'Quận 2',
    'Quận 3',
    'Quận 4',
    'Quận 5',
    'Quận 6',
    'Quận 7',
    'Quận 8',
    'Quận 9',
    'Quận 10',
    'Quận 11',
    'Quận 12',
    'Bình Thạnh',
    'Gò Vấp',
    'Phú Nhuận',
    'Tân Bình',
    'Tân Phú',
    'Bình Tân',
    'Thủ Đức',
    'Củ Chi',
    'Hóc Môn',
    'Bình Chánh',
    'Nhà Bè',
    'Cần Giờ',
  ];

  // ==================== Popular Districts in Hanoi ====================

  static const List<String> hanoiDistricts = [
    'Ba Đình',
    'Hoàn Kiếm',
    'Tây Hồ',
    'Long Biên',
    'Cầu Giấy',
    'Đống Đa',
    'Hai Bà Trưng',
    'Hoàng Mai',
    'Thanh Xuân',
    'Nam Từ Liêm',
    'Bắc Từ Liêm',
    'Hà Đông',
    'Sơn Tây',
    'Ba Vì',
    'Chương Mỹ',
    'Đan Phượng',
    'Hoài Đức',
    'Mê Linh',
    'Mỹ Đức',
    'Phú Xuyên',
    'Phúc Thọ',
    'Quốc Oai',
    'Sóc Sơn',
    'Thạch Thất',
    'Thanh Oai',
    'Thanh Trì',
    'Thường Tín',
    'Ứng Hòa',
  ];

  // Helper to get districts by city
  static List<String> getDistrictsByCity(String city) {
    if (city.contains('Hồ Chí Minh') || city.toLowerCase().contains('ho chi minh')) {
      return hcmcDistricts;
    } else if (city.contains('Hà Nội') || city.toLowerCase().contains('ha noi')) {
      return hanoiDistricts;
    }
    return [];
  }
}
