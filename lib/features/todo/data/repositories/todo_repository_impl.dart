import 'package:car_mart/app/exception/exceptions.dart';
import 'package:car_mart/app/exception/failures.dart';
import 'package:car_mart/features/todo/data/data_sources/todo_api.dart';
import 'package:car_mart/features/todo/domain/entities/todo_entity.dart';
import 'package:car_mart/features/todo/domain/repositories/todo_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: TodoRepository)
class TodoRepositoryImpl implements TodoRepository {
  const TodoRepositoryImpl(this._api);

  final TodoApi _api;

  @override
  Future<Either<Failure, TodoEntity>> getTodo() {
    return TaskEither.tryCatch(
      () async => (await _api.getTodo()).toEntity(),
      (error, stackTrace) => error.toFailure(
        message: 'Failed to load todo',
        stackTrace: stackTrace,
      ),
    ).run();
  }
}
