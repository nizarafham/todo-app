import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/core/constants/colors.dart';
import 'package:todo_app/core/utils/notification_helper.dart';
import 'package:todo_app/presentation/bloc/todo_event.dart';
import 'package:todo_app/presentation/bloc/todo_state.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart'; // Tambahkan untuk format tanggal
import '../../domain/entities/todo.dart';
import '../bloc/todo_bloc.dart';
import '../widgets/todo_item.dart';

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController _todoController = TextEditingController();
  final Uuid _uuid = Uuid();
  DateTime? _selectedDateTime; // Tambahkan untuk menyimpan tanggal & jam

  void _selectDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _addTodo() async {
    if (_todoController.text.isNotEmpty) {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );

      if (pickedDate != null) {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (pickedTime != null) {
          final scheduledTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          final newTodo = Todo(
            id: _uuid.v4(),
            title: _todoController.text,
            completed: false,
            dueDate: scheduledTime,  // Simpan waktu di todo
          );

          context.read<TodoBloc>().add(AddTodoEvent(newTodo));

          // Jadwalkan notifikasi alarm
          NotificationHelper().scheduleTodoNotification(newTodo.id.hashCode, scheduledTime, newTodo.title);
          
          _todoController.clear();
        }
      }
    }
  }


  String _formatDate(DateTime? date) {
    if (date == null) return "Tidak ada batas waktu";
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kegiatan Putri Tidur"),
        foregroundColor: AppColors.background,
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _todoController,
                        decoration: InputDecoration(
                          hintText: "Tambah Kegiatan...",
                          hintStyle: TextStyle(color: AppColors.onSurface),
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.calendar_today, color: AppColors.primary),
                      onPressed: null,
                    ),
                    ElevatedButton(
                      onPressed: _addTodo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                      ),
                      child: Text(
                        "Tambah",
                        style: TextStyle(color: AppColors.onSecondary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) {
                if (state is TodoLoading) {
                  return Center(child: CircularProgressIndicator(color: AppColors.primary));
                } else if (state is TodoLoaded) {
                  return ListView.builder(
                    itemCount: state.todos.length,
                    itemBuilder: (context, index) {
                      final todo = state.todos[index];
                      return TodoItem(todo: todo);
                    },
                  );
                } else if (state is TodoError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: TextStyle(color: AppColors.error),
                    ),
                  );
                }
                return Center(
                  child: Text(
                    "Belum ada Kegiatan.",
                    style: TextStyle(color: AppColors.onBackground),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.background,
    );
  }
}
