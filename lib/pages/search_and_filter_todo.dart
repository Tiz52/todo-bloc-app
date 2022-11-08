import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_cubit/blocs/blocs.dart';
import 'package:todo_cubit/utils/debounce.dart';

import '../models/todo_model.dart';

class SearchAndFilterTodo extends StatelessWidget {
  SearchAndFilterTodo({super.key});
  final debounce = Debounce(milliseconds: 1000);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
            hintText: 'Search todos...',
            border: InputBorder.none,
            filled: true,
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (String? value) {
            if (value != null) {
              context
                  .read<TodoSearchBloc>()
                  .add(SetSearchTermEvent(newSearchTerm: value));
            }
          },
        ),
        const SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            _FilterButton(filter: Filter.all),
            _FilterButton(filter: Filter.active),
            _FilterButton(filter: Filter.completed),
          ],
        ),
      ],
    );
  }
}

class _FilterButton extends StatelessWidget {
  final Filter filter;
  const _FilterButton({Key? key, required this.filter}) : super(key: key);

  Color textColor(BuildContext context, Filter currentFilter) {
    final currentFilter = context.watch<TodoFilterBloc>().state.filter;
    return currentFilter == filter ? Colors.blue : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context
            .read<TodoFilterBloc>()
            .add(ChangeFilterEvent(newFilter: filter));
      },
      child: Text(
          filter == Filter.all
              ? 'All'
              : filter == Filter.active
                  ? 'Active'
                  : 'Completed',
          style: TextStyle(
            fontSize: 18.0,
            color: textColor(context, filter),
          )),
    );
  }
}
