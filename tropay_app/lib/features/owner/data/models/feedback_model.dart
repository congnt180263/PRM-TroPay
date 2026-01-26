class FeedbackModel {
  final String id;
  final String tenantId;
  final String tenantName;
  final String roomNumber;
  final String subject;
  final String content;
  final int rating; // 1-5
  final String category; // 'service', 'maintenance', 'management', 'other'
  final String status; // 'pending', 'reviewed', 'resolved'
  final DateTime createdAt;
  final String? response;
  final DateTime? respondedAt;

  FeedbackModel({
    required this.id,
    required this.tenantId,
    required this.tenantName,
    required this.roomNumber,
    required this.subject,
    required this.content,
    required this.rating,
    required this.category,
    required this.status,
    required this.createdAt,
    this.response,
    this.respondedAt,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'] ?? '',
      tenantId: json['tenantId'] ?? '',
      tenantName: json['tenantName'] ?? '',
      roomNumber: json['roomNumber'] ?? '',
      subject: json['subject'] ?? '',
      content: json['content'] ?? '',
      rating: json['rating'] ?? 5,
      category: json['category'] ?? 'other',
      status: json['status'] ?? 'pending',
      createdAt: DateTime.parse(json['createdAt']),
      response: json['response'],
      respondedAt: json['respondedAt'] != null
          ? DateTime.parse(json['respondedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenantId': tenantId,
      'tenantName': tenantName,
      'roomNumber': roomNumber,
      'subject': subject,
      'content': content,
      'rating': rating,
      'category': category,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'response': response,
      'respondedAt': respondedAt?.toIso8601String(),
    };
  }

  bool get isPending => status == 'pending';
  bool get isReviewed => status == 'reviewed';
  bool get isResolved => status == 'resolved';
}
