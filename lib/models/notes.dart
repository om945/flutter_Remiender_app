// import 'dart:convert';

class Notes {
  final String id;
  final String userId;
  final String headline;
  final String content;
  final DateTime? uploadTime;

  Notes({
    required this.id,
    required this.userId,
    required this.headline,
    required this.content,
    this.uploadTime,
  });

  factory Notes.fromJson(Map<String, dynamic> json) {
    return Notes(
      id: json['_id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      headline: json['headline']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      uploadTime: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : json['uploadedAt'] != null
          ? DateTime.tryParse(json['uploadedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'headline': headline,
      'content': content,
      'uploadTime': uploadTime?.toIso8601String(),
    };
  }
}
