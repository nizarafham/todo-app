import '../../domain/entities/todo.dart';

class TodoModel extends Todo {
  const TodoModel({
    required String id,
    required String title,
    required bool completed,
    DateTime? dueDate,
  }) : super(id: id, title: title, completed: completed, dueDate: dueDate);

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'completed': completed,
      'dueDate': dueDate?.toIso8601String(),
    };
  }

  // ✅ Tambahkan konversi dari Todo ke TodoModel
  factory TodoModel.fromEntity(Todo todo) {
    return TodoModel(
      id: todo.id,
      title: todo.title,
      completed: todo.completed,
      dueDate: todo.dueDate,
    );
  }
}
