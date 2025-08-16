// import 'dart:convert';

class Notes {
  final String id;
  final String userId;
  final String headline;
  final String content;

  Notes({
    required this.id,
    required this.userId,
    required this.headline,
    required this.content,
  });

  factory Notes.fromJson(Map<String, dynamic> json) {
    return Notes(
      id: json['id'],
      userId: json['userId'],
      headline: json['headline'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'headline': headline,
      'content': content,
    };
  }
}
