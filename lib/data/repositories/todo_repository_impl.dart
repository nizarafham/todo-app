import 'package:todo_app/data/models/todo_model.dart';

import '../../domain/repositories/todo_repository.dart';
import '../../domain/entities/todo.dart';
import '../datasources/local_todo_data_source.dart';

class TodoRepositoryImpl implements TodoRepository {
  final LocalTodoDataSource localDataSource;

  TodoRepositoryImpl(this.localDataSource);

  @override
  Future<List<Todo>> getTodos() async {
    return await localDataSource.getTodos();
  }

  @override
  Future<void> addTodo(Todo todo) async {
    await localDataSource.addTodo(TodoModel.fromEntity(todo));  // Konversi sebelum menyimpan
  }

  @override
  Future<void> toggleTodoCompletion(String id) async {
    await localDataSource.toggleTodoCompletion(id);
  }

  @override
  Future<void> deleteTodo(String id) async {
    await localDataSource.deleteTodo(id);
  }
}