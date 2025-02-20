import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/todo.dart';
import '../../data/models/todo_model.dart';
import 'local_todo_data_source.dart';

class LocalTodoDataSourceImpl implements LocalTodoDataSource {
  static const String _todosKey = 'TODOS';

  @override
  Future<List<Todo>> getTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_todosKey);
    if (jsonString == null) return [];
    
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => TodoModel.fromJson(json)).toList();
  }

  @override
  Future<void> addTodo(Todo todo) async {
    final todos = await getTodos();
    final newTodos = [...todos, todo];
    await _saveTodos(newTodos);
  }

  @override
  Future<void> toggleTodoCompletion(String id) async {
    final todos = await getTodos();
    final updatedTodos = todos.map((todo) {
      if (todo.id == id) {
        return TodoModel(
          id: todo.id,
          title: todo.title,
          completed: !todo.completed,
        );
      }
      return todo;
    }).toList();
    await _saveTodos(updatedTodos);
  }

  @override
  Future<void> deleteTodo(String id) async {
    final todos = await getTodos();
    final updatedTodos = todos.where((todo) => todo.id != id).toList();
    await _saveTodos(updatedTodos);
  }

  Future<void> _saveTodos(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(todos.map((todo) => TodoModel(
      id: todo.id, 
      title: todo.title, 
      completed: todo.completed
    ).toJson()).toList());
    
    await prefs.setString(_todosKey, jsonString);
  }
}
