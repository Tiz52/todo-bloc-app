import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'active_todo_count_event.dart';
part 'active_todo_count_state.dart';

class ActiveTodoCountBloc
    extends Bloc<ActiveTodoCountEvent, ActiveTodoCountState> {
  final int initialActiveTodoCount;
  ActiveTodoCountBloc({
    required this.initialActiveTodoCount,
  }) : super(ActiveTodoCountState(activeTodoCount: initialActiveTodoCount)) {
    on<CalculateActiveTodoCountEvent>(_calculateActiveTodoCount);
  }

  void _calculateActiveTodoCount(
    CalculateActiveTodoCountEvent event,
    Emitter<ActiveTodoCountState> emit,
  ) {
    emit(ActiveTodoCountState(activeTodoCount: event.activeTodoCount));
  }
}
