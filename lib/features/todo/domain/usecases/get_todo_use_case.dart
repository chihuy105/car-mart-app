import 'package:car_mart/app/exception/failures.dart';
import 'package:car_mart/core/usecase/usecase.dart';
import 'package:car_mart/features/todo/domain/entities/todo_entity.dart';
import 'package:car_mart/features/todo/domain/repositories/todo_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetTodoUseCase extends UseCase<TodoEntity, NoParams> {
  GetTodoUseCase(this._repository);

  final TodoRepository _repository;

  @override
  Future<Either<Failure, TodoEntity>> call(NoParams params) =>
      _repository.getTodo();
}
