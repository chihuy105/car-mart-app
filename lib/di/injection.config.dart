// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../app/network/app_dio_client.dart' as _i1060;
import '../app/network/dio_client.dart' as _i259;
import '../app/router/app_router.dart' as _i559;
import '../environment.dart' as _i674;
import '../features/todo/data/data_sources/todo_api.dart' as _i122;
import '../features/todo/data/repositories/todo_repository_impl.dart' as _i815;
import '../features/todo/domain/repositories/todo_repository.dart' as _i994;
import '../features/todo/domain/usecases/get_todo_use_case.dart' as _i1072;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.singleton<_i559.AppRouter>(() => _i559.AppRouter());
    gh.lazySingleton<_i259.DioClient>(
      () => _i1060.AppDioClient(gh<_i674.EnvironmentConfig>()),
    );
    gh.lazySingleton<_i122.TodoApi>(() => _i122.TodoApi(gh<_i259.DioClient>()));
    gh.lazySingleton<_i994.TodoRepository>(
      () => _i815.TodoRepositoryImpl(gh<_i122.TodoApi>()),
    );
    gh.lazySingleton<_i1072.GetTodoUseCase>(
      () => _i1072.GetTodoUseCase(gh<_i994.TodoRepository>()),
    );
    return this;
  }
}
