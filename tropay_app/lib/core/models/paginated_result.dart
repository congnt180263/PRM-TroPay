class Pagination {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  const Pagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic>? json) {
    return Pagination(
      page: json?['page'] ?? 1,
      limit: json?['limit'] ?? 0,
      total: json?['total'] ?? 0,
      totalPages: json?['totalPages'] ?? 0,
    );
  }
}

class PaginatedResult<T> {
  final List<T> items;
  final Pagination pagination;

  const PaginatedResult({
    required this.items,
    required this.pagination,
  });

  factory PaginatedResult.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    final rawItems = json['data'] as List<dynamic>? ?? <dynamic>[];
    final items = rawItems.map((item) => fromJsonT(item)).toList();
    final pagination = Pagination.fromJson(json['pagination'] as Map<String, dynamic>?);

    return PaginatedResult<T>(
      items: items,
      pagination: pagination,
    );
  }
}
