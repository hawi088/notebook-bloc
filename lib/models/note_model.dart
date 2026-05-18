class Note {
  final String id;  // Change from int to String
  final String title;
  final String body;
  final DateTime createdAt;

  Note({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'].toString(),  // Convert to String
      title: json['title'],
      body: json['body'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Note copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? createdAt,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}