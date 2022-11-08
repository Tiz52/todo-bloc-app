import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_cubit/models/todo_model.dart';

part 'filtered_todos_event.dart';
part 'filtered_todos_state.dart';

class FilteredTodosBloc extends Bloc<FilteredTodosEvent, FilteredTodosState> {
  final List<Todo> initialTodos;

  FilteredTodosBloc({
    required this.initialTodos,
  }) : super(FilteredTodosState(filteredTodos: initialTodos)) {
    on<CalculateFilteredTodosEvent>(_calculateFilteredTodos);
  }

  void _calculateFilteredTodos(
    CalculateFilteredTodosEvent event,
    Emitter<FilteredTodosState> emit,
  ) {
    emit(FilteredTodosState(filteredTodos: event.filteredTodos));
  }
}
