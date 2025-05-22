class Event {
  final int? id;
  final String title;
  final String description;
  final String dateTime;  // Stores ISO8601 string
  final int userId;

  Event({
    this.id,
    required this.title,
    required this.dateTime,
    this.description = '',
    required this.userId,
  });

  // Convert to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'dateTime': dateTime,  // Already in ISO8601 format
      'description': description,
      'userId': userId,
    };
  }

  // Create from Map
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      title: map['title'],
      description: map['description'] ?? '',
      dateTime: map['dateTime'],
      userId: map['userId'],
    );
  }

  // Helper to get formatted date string
  String getFormattedDate() {
    final date = DateTime.parse(dateTime);
    return '${date.day}/${date.month}/${date.year}';
  }

  // Helper to get formatted time string
  String getFormattedTime() {
    final date = DateTime.parse(dateTime);
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
  Event copyWith({
    String? title,
    String? description,
  }) {
    return Event(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      dateTime: dateTime,
      userId: userId,
    );
  }

}