import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/todo_model.dart';

part 'todo_filter_event.dart';
part 'todo_filter_state.dart';

class TodoFilterBloc extends Bloc<TodoFilterEvent, TodoFilterState> {
  TodoFilterBloc() : super(TodoFilterState.initial()) {
    on<ChangeFilterEvent>(_changeFilter);
  }

  void _changeFilter(ChangeFilterEvent event, Emitter<TodoFilterState> emit) {
    emit(state.copyWith(filter: event.newFilter));
  }
}
