import 'package:auto_route/auto_route.dart';
import 'package:car_mart/features/home/presentation/pages/home_screen.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

part 'app_router.gr.dart';

@singleton
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter()
    : super(
      // chucker disabled
      // navigatorKey: kDebugMode ? ChuckerFlutter.navigatorKey : null,
    );

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: HomeRoute.page, path: '/', initial: true),
  ];
}
