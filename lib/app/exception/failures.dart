import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable implements Exception {
  const Failure({this.message, this.error, this.stackTrace});

  final String? message;
  final Object? error;
  final StackTrace? stackTrace;

  String get type;
  String get displayMessage;

  @override
  List<Object?> get props => [message, error];
}

class ServerFailure extends Failure {
  const ServerFailure({super.message, super.error, super.stackTrace});

  @override
  String get type => 'ServerFailure';

  @override
  String get displayMessage => message ?? 'A server error occurred';
}

class UnknownFailure extends Failure {
  const UnknownFailure({super.message, super.error, super.stackTrace});

  @override
  String get type => 'UnknownFailure';

  @override
  String get displayMessage => message ?? 'Something went wrong';
}
