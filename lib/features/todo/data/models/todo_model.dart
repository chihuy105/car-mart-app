import 'package:car_mart/features/todo/domain/entities/todo_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_model.freezed.dart';
part 'todo_model.g.dart';

@freezed
abstract class TodoModel with _$TodoModel {
  const TodoModel._();

  const factory TodoModel({
    int? userId,
    int? id,
    String? title,
    bool? completed,
  }) = _TodoModel;

  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);

  TodoEntity toEntity() => TodoEntity(
        id: id ?? 0,
        title: title ?? '',
        completed: completed ?? false,
      );
}
