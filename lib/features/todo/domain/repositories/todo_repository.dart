import 'package:car_mart/app/exception/failures.dart';
import 'package:car_mart/features/todo/domain/entities/todo_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class TodoRepository {
  Future<Either<Failure, TodoEntity>> getTodo();
}
