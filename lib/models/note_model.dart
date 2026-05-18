class Note {
  final int id;
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
      id: json['id'],
      title: json['title'],
      body: json['body'],
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'userId': 1,
    };
  }

  Note copyWith({
    int? id,
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