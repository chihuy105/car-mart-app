import 'package:car_mart/app/exception/failures.dart';
import 'package:car_mart/features/todo/domain/entities/todo_entity.dart';
import 'package:car_mart/shared/presentation/bloc/bloc_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_state.freezed.dart';

@freezed
abstract class TodoState with _$TodoState {
  const factory TodoState({
    @Default(BlocStatus.initial()) BlocStatus status,
    TodoEntity? todo,
    Failure? failure,
  }) = _TodoState;
}
