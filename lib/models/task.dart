class Task {
  final int? id;
  final String title;
  final String? createdAt;
  bool isCompleted;

  Task({
    this.id,
    required this.title,
    this.createdAt,
    required this.isCompleted,
  });

  Task copyWith({
    int? id,
    String? title,
    String? content,
    String? createdAt,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt ?? '',
      'isCompleted': isCompleted ? 1 : 0, // Store boolean as integer
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      createdAt: map['createdAt'] ?? '',
      isCompleted: map['isCompleted'] == 1, // Convert integer back to boolean
    );
  }
}
