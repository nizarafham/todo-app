import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/domain/usecases/add_todo.dart';
import 'package:todo_app/domain/usecases/delete_todo.dart';
import 'package:todo_app/domain/usecases/toogle_todo_completion.dart';
import 'package:todo_app/presentation/bloc/todo_event.dart';
import 'package:todo_app/presentation/pages/todo_list_page.dart';
import 'package:todo_app/data/datasources/local_todo_data_source_impl.dart';
import 'package:todo_app/data/repositories/todo_repository_impl.dart';
import 'package:todo_app/domain/usecases/get_todos.dart';
import 'package:todo_app/presentation/bloc/todo_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final localDataSource = LocalTodoDataSourceImpl();
  final todoRepository = TodoRepositoryImpl(localDataSource);

  runApp(MyApp(
    getTodos: GetTodos(todoRepository),
    addTodo: AddTodo(todoRepository),
    deleteTodo: DeleteTodo(todoRepository),
    toggleTodoCompletion: ToggleTodoCompletion(todoRepository),
  ));
}

class MyApp extends StatelessWidget {
  final GetTodos getTodos;
  final AddTodo addTodo;
  final DeleteTodo deleteTodo;
  final ToggleTodoCompletion toggleTodoCompletion;

  const MyApp({
    Key? key,
    required this.getTodos,
    required this.addTodo,
    required this.deleteTodo,
    required this.toggleTodoCompletion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TodoBloc(
            getTodos,
            addTodo,
            deleteTodo,
            toggleTodoCompletion,
          )..add(LoadTodos()),
        ),
      ],
      child: MaterialApp(
        title: 'To-Do List',
        home: TodoListPage(),
      ),
    );
  }
}
