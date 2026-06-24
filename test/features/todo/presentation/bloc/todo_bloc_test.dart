import 'package:bloc_test/bloc_test.dart';
import 'package:car_mart/app/exception/failures.dart';
import 'package:car_mart/features/todo/domain/entities/todo_entity.dart';
import 'package:car_mart/features/todo/domain/repositories/todo_repository.dart';
import 'package:car_mart/features/todo/domain/usecases/get_todo_use_case.dart';
import 'package:car_mart/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:car_mart/features/todo/presentation/bloc/todo_event.dart';
import 'package:car_mart/features/todo/presentation/bloc/todo_state.dart';
import 'package:car_mart/shared/presentation/bloc/bloc_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late MockTodoRepository repository;
  late GetTodoUseCase getTodo;

  setUp(() {
    repository = MockTodoRepository();
    getTodo = GetTodoUseCase(repository);
  });

  const todo = TodoEntity(id: 1, title: 'delectus aut autem', completed: false);

  blocTest<TodoBloc, TodoState>(
    'emits [loading, done(todo)] on successful load',
    setUp: () => when(() => repository.getTodo())
        .thenAnswer((_) async => const Right(todo)),
    build: () => TodoBloc(getTodo),
    act: (bloc) => bloc.add(const TodoEvent.load()),
    expect: () => [
      const TodoState(status: BlocStatus.loading()),
      const TodoState(status: BlocStatus.done(), todo: todo),
    ],
  );

  blocTest<TodoBloc, TodoState>(
    'emits [loading, error(failure)] on failure',
    setUp: () => when(() => repository.getTodo()).thenAnswer(
      (_) async => const Left(ServerFailure(message: 'boom')),
    ),
    build: () => TodoBloc(getTodo),
    act: (bloc) => bloc.add(const TodoEvent.load()),
    expect: () => [
      const TodoState(status: BlocStatus.loading()),
      const TodoState(
        status: BlocStatus.error(ServerFailure(message: 'boom')),
        failure: ServerFailure(message: 'boom'),
      ),
    ],
  );
}
