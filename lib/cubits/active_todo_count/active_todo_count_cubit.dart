import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_cubit/cubits/todo_list/todo_list_cubit.dart';

part 'active_todo_count_state.dart';

class ActiveTodoCountCubit extends Cubit<ActiveTodoCountState> {
  final int initialActiveCount;
  final TodoListCubit todoListCubit;
  late final StreamSubscription _todoListSubscription;
  ActiveTodoCountCubit({
    required this.initialActiveCount,
    required this.todoListCubit,
  }) : super(ActiveTodoCountState(activeTodoCount: initialActiveCount)) {
    _init();
  }

  void _init() {
    _todoListSubscription =
        todoListCubit.stream.listen((TodoListState todoListState) {
      final activeTodoCount =
          todoListState.todos.where((todo) => !todo.isCompleted).length;
      emit(state.copyWith(activeTodoCount: activeTodoCount));
    });
  }

  @override
  Future<void> close() {
    _todoListSubscription.cancel();
    return super.close();
  }
}
