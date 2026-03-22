// Building form state used for creation and editing flows.

class BuildingFormData {
  String buildingName;
  String street;
  String ward;
  String district;
  String city;
  String province;
  int totalFloors;
  String buildingType;
  List<String> selectedAmenities;
  String? description;
  String phone;
  String? email;
  String? emergencyContact;
  double electricityPrice;
  double waterPrice;
  double internetPrice;

  BuildingFormData({
    this.buildingName = '',
    this.street = '',
    this.ward = '',
    this.district = '',
    // Use the exact province label from the dropdown list to avoid initial value mismatches.
    this.city = 'Hồ Chí Minh',
    this.province = 'Hồ Chí Minh',
    this.totalFloors = 1,
    this.buildingType = 'apartment',
    this.selectedAmenities = const [],
    this.description,
    this.phone = '',
    this.email,
    this.emergencyContact,
    this.electricityPrice = 3500,
    this.waterPrice = 15000,
    this.internetPrice = 100000,
  });

  /// Converts form data to JSON format for API submission
  Map<String, dynamic> toJson() {
    return {
      'buildingName': buildingName,
      'address': {
        'street': street,
        'ward': ward,
        'district': district,
        'city': city,
        'province': province,
      },
      'totalFloors': totalFloors,
      'buildingType': buildingType,
      'commonAmenities': selectedAmenities,
      if (description != null && description!.isNotEmpty)
        'description': description,
      'contactInfo': {
        'phone': phone,
        if (email != null && email!.isNotEmpty) 'email': email,
        if (emergencyContact != null && emergencyContact!.isNotEmpty)
          'emergencyContact': emergencyContact,
      },
      'utilities': {
        'electricityPrice': electricityPrice,
        'waterPrice': waterPrice,
        'internetPrice': internetPrice,
      },
    };
  }

  /// Quick validation check
  bool get isValid {
    return buildingName.length >= 3 &&
        street.isNotEmpty &&
        ward.isNotEmpty &&
        district.isNotEmpty &&
        city.isNotEmpty &&
        province.isNotEmpty &&
        totalFloors >= 1 &&
        phone.length >= 10;
  }

  /// Detailed validation that returns list of error messages
  List<String> validate() {
    List<String> errors = [];

    if (buildingName.length < 3) {
      errors.add('Tên tòa nhà phải có ít nhất 3 ký tự');
    }
    if (street.isEmpty) errors.add('Vui lòng nhập tên đường');
    if (ward.isEmpty) errors.add('Vui lòng nhập phường/xã');
    if (district.isEmpty) errors.add('Vui lòng nhập quận/huyện');
    if (totalFloors < 1) errors.add('Số tầng phải lớn hơn 0');
    if (phone.length < 10) errors.add('Số điện thoại không hợp lệ');

    return errors;
  }

  /// Creates a copy with updated fields
  BuildingFormData copyWith({
    String? buildingName,
    String? street,
    String? ward,
    String? district,
    String? city,
    String? province,
    int? totalFloors,
    String? buildingType,
    List<String>? selectedAmenities,
    String? description,
    String? phone,
    String? email,
    String? emergencyContact,
    double? electricityPrice,
    double? waterPrice,
    double? internetPrice,
  }) {
    return BuildingFormData(
      buildingName: buildingName ?? this.buildingName,
      street: street ?? this.street,
      ward: ward ?? this.ward,
      district: district ?? this.district,
      city: city ?? this.city,
      province: province ?? this.province,
      totalFloors: totalFloors ?? this.totalFloors,
      buildingType: buildingType ?? this.buildingType,
      selectedAmenities: selectedAmenities ?? this.selectedAmenities,
      description: description ?? this.description,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      electricityPrice: electricityPrice ?? this.electricityPrice,
      waterPrice: waterPrice ?? this.waterPrice,
      internetPrice: internetPrice ?? this.internetPrice,
    );
  }
}
