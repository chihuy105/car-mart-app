# Car-Mart

A Flutter app that opens `https://www.sgcarmart.com` in a WebView.

On launch, it also calls `https://jsonplaceholder.typicode.com/todos/1` through a shared Dio + Retrofit data layer and shows the returned `title` in a toast.

## Requirements

- FVM
- Flutter 3.44.3

## Setup

```bash
fvm install
fvm flutter pub get
```

## Run

```bash
fvm flutter run --flavor development --target lib/main_development.dart
```

Other flavors:

```bash
fvm flutter run --flavor staging --target lib/main_staging.dart
fvm flutter run --flavor production --target lib/main_production.dart
```

## Architecture

Feature-first clean architecture (`data` / `domain` / `presentation`).

```text
lib/
├── app/
│   ├── app.dart            # root MaterialApp.router
│   ├── exception/          # failures, exceptions, converters
│   ├── network/            # Dio client setup
│   ├── router/             # auto_route config + generated routes
│   └── theme/              # app theme
├── core/
│   ├── constants/          # app constants
│   ├── usecase/            # base use case types
│   └── utils/              # helpers like toast
├── di/                     # get_it + injectable setup
├── features/
│   ├── home/               # home feature
│   │   └── presentation/
│   │       └── pages/      # route pages/screens, e.g. HomeScreen
│   └── todo/               # todo API feature
│       ├── data/           # external data + implementation details
│       │   ├── data_sources/ # Retrofit API definitions
│       │   ├── models/     # JSON models + model-to-entity mapping
│       │   └── repositories/ # repository implementations
│       ├── domain/         # pure app/business contracts
│       │   ├── entities/   # non-null app-facing data objects
│       │   ├── repositories/ # abstract repository contracts
│       │   └── usecases/   # business actions consumed by presentation
│       └── presentation/   # UI-facing state and screens
│           └── bloc/       # events, state, and bloc orchestration
├── shared/
│   └── presentation/       # shared bloc status + reusable widgets
├── bootstrap.dart          # binding, localization, DI, runApp
├── environment.dart        # flavor config
└── main_<flavor>.dart      # flavor entrypoints
```

Main rules:

- Keep feature code inside `lib/features/<feature_name>/`.
- Use `data` for API/model/repository implementation code.
- Use `domain` for entities, repository contracts, and use cases.
- Use `presentation` for bloc, state, events, pages, and widgets.
- Put cross-feature widgets/utilities in `shared` or `core`, not inside one feature.
- Do not throw errors across clean architecture boundaries. Return `Either<Failure, T>` from repositories/use cases.

## API To UI Flow

Current example: loading a todo on launch and showing its `title` in a toast.

```text
TodoApi
  -> TodoModel
  -> TodoRepositoryImpl
  -> GetTodoUseCase
  -> TodoBloc
  -> HomeScreen BlocListener
  -> Toast
```

### 1. API Layer

`lib/features/todo/data/data_sources/todo_api.dart`

`TodoApi` defines HTTP endpoints with Retrofit annotations. It receives the shared `DioClient`, then Retrofit generates `_TodoApi` in `todo_api.g.dart`.

```dart
@RestApi()
@lazySingleton
abstract class TodoApi {
  @factoryMethod
  factory TodoApi(DioClient client) => _TodoApi(client.dio);

  @GET('/todos/1')
  Future<TodoModel> getTodo();
}
```

Pattern for a new endpoint:

- Add a method to the feature API class.
- Return a data model, not a domain entity.
- Run build_runner after changing Retrofit APIs.

### 2. Model Mapping

`lib/features/todo/data/models/todo_model.dart`

Models represent API JSON. They are nullable by default because API responses can omit fields. Convert models to non-null domain entities with defaults in `toEntity()`.

```dart
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
```

Pattern for a new model:

- Use `@freezed abstract class X with _$X`.
- Keep API fields nullable unless the API contract is guaranteed.
- Add `fromJson` for Retrofit/json_serializable.
- Add `toEntity()` to isolate API shape from app/domain shape.

### 3. Repository Implementation

`lib/features/todo/data/repositories/todo_repository_impl.dart`

Repositories call APIs, map models to entities, and convert exceptions into `Failure`.

```dart
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
```

Pattern for repositories:

