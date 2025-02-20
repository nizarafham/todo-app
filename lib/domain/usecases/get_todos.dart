import '../repositories/todo_repository.dart';
import '../entities/todo.dart';

class GetTodos {
  final TodoRepository repository;

  GetTodos(this.repository);

  Future<List<Todo>> call() async {
    return await repository.getTodos();
  }
}
