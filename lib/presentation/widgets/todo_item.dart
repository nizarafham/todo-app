import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal
import 'package:todo_app/core/constants/colors.dart';
import 'package:todo_app/presentation/bloc/todo_event.dart';
import '../../domain/entities/todo.dart';
import '../bloc/todo_bloc.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;

  const TodoItem({Key? key, required this.todo}) : super(key: key);

  String _formatDate(DateTime? date) {
    if (date == null) return "Tidak ada batas waktu";
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      child: ListTile(
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.completed ? TextDecoration.lineThrough : null,
            color: AppColors.onBackground,
          ),
        ),
        subtitle: Text(
          _formatDate(todo.dueDate),
          style: TextStyle(color: AppColors.accent, fontSize: 12),
        ),
        leading: Checkbox(
          value: todo.completed,
          onChanged: (_) {
            context.read<TodoBloc>().add(ToggleTodoCompletionEvent(todo.id));
          },
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: AppColors.error),
          onPressed: () {
            context.read<TodoBloc>().add(DeleteTodoEvent(todo.id));
          },
        ),
      ),
    );
  }
}
