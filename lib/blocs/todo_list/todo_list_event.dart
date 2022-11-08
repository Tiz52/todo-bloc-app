part of 'todo_list_bloc.dart';

abstract class TodoListEvent extends Equatable {
  const TodoListEvent();

  @override
  List<Object> get props => [];
}

class AddTodoEvent extends TodoListEvent {
  final String description;
  const AddTodoEvent({required this.description});

  @override
  List<Object> get props => [description];

  @override
  String toString() => 'AddTodoEvent { description: $description }';
}

class EditTodoEvent extends TodoListEvent {
  final String id;
  final String description;
  const EditTodoEvent({
    required this.id,
    required this.description,
  });

  @override
  List<Object> get props => [id, description];

  @override
  String toString() => 'EditTodoEvent { id: $id, description: $description }';
}

class ToggleTodoEvent extends TodoListEvent {
  final String id;
  const ToggleTodoEvent({required this.id});

  @override
  List<Object> get props => [id];

  @override
  String toString() => 'ToggleTodoEvent { id: $id }';
}

class RemoveTodoEvent extends TodoListEvent {
  final Todo todo;
  const RemoveTodoEvent({required this.todo});

  @override
  List<Object> get props => [todo];

  @override
  String toString() => 'RemoveTodoEvent { todo: $todo }';
}
