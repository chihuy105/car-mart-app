import 'package:car_mart/di/injection.config.dart';
import 'package:car_mart/environment.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies({
  required EnvironmentConfig environmentConfig,
}) async {
  getIt
    ..registerSingleton<EnvironmentConfig>(environmentConfig)
    ..init();
}
