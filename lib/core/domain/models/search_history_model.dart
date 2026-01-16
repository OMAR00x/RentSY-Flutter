class SearchHistoryModel {
  final int id;
  final String query;
  final DateTime createdAt;

  SearchHistoryModel({
    required this.id,
    required this.query,
    required this.createdAt,
  });

  factory SearchHistoryModel.fromJson(Map<String, dynamic> json) {
    return SearchHistoryModel(
      id: json['id'],
      query: json['query'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
