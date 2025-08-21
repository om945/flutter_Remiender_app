class Todos {
  final String id;
  final String userId;
  final String content;
  final DateTime? createdAt;

  Todos({
    required this.id,
    required this.userId,
    required this.content,
    this.createdAt,
  });

  factory Todos.fromJson(Map<String, dynamic> json) {
    return Todos(
      id: json['id'],
      userId: json['userId'],
      content: json['content'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'content': content,
      'createdAt': createdAt?.millisecondsSinceEpoch,
    };
  }
}