- Define an abstract contract in `domain/repositories`.
- Implement it in `data/repositories`.
- Bind implementation with `@LazySingleton(as: RepositoryInterface)`.
- Return `Future<Either<Failure, Entity>>`.
- Use `TaskEither.tryCatch` and `toFailure()` instead of throwing.

### 4. Domain Use Case

`lib/features/todo/domain/usecases/get_todo_use_case.dart`

Use cases keep presentation independent from repositories.

```dart
@lazySingleton
class GetTodoUseCase extends UseCase<TodoEntity, NoParams> {
  GetTodoUseCase(this._repository);

  final TodoRepository _repository;

  @override
  Future<Either<Failure, TodoEntity>> call(NoParams params) =>
      _repository.getTodo();
}
```

Pattern for use cases:

- Extend `UseCase<Result, Params>`.
- Use `NoParams` when no input is needed.
- Inject repository contracts, not repository implementations.
- Keep business rules here when they do not belong in UI or data mapping.

### 5. Bloc State Management

`lib/features/todo/presentation/bloc/todo_bloc.dart`

The bloc calls the use case and emits `BlocStatus` for UI reactions.

```dart
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
```

Pattern for blocs:

- Events are Freezed sealed classes.
- State is a Freezed class with `BlocStatus`, data, and optional `Failure`.
- Use `runGuarded()` for consistent start/success/error handling.
- Use `restartable()` when repeated load events should cancel previous work.

### 6. UI Reaction

`lib/features/home/presentation/pages/home_screen.dart`

The screen creates the bloc, dispatches the load event, and listens for status changes.

```dart
@override
Widget wrappedRoute(BuildContext context) {
  return BlocProvider(
    create: (_) =>
        TodoBloc(getIt<GetTodoUseCase>())..add(const TodoEvent.load()),
    child: this,
  );
}
```

```dart
return BlocListener<TodoBloc, TodoState>(
  listenWhen: (prev, curr) => prev.status != curr.status,
  listener: (context, state) {
    state.status.whenOrNull(
      done: () {
        if (state.todo?.title.isNotEmpty == true) {
          context.showToast(state.todo?.title ?? '');
        }
      },
      error: context.showFailure,
    );
  },
  child: Scaffold(...),
);
```

Pattern for UI:

- Create feature blocs close to the route/page that owns them.
- Get dependencies from `getIt` when wiring bloc providers.
- Use `BlocListener` for one-time effects like toast, navigation, dialogs.
- Use `BlocBuilder` when state changes should rebuild visible UI.
- Use `listenWhen`/`buildWhen` to avoid unnecessary work.

## Adding A New API Feature

Use this checklist when adding a feature that loads data from an API and shows it in UI.

1. Create folders:

```text
lib/features/<feature>/
├── data/
│   ├── data_sources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── bloc/
    └── pages/
```

2. Add Retrofit API in `data/data_sources`.
3. Add Freezed model in `data/models`.
4. Add domain entity in `domain/entities`.
5. Add repository contract in `domain/repositories`.
6. Add repository implementation in `data/repositories`.
7. Add use case in `domain/usecases`.
8. Add bloc event/state/bloc in `presentation/bloc`.
9. Provide bloc in the route/page and trigger the first event.
10. Show data or UI effects using `BlocBuilder`/`BlocListener`.
11. Run code generation.
12. Add tests for model mapping, repository, use case, and bloc.

## Shared Components

Reusable UI belongs in `lib/shared/presentation/widgets`.

Current shared widgets:

- `AppButton` wraps app button styling and supports text, child, leading/trailing widgets, and expanded width.
- `AppWebView` wraps platform WebView setup, user agent config, error display, and pull-to-refresh.
- `AppPullToRefresh` provides pointer-based pull-to-refresh behavior for WebView content.

Rules for creating shared components:

- Create a shared widget only when it is reused across features or represents an app-level UI pattern.
- Keep feature-specific widgets inside `features/<feature>/presentation/widgets`.
- Prefer constructor parameters over reading global state.
- Use `Theme.of(context)` for colors/text styles.
- Use localization keys with `.tr()` for user-facing text.
- Keep shared widgets independent from feature blocs/use cases.
- Avoid adding business logic to shared widgets.

Example shape:

```dart
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    required this.title,
    this.message,
    this.action,
    super.key,
  });

  final String title;
  final String? message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: theme.textTheme.titleMedium),
        if (message != null) Text(message!),
        if (action != null) action!,
      ],
    );
  }
}
```

