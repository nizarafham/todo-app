import '../entities/todo.dart';

abstract class TodoRepository {
  Future<List<Todo>> getTodos();
  Future<void> addTodo(Todo todo);
  Future<void> toggleTodoCompletion(String id);
  Future<void> deleteTodo(String id);
}
