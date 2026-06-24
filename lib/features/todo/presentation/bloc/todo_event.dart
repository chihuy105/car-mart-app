import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_event.freezed.dart';

@freezed
sealed class TodoEvent with _$TodoEvent {
  const factory TodoEvent.load() = TodoLoad;
}
