import 'package:car_mart/app/network/dio_client.dart';
import 'package:car_mart/environment.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: DioClient)
class AppDioClient extends DioClient {
  AppDioClient(this._environmentConfig) {
    final dio = Dio(
      BaseOptions(
        baseUrl: _environmentConfig.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(responseBody: true));
    }
    // chucker disabled
    // if (kDebugMode) { dio.interceptors.add(ChuckerDioInterceptor()); }

    _dio = dio;
  }

  final EnvironmentConfig _environmentConfig;
  late final Dio _dio;

  @override
  Dio get dio => _dio;
}
