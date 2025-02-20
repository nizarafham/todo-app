import '../repositories/todo_repository.dart';
import '../entities/todo.dart';

class AddTodo {
  final TodoRepository repository;

  AddTodo(this.repository);

  Future<void> call(Todo todo) async {
    return await repository.addTodo(todo);
  }
}
