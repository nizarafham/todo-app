import 'package:equatable/equatable.dart';
import '../../domain/entities/todo.dart';

abstract class TodoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTodos extends TodoEvent {}

class AddTodoEvent extends TodoEvent {
  final Todo todo;
  AddTodoEvent(this.todo);

  @override
  List<Object?> get props => [todo];
}

class ToggleTodoCompletionEvent extends TodoEvent {
  final String id;
  ToggleTodoCompletionEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class DeleteTodoEvent extends TodoEvent {
  final String id;
  DeleteTodoEvent(this.id);

  @override
  List<Object?> get props => [id];
}
