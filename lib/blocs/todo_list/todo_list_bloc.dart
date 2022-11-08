import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/todo_model.dart';

part 'todo_list_event.dart';
part 'todo_list_state.dart';

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  TodoListBloc() : super(TodoListState.initial()) {
    on<AddTodoEvent>(_addTodo);
    on<EditTodoEvent>(_editTodo);
    on<ToggleTodoEvent>(_toggleTodo);
    on<RemoveTodoEvent>(_removeTodo);
  }

  void _addTodo(AddTodoEvent event, Emitter<TodoListState> emit) {
    final newTodo = Todo(description: event.description);
    final newTodos = [...state.todos, newTodo];
    emit(state.copyWith(todos: newTodos));
  }

  void _editTodo(EditTodoEvent event, Emitter<TodoListState> emit) {
    final newTodos = state.todos.map((todo) {
      if (todo.id == event.id) {
        return Todo(
          id: todo.id,
          description: event.description,
          isCompleted: todo.isCompleted,
        );
      }
      return todo;
    }).toList();
    emit(state.copyWith(todos: newTodos));
  }

  void _toggleTodo(
    ToggleTodoEvent event,
    Emitter<TodoListState> emit,
  ) {
    final newTodos = state.todos.map((todo) {
      if (todo.id == event.id) {
        return Todo(
          id: todo.id,
          description: todo.description,
          isCompleted: !todo.isCompleted,
        );
      }
      return todo;
    }).toList();
    emit(state.copyWith(todos: newTodos));
  }

  void _removeTodo(
    RemoveTodoEvent event,
    Emitter<TodoListState> emit,
  ) {
    final newTodos =
        state.todos.where((todo) => todo.id != event.todo.id).toList();
    emit(state.copyWith(todos: newTodos));
  }
}
