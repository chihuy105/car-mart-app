import 'package:car_mart/app/exception/failures.dart';
import 'package:car_mart/core/usecase/usecase.dart';
import 'package:car_mart/features/todo/domain/entities/todo_entity.dart';
import 'package:car_mart/features/todo/domain/repositories/todo_repository.dart';
import 'package:car_mart/features/todo/domain/usecases/get_todo_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late MockTodoRepository repository;
  late GetTodoUseCase useCase;

  setUp(() {
    repository = MockTodoRepository();
    useCase = GetTodoUseCase(repository);
  });

  const todo = TodoEntity(id: 1, title: 'delectus aut autem', completed: false);

  test('delegates to repository and returns Right(TodoEntity) on success',
      () async {
    when(() => repository.getTodo())
        .thenAnswer((_) async => const Right(todo));

    final result = await useCase(NoParams());

    expect(result, const Right<Failure, TodoEntity>(todo));
    verify(() => repository.getTodo()).called(1);
  });

  test('returns Left(Failure) when repository fails', () async {
    const failure = ServerFailure(message: 'boom');
    when(() => repository.getTodo())
        .thenAnswer((_) async => const Left(failure));

    final result = await useCase(NoParams());

    expect(result, const Left<Failure, TodoEntity>(failure));
    verify(() => repository.getTodo()).called(1);
  });
}
