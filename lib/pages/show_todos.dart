import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_cubit/blocs/blocs.dart';
import 'package:todo_cubit/blocs/filtered_todos/filtered_todos_bloc.dart';

import '../models/todo_model.dart';

class ShowTodos extends StatelessWidget {
  const ShowTodos({super.key});

  @override
  Widget build(BuildContext context) {
    final todos = context.watch<FilteredTodosBloc>().state.filteredTodos;

    List<Todo> setFilteredTodos(
      Filter filter,
      List<Todo> todos,
      String searchTerm,
    ) {
      List<Todo> filteredTodos;

      switch (filter) {
        case Filter.active:
          filteredTodos = todos.where((todo) => !todo.isCompleted).toList();
          break;
        case Filter.completed:
          filteredTodos = todos.where((todo) => todo.isCompleted).toList();
          break;
        case Filter.all:
        default:
          filteredTodos = todos;
          break;
      }

      if (searchTerm.isNotEmpty) {
        filteredTodos = filteredTodos
            .where((todo) => todo.description
                .toLowerCase()
                .contains(searchTerm.toLowerCase()))
            .toList();
      }

      return filteredTodos;
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<TodoListBloc, TodoListState>(
          listener: (context, state) {
            final filteredTodos = setFilteredTodos(
              context.read<TodoFilterBloc>().state.filter,
              state.todos,
              context.read<TodoSearchBloc>().state.searchTerm,
            );
            context.read<FilteredTodosBloc>().add(
                  CalculateFilteredTodosEvent(
                    filteredTodos: filteredTodos,
                  ),
                );
          },
        ),
        BlocListener<TodoFilterBloc, TodoFilterState>(
          listener: (context, state) {
            final filteredTodos = setFilteredTodos(
              state.filter,
              context.read<TodoListBloc>().state.todos,
              context.read<TodoSearchBloc>().state.searchTerm,
            );
            context.read<FilteredTodosBloc>().add(
                  CalculateFilteredTodosEvent(
                    filteredTodos: filteredTodos,
                  ),
                );
          },
        ),
        BlocListener<TodoSearchBloc, TodoSearchState>(
          listener: (context, state) {
            final filteredTodos = setFilteredTodos(
              context.read<TodoFilterBloc>().state.filter,
              context.read<TodoListBloc>().state.todos,
              state.searchTerm,
            );
            context.read<FilteredTodosBloc>().add(
                  CalculateFilteredTodosEvent(
                    filteredTodos: filteredTodos,
                  ),
                );
          },
        ),
      ],
      child: ListView.separated(
        primary: false,
        shrinkWrap: true,
        itemCount: todos.length,
        separatorBuilder: (context, index) => const Divider(
          color: Colors.grey,
        ),
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(todos[index].id),
            background: showBackground(0),
            secondaryBackground: showBackground(1),
            onDismissed: (_) {
              context
                  .read<TodoListBloc>()
                  .add(RemoveTodoEvent(todo: todos[index]));
            },
            confirmDismiss: (_) {
              return showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Are you sure?'),
                    content: const Text('Do you really want to delete?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('NO'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('YES'),
                      ),
                    ],
                  );
                },
              );
            },
            child: TodoItem(
              todo: todos[index],
            ),
          );
        },
      ),
    );
  }

  Widget showBackground(int direction) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      color: Colors.red,
      alignment: direction == 0 ? Alignment.centerLeft : Alignment.centerRight,
      child: const Icon(
        Icons.delete,
        size: 30.0,
        color: Colors.white,
      ),
    );
  }
}

class TodoItem extends StatefulWidget {
  final Todo todo;
  const TodoItem({Key? key, required this.todo}) : super(key: key);

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            bool error = false;
            _controller.text = widget.todo.description;
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: const Text('Edit Todo'),
                  content: TextField(
                    controller: _controller,
                    autofocus: true,
                    decoration: InputDecoration(
                        errorText: error ? "Value cannot be empty" : null),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('CANCEL'),
                    ),
                    TextButton(
                      onPressed: () => setState(() {
                        error = _controller.text.isEmpty;
                        if (!error) {
                          context.read<TodoListBloc>().add(EditTodoEvent(
                              id: widget.todo.id,
                              description: _controller.text));
                          Navigator.pop(context);
                        }
                      }),
                      child: const Text('EDIT'),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
      leading: Checkbox(
        value: widget.todo.isCompleted,
        onChanged: (bool? checked) {
          context.read<TodoListBloc>().add(ToggleTodoEvent(id: widget.todo.id));
        },
      ),
      title: Text(widget.todo.description),
    );
  }
}
