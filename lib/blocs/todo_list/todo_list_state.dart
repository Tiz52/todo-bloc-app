part of 'todo_list_bloc.dart';

class TodoListState extends Equatable {
  final List<Todo> todos;
  const TodoListState({
    required this.todos,
  });

  factory TodoListState.initial() => TodoListState(todos: [
        Todo(id: '1', description: 'Clean the house'),
        Todo(id: '2', description: 'Wash the car'),
        Todo(id: '3', description: 'Buy groceries'),
      ]);

  @override
  List<Object> get props => [todos];

  @override
  String toString() => 'TodoListState { todos: $todos }';

  TodoListState copyWith({
    List<Todo>? todos,
  }) {
    return TodoListState(
      todos: todos ?? this.todos,
    );
  }
}
