import 'dart:developer';

import 'package:car_mart/app/app.dart';
import 'package:car_mart/app/theme/app_theme.dart';
import 'package:car_mart/di/injection.dart';
import 'package:car_mart/environment.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

Future<void> bootstrap({required Environment env}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final environmentConfig = EnvironmentConfig(env);
  await environmentConfig.load();

  await configureDependencies(environmentConfig: environmentConfig);

  SystemChrome.setSystemUIOverlayStyle(AppTheme.systemUiOverlayStyle);

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const App(),
    ),
  );
}
