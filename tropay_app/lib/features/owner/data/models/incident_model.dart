class IncidentModel {
  final String id;
  final String title;
  final String description;
  final String category; // 'electrical', 'plumbing', 'furniture', 'appliances', 'other'
  final String status; // 'pending', 'in_progress', 'resolved', 'rejected'
  final String priority; // 'low', 'medium', 'high', 'urgent'
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final String? imageUrl;
  final String? response;
  final String? roomNumber;

  IncidentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.priority,
    required this.createdAt,
    this.resolvedAt,
    this.imageUrl,
    this.response,
    this.roomNumber,
  });

  factory IncidentModel.fromJson(Map<String, dynamic> json) {
    return IncidentModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'other',
      status: json['status'] ?? 'pending',
      priority: json['priority'] ?? 'medium',
      createdAt: DateTime.parse(json['createdAt']),
      resolvedAt: json['resolvedAt'] != null ? DateTime.parse(json['resolvedAt']) : null,
      imageUrl: json['imageUrl'],
      response: json['response'],
      roomNumber: json['roomNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'status': status,
      'priority': priority,
      'createdAt': createdAt.toIso8601String(),
      'resolvedAt': resolvedAt?.toIso8601String(),
      'imageUrl': imageUrl,
      'response': response,
      'roomNumber': roomNumber,
    };
  }

  bool get isPending => status == 'pending';
  bool get isInProgress => status == 'in_progress';
  bool get isResolved => status == 'resolved';
  bool get isRejected => status == 'rejected';

  IncidentModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? status,
    String? priority,
    DateTime? createdAt,
    DateTime? resolvedAt,
    String? imageUrl,
    String? response,
    String? roomNumber,
  }) {
    return IncidentModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      imageUrl: imageUrl ?? this.imageUrl,
      response: response ?? this.response,
      roomNumber: roomNumber ?? this.roomNumber,
    );
  }
}
