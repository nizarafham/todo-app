import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/domain/entities/todo.dart';
import 'package:todo_app/domain/usecases/toogle_todo_completion.dart';
import '../../domain/usecases/get_todos.dart';
import '../../domain/usecases/add_todo.dart';
import '../../domain/usecases/delete_todo.dart';
// import '../../domain/usecases/toggle_todo_completion.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodos getTodos;
  final AddTodo addTodo;
  final DeleteTodo deleteTodo;
  final ToggleTodoCompletion toggleTodoCompletion;

  TodoBloc(this.getTodos, this.addTodo, this.deleteTodo, this.toggleTodoCompletion)
      : super(TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodoEvent>(_onAddTodo);
    on<ToggleTodoCompletionEvent>(_onToggleTodoCompletion);
    on<DeleteTodoEvent>(_onDeleteTodo);
  }

  void _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final todos = await getTodos();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError('Gagal memuat To-Do: $e'));
    }
  }

  void _onAddTodo(AddTodoEvent event, Emitter<TodoState> emit) async {
    if (state is TodoLoaded) {
      try {
        await addTodo(event.todo);  // Tambahkan ke database dulu
        final todos = await getTodos();  // Ambil ulang daftar To-Do
        emit(TodoLoaded(todos));  // Emit state baru
      } catch (e) {
        emit(TodoError('Gagal menambah To-Do: $e'));
      }
    }
  }

  void _onToggleTodoCompletion(ToggleTodoCompletionEvent event, Emitter<TodoState> emit) async {
    if (state is TodoLoaded) {
      await toggleTodoCompletion(event.id);
      final todos = await getTodos();
      emit(TodoLoaded(todos));
    }
  }

  void _onDeleteTodo(DeleteTodoEvent event, Emitter<TodoState> emit) async {
    if (state is TodoLoaded) {
      await deleteTodo(event.id);
      final todos = await getTodos();
      emit(TodoLoaded(todos));
    }
  }
}
