import 'package:car_mart/app/exception/failures.dart';
import 'package:car_mart/features/todo/data/data_sources/todo_api.dart';
import 'package:car_mart/features/todo/data/models/todo_model.dart';
import 'package:car_mart/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTodoApi extends Mock implements TodoApi {}

void main() {
  late MockTodoApi api;
  late TodoRepositoryImpl repository;

  setUp(() {
    api = MockTodoApi();
    repository = TodoRepositoryImpl(api);
  });

  test('returns Right(TodoEntity) with parsed title on success', () async {
    when(() => api.getTodo()).thenAnswer(
      (_) async => const TodoModel(
        id: 1,
        title: 'delectus aut autem',
        completed: false,
      ),
    );

    final result = await repository.getTodo();

    expect(result.isRight(), isTrue);
    result.match(
      (_) => fail('expected Right'),
      (entity) => expect(entity.title, 'delectus aut autem'),
    );
  });

  test('returns Left(Failure) on DioException', () async {
    when(() => api.getTodo()).thenThrow(
      DioException(requestOptions: RequestOptions(path: '/todos/1')),
    );

    final result = await repository.getTodo();

    expect(result.isLeft(), isTrue);
    result.match(
      (failure) => expect(failure, isA<Failure>()),
      (_) => fail('expected Left'),
    );
  });
}
