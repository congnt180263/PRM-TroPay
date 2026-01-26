class ServiceModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String unit; // 'month', 'kwh', 'm3', 'kWh', 'fixed'
  final bool isActive;
  final String? iconName;

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.unit,
    this.isActive = true,
    this.iconName,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      unit: json['unit'] ?? 'month',
      isActive: json['isActive'] ?? true,
      iconName: json['iconName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'unit': unit,
      'isActive': isActive,
      'iconName': iconName,
    };
  }

  ServiceModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? unit,
    bool? isActive,
    String? iconName,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      unit: unit ?? this.unit,
      isActive: isActive ?? this.isActive,
      iconName: iconName ?? this.iconName,
    );
  }
}
