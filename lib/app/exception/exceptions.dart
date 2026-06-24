import 'package:car_mart/app/exception/failures.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'exception_converters.dart';

@immutable
class ServerException with EquatableMixin implements Exception {
  const ServerException(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
