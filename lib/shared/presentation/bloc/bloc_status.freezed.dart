// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bloc_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BlocStatus {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlocStatus);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BlocStatus()';
}


}

/// @nodoc
class $BlocStatusCopyWith<$Res>  {
$BlocStatusCopyWith(BlocStatus _, $Res Function(BlocStatus) __);
}


/// Adds pattern-matching-related methods to [BlocStatus].
extension BlocStatusPatterns on BlocStatus {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( BlocStatusInitial value)?  initial,TResult Function( BlocStatusLoading value)?  loading,TResult Function( BlocStatusDone value)?  done,TResult Function( BlocStatusError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case BlocStatusInitial() when initial != null:
return initial(_that);case BlocStatusLoading() when loading != null:
return loading(_that);case BlocStatusDone() when done != null:
return done(_that);case BlocStatusError() when error != null:
return error(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( BlocStatusInitial value)  initial,required TResult Function( BlocStatusLoading value)  loading,required TResult Function( BlocStatusDone value)  done,required TResult Function( BlocStatusError value)  error,}){
final _that = this;
switch (_that) {
case BlocStatusInitial():
return initial(_that);case BlocStatusLoading():
return loading(_that);case BlocStatusDone():
return done(_that);case BlocStatusError():
return error(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( BlocStatusInitial value)?  initial,TResult? Function( BlocStatusLoading value)?  loading,TResult? Function( BlocStatusDone value)?  done,TResult? Function( BlocStatusError value)?  error,}){
final _that = this;
switch (_that) {
case BlocStatusInitial() when initial != null:
return initial(_that);case BlocStatusLoading() when loading != null:
return loading(_that);case BlocStatusDone() when done != null:
return done(_that);case BlocStatusError() when error != null:
return error(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function()?  done,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case BlocStatusInitial() when initial != null:
return initial();case BlocStatusLoading() when loading != null:
return loading();case BlocStatusDone() when done != null:
return done();case BlocStatusError() when error != null:
return error(_that.failure);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function()  done,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case BlocStatusInitial():
return initial();case BlocStatusLoading():
return loading();case BlocStatusDone():
return done();case BlocStatusError():
return error(_that.failure);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function()?  done,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case BlocStatusInitial() when initial != null:
return initial();case BlocStatusLoading() when loading != null:
return loading();case BlocStatusDone() when done != null:
return done();case BlocStatusError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class BlocStatusInitial extends BlocStatus {
  const BlocStatusInitial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlocStatusInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BlocStatus.initial()';
}


}




/// @nodoc


class BlocStatusLoading extends BlocStatus {
  const BlocStatusLoading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlocStatusLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BlocStatus.loading()';
}


}




/// @nodoc


class BlocStatusDone extends BlocStatus {
  const BlocStatusDone(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlocStatusDone);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BlocStatus.done()';
}


}




/// @nodoc


class BlocStatusError extends BlocStatus {
  const BlocStatusError(this.failure): super._();
  

 final  Failure failure;

/// Create a copy of BlocStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlocStatusErrorCopyWith<BlocStatusError> get copyWith => _$BlocStatusErrorCopyWithImpl<BlocStatusError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlocStatusError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'BlocStatus.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $BlocStatusErrorCopyWith<$Res> implements $BlocStatusCopyWith<$Res> {
  factory $BlocStatusErrorCopyWith(BlocStatusError value, $Res Function(BlocStatusError) _then) = _$BlocStatusErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$BlocStatusErrorCopyWithImpl<$Res>
    implements $BlocStatusErrorCopyWith<$Res> {
  _$BlocStatusErrorCopyWithImpl(this._self, this._then);

  final BlocStatusError _self;
  final $Res Function(BlocStatusError) _then;

/// Create a copy of BlocStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(BlocStatusError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
