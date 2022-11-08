import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_cubit/blocs/blocs.dart';

class TodoHeader extends StatelessWidget {
  const TodoHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'TODO',
          style: TextStyle(fontSize: 40.0),
        ),
        BlocListener<TodoListBloc, TodoListState>(
          listener: (context, state) {
            final int activeTodoCount =
                state.todos.where((todo) => !todo.isCompleted).length;

            context.read<ActiveTodoCountBloc>().add(
                  CalculateActiveTodoCountEvent(
                    activeTodoCount: activeTodoCount,
                  ),
                );
          },
          child: Text(
            '${context.watch<ActiveTodoCountBloc>().state.activeTodoCount} items left',
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
