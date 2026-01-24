class ServiceModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String unit; // 'month', 'kwh', 'm3', 'fixed'
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
}

class ServiceHistoryModel {
  final String id;
  final String serviceName;
  final double amount;
  final DateTime date;
  final String description;

  ServiceHistoryModel({
    required this.id,
    required this.serviceName,
    required this.amount,
    required this.date,
    required this.description,
  });

  factory ServiceHistoryModel.fromJson(Map<String, dynamic> json) {
    return ServiceHistoryModel(
      id: json['id'] ?? '',
      serviceName: json['serviceName'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      date: DateTime.parse(json['date']),
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceName': serviceName,
      'amount': amount,
      'date': date.toIso8601String(),
      'description': description,
    };
  }
}