## Dependency Injection

This project uses `get_it` and `injectable`.

Entry point:

- `bootstrap()` creates and loads `EnvironmentConfig`.
- `configureDependencies()` registers `EnvironmentConfig` manually.
- `injectable` registers annotated classes into `getIt`.
- The app reads dependencies from `getIt<T>()`.

```dart
Future<void> configureDependencies({
  required EnvironmentConfig environmentConfig,
}) async {
  getIt
    ..registerSingleton<EnvironmentConfig>(environmentConfig)
    ..init();
}
```

Common annotations:

- `@singleton`: one app-wide instance created once.
- `@lazySingleton`: one app-wide instance created when first requested.
- `@LazySingleton(as: Interface)`: bind an implementation to an interface.
- `@factoryMethod`: tell injectable which factory constructor to use.

Current examples:

- `AppRouter` uses `@singleton`.
- `AppDioClient` uses `@LazySingleton(as: DioClient)`.
- `TodoApi` uses `@RestApi()`, `@lazySingleton`, and `@factoryMethod`.
- `TodoRepositoryImpl` uses `@LazySingleton(as: TodoRepository)`.
- `GetTodoUseCase` uses `@lazySingleton`.

When adding dependencies:

1. Annotate the class or factory.
2. Prefer injecting abstractions across layers.
3. Run build_runner to update `lib/di/injection.config.dart`.
4. Access dependency with `getIt<Type>()` only at composition points like app, route wrappers, or providers.

Avoid:

- Calling `getIt` deep inside repositories/use cases/blocs when constructor injection is possible.
- Registering generated dependencies manually unless there is a specific reason.
- Injecting data-layer implementations directly into presentation.

## Environment And Networking

Flavor entrypoints call `bootstrap(env: ...)`:

- `lib/main_development.dart`
- `lib/main_staging.dart`
- `lib/main_production.dart`

`EnvironmentConfig` loads the matching `.env` file and provides fallback values if the file is missing.

Expected env keys:

- `API_BASE_URL`
- `SGCARMART_URL`

`AppDioClient` creates one shared `Dio` instance with:

- base URL from `EnvironmentConfig.baseUrl`
- JSON headers
- 10 second connect/receive timeouts
- debug logging in debug mode
- Chucker interceptor in debug mode

## Code Generation

Run this after changing Freezed models, JSON models, Retrofit APIs, AutoRoute routes, or injectable registrations:

```bash
fvm dart run build_runner build --delete-conflicting-outputs
```

## Error Handling

Data/domain layers use `Either<Failure, T>` from `fpdart`.

Repository pattern:

```dart
return TaskEither.tryCatch(
  () async => await loadData(),
  (error, stackTrace) => error.toFailure(
    message: 'Human readable fallback message',
    stackTrace: stackTrace,
  ),
).run();
```

UI pattern:

- Loading: emit `BlocStatus.loading()`.
- Success: emit `BlocStatus.done()` and store data in state.
- Error: emit `BlocStatus.error(failure)` and store failure in state.
- One-time error UI: use `BlocListener` and `context.showFailure`.

## Testing

Tests mirror `lib/` structure under `test/`.

Current examples:

- `test/features/todo/data/models/todo_model_test.dart`
- `test/features/todo/data/repositories/todo_repository_impl_test.dart`
- `test/features/todo/domain/usecases/get_todo_use_case_test.dart`
- `test/features/todo/presentation/bloc/todo_bloc_test.dart`

Run tests:

```bash
fvm flutter test
```

Recommended coverage for new API features:

- Model `fromJson` and `toEntity()` mapping.
- Repository success and failure paths.
- Use case calls repository contract.
- Bloc emits loading/success/error states.
- UI behavior for important visible states/effects when practical.

## Static Analysis

Run analyzer before opening a PR or handing off work:

```bash
fvm flutter analyze
```

The project uses `very_good_analysis`. Generated files are excluded in `analysis_options.yaml`.

## Build Project

Android example:

```bash
fvm flutter build apk --flavor development --target lib/main_development.dart
```

iOS example:

```bash
fvm flutter build ios --flavor production --target lib/main_production.dart --no-codesign
```

## Screenshots

<img src="demo/img.png" width="300" /> <img src="demo/img_1.png" width="300" />
