class IncidentModel {
  final String id;
  final String title;
  final String description;
  final String category; // 'electrical', 'plumbing', 'furniture', 'other'
  final String status; // 'pending', 'in_progress', 'resolved', 'rejected'
  final String priority; // 'low', 'medium', 'high', 'urgent'
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final String? imageUrl;
  final String? response;

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
    };
  }

  bool get isPending => status == 'pending';
  bool get isInProgress => status == 'in_progress';
  bool get isResolved => status == 'resolved';
  bool get isRejected => status == 'rejected';
}
