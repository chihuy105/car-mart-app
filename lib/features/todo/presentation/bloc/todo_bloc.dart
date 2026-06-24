import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:car_mart/core/usecase/usecase.dart';
import 'package:car_mart/features/todo/domain/usecases/get_todo_use_case.dart';
import 'package:car_mart/features/todo/presentation/bloc/todo_event.dart';
import 'package:car_mart/features/todo/presentation/bloc/todo_state.dart';
import 'package:car_mart/shared/presentation/bloc/bloc_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc(this._getTodo) : super(const TodoState()) {
    on<TodoEvent>(
      (event, emit) => _onLoad(emit),
      transformer: restartable(),
    );
  }

  final GetTodoUseCase _getTodo;

  Future<void> _onLoad(Emitter<TodoState> emit) => _getTodo.runGuarded(
        params: NoParams(),
        onStart: () =>
            emit(state.copyWith(status: const BlocStatus.loading())),
        onSuccess: (todo) => emit(
          state.copyWith(
            status: const BlocStatus.done(),
            todo: todo,
            failure: null,
          ),
        ),
        onError: (failure) => emit(
          state.copyWith(status: BlocStatus.error(failure), failure: failure),
        ),
      );
}
