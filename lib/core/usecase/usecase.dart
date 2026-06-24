import 'dart:async';

import 'package:car_mart/app/exception/exceptions.dart';
import 'package:car_mart/app/exception/failures.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';

abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);

  Future<void> runGuarded({
    required Params params,
    FutureOr<void> Function()? onStart,
    FutureOr<void> Function(T data)? onSuccess,
    FutureOr<void> Function(Failure failure)? onError,
    FutureOr<void> Function()? onComplete,
  }) =>
      call(params).runGuarded(
        onStart: onStart,
        onSuccess: onSuccess,
        onError: onError,
        onComplete: onComplete,
      );
}

class NoParams {}

extension FutureEitherExt<T> on Future<Either<Failure, T>> {
  Future<void> runGuarded({
    FutureOr<void> Function()? onStart,
    FutureOr<void> Function(T data)? onSuccess,
    FutureOr<void> Function(Failure failure)? onError,
    FutureOr<void> Function()? onComplete,
  }) async {
    try {
      await onStart?.call();
      final result = await this;
      await result.fold(
        (failure) async => onError?.call(failure),
        (success) async => onSuccess?.call(success),
      );
    } on Object catch (exception, stackTrace) {
      final failure = exception is Failure
          ? exception
          : exception.toFailure(stackTrace: stackTrace);
      try {
        await onError?.call(failure);
      } on Object catch (err, trace) {
        debugPrintStack(stackTrace: trace);
        debugPrint(err.toString());
      }
    } finally {
      try {
        await onComplete?.call();
      } on Object catch (err, trace) {
        debugPrintStack(stackTrace: trace);
        debugPrint(err.toString());
      }
    }
  }
}
