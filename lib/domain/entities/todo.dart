import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final String id;
  final String title;
  final bool completed;
  final DateTime? dueDate; // Tambahkan properti ini

  const Todo({
    required this.id,
    required this.title,
    required this.completed,
    this.dueDate,
  });

  @override
  List<Object?> get props => [id, title, completed, dueDate];
}
