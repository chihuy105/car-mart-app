import 'package:car_mart/app/exception/failures.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bloc_status.freezed.dart';

@freezed
sealed class BlocStatus with _$BlocStatus {
  const BlocStatus._();

  const factory BlocStatus.initial() = BlocStatusInitial;
  const factory BlocStatus.loading() = BlocStatusLoading;
  const factory BlocStatus.done() = BlocStatusDone;
  const factory BlocStatus.error(Failure failure) = BlocStatusError;

  bool get isInitial => this is BlocStatusInitial;
  bool get isLoading => this is BlocStatusLoading;
  bool get isDone => this is BlocStatusDone;
  bool get isError => this is BlocStatusError;
}
