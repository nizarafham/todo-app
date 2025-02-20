import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/todo.dart';
import '../models/todo_model.dart';
import 'local_todo_data_source.dart';

class LocalTodoDataSourceImpl implements LocalTodoDataSource {
  static const String _todosKey = 'todos';

  @override
  Future<List<Todo>> getTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todosJson = prefs.getStringList(_todosKey) ?? [];
    return todosJson
        .map((json) => TodoModel.fromJson(jsonDecode(json)))
        .toList();
  }

  @override
  Future<void> addTodo(Todo todo) async {
    final prefs = await SharedPreferences.getInstance();
    final todos = await getTodos();
    todos.add(todo);
    final todosJson = todos
        .map((t) => jsonEncode(TodoModel(
              id: t.id,
              title: t.title,
              completed: t.completed,
              dueDate: t.dueDate,
            ).toJson()))
        .toList();
    await prefs.setStringList(_todosKey, todosJson);
  }

  @override
  Future<void> toggleTodoCompletion(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final todos = await getTodos();
    final updatedTodos = todos.map((todo) {
      if (todo.id == id) {
        return Todo(
          id: todo.id,
          title: todo.title,
          completed: !todo.completed,
          dueDate: todo.dueDate,
        );
      }
      return todo;
    }).toList();
    final todosJson = updatedTodos
        .map((t) => jsonEncode(TodoModel(
              id: t.id,
              title: t.title,
              completed: t.completed,
              dueDate: t.dueDate,
            ).toJson()))
        .toList();
    await prefs.setStringList(_todosKey, todosJson);
  }

  @override
  Future<void> deleteTodo(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final todos = await getTodos();
    final updatedTodos = todos.where((todo) => todo.id != id).toList();
    final todosJson = updatedTodos
        .map((t) => jsonEncode(TodoModel(
              id: t.id,
              title: t.title,
              completed: t.completed,
              dueDate: t.dueDate,
            ).toJson()))
        .toList();
    await prefs.setStringList(_todosKey, todosJson);
  }
}
