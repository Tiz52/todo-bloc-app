import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_cubit/blocs/blocs.dart';

class CreateTodo extends StatefulWidget {
  const CreateTodo({Key? key}) : super(key: key);

  @override
  State<CreateTodo> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      decoration: const InputDecoration(
        labelText: 'What to do?',
      ),
      onSubmitted: (String? value) {
        if (value != null && value.trim().isNotEmpty) {
          context.read<TodoListBloc>().add(AddTodoEvent(description: value));
          _textController.clear();
        }
      },
    );
  }
}
