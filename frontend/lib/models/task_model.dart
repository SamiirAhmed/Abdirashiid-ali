// Qaabka xogta hawsha (Task) ee dhinaca Flutter-ka
class Task {
  final String id;
  final String userId;
  final String? userName; // Added to store the name of the user
  final String title;
  final String description;
  final String status;
  final String priority;
  final DateTime? dueDate;
  final String category;
  final String project;

  Task({
    required this.id,
    required this.userId,
    this.userName,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    this.dueDate,
    required this.category,
    required this.project,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    String uId = '';
    String? uName;

    if (json['userId'] is Map) {
      uId = json['userId']['_id'] ?? '';
      uName = json['userId']['name'];
    } else {
      uId = json['userId'] ?? '';
    }

    return Task(
      id: json['_id'] ?? '',
      userId: uId,
      userName: uName,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'pending',
      priority: json['priority'] ?? 'medium',
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      category: json['category'] ?? '',
      project: json['project'] ?? 'Main Project',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'dueDate': dueDate?.toIso8601String(),
      'category': category,
      'project': project,
    };
  }
}
