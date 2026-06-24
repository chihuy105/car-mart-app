part of 'exceptions.dart';

extension ExceptionConverter on Object {
  Failure toFailure({String? message, StackTrace? stackTrace}) {
    final self = this;
    if (self is Failure) return self;
    if (self is DioException) {
      return ServerFailure(
        message: message ?? self.message ?? self.toString(),
        error: self,
        stackTrace: stackTrace,
      );
    }
    return UnknownFailure(
      message: message ?? toString(),
      error: this,
      stackTrace: stackTrace,
    );
  }
}
