import '../repositories/todo_repository.dart';

class ToggleTodoCompletion {
  final TodoRepository repository;

  ToggleTodoCompletion(this.repository);

  Future<void> call(String id) async {
    return await repository.toggleTodoCompletion(id);
  }
}
