import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/core/constants/colors.dart'; // Import warna
import 'package:todo_app/presentation/bloc/todo_event.dart';
import 'package:todo_app/presentation/bloc/todo_state.dart';
import 'package:uuid/uuid.dart';
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

  void _addTodo() {
    if (_todoController.text.isNotEmpty) {
      final newTodo = Todo(
        id: _uuid.v4(),
        title: _todoController.text,
        completed: false,
      );
      context.read<TodoBloc>().add(AddTodoEvent(newTodo));
      _todoController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kegiatan Putri Tidur"),
        backgroundColor: AppColors.primary, // Warna AppBar
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
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
                ElevatedButton(
                  onPressed: _addTodo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary, // Warna tombol
                  ),
                  child: Text(
                    "Tambah",
                    style: TextStyle(color: AppColors.onSecondary),
                  ),
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
                    "Belum ada To-Do.",
                    style: TextStyle(color: AppColors.onBackground),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.background, // Warna latar belakang
    );
  }
}
