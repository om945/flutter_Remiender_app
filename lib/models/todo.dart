class Todos {
  final String id;
  final String userId;
  final String content;
  final DateTime? createdAt;
  final DateTime? reminderDate;
  final bool? isCompleted;

  Todos({
    required this.id,
    required this.userId,
    required this.content,
    this.createdAt,
    this.reminderDate,
    this.isCompleted = false,
  });

  factory Todos.fromJson(Map<String, dynamic> json) {
    return Todos(
      id: json['_id'],
      userId: json['userId'],
      content: json['content'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      reminderDate: json['reminderDate'] != null
          ? _parseReminderDate(json['reminderDate'])
          : null,
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  static DateTime _parseReminderDate(String dateString) {
    try {
      // Parse the date string
      final parsed = DateTime.parse(dateString);
      // If the parsed date is in UTC (ends with Z), treat it as local time
      // by creating a new DateTime with the same values but in local timezone
      if (dateString.endsWith('Z') ||
          dateString.contains('+') ||
          dateString.contains('-')) {
        // This is a UTC or timezone-aware date, treat it as local time
        return DateTime(
          parsed.year,
          parsed.month,
          parsed.day,
          parsed.hour,
          parsed.minute,
          parsed.second,
        );
      } else {
        // This is already a local date
        return parsed;
      }
    } catch (e) {
      // If parsing fails, return current time
      return DateTime.now();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'content': content,
      'createdAt': createdAt?.toIso8601String(),
      'reminderDate': reminderDate?.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  Todos copyWith({
    String? id,
    String? userId,
    String? content,
    DateTime? createdAt,
    DateTime? reminderDate,
    bool? isCompleted,
  }) {
    return Todos(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      reminderDate: reminderDate ?? this.reminderDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
