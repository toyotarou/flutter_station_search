// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_param.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AppParamState {
  List<OverlayEntry>? get firstEntries => throw _privateConstructorUsedError;
  List<OverlayEntry>? get secondEntries => throw _privateConstructorUsedError;
  void Function(void Function())? get setStateCallback =>
      throw _privateConstructorUsedError;

  /// Create a copy of AppParamState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppParamStateCopyWith<AppParamState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppParamStateCopyWith<$Res> {
  factory $AppParamStateCopyWith(
          AppParamState value, $Res Function(AppParamState) then) =
      _$AppParamStateCopyWithImpl<$Res, AppParamState>;
  @useResult
  $Res call(
      {List<OverlayEntry>? firstEntries,
      List<OverlayEntry>? secondEntries,
      void Function(void Function())? setStateCallback});
}

/// @nodoc
class _$AppParamStateCopyWithImpl<$Res, $Val extends AppParamState>
    implements $AppParamStateCopyWith<$Res> {
  _$AppParamStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppParamState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstEntries = freezed,
    Object? secondEntries = freezed,
    Object? setStateCallback = freezed,
  }) {
    return _then(_value.copyWith(
      firstEntries: freezed == firstEntries
          ? _value.firstEntries
          : firstEntries // ignore: cast_nullable_to_non_nullable
              as List<OverlayEntry>?,
      secondEntries: freezed == secondEntries
          ? _value.secondEntries
          : secondEntries // ignore: cast_nullable_to_non_nullable
              as List<OverlayEntry>?,
      setStateCallback: freezed == setStateCallback
          ? _value.setStateCallback
          : setStateCallback // ignore: cast_nullable_to_non_nullable
              as void Function(void Function())?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppParamStateImplCopyWith<$Res>
    implements $AppParamStateCopyWith<$Res> {
  factory _$$AppParamStateImplCopyWith(
          _$AppParamStateImpl value, $Res Function(_$AppParamStateImpl) then) =
      __$$AppParamStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<OverlayEntry>? firstEntries,
      List<OverlayEntry>? secondEntries,
      void Function(void Function())? setStateCallback});
}

/// @nodoc
class __$$AppParamStateImplCopyWithImpl<$Res>
    extends _$AppParamStateCopyWithImpl<$Res, _$AppParamStateImpl>
    implements _$$AppParamStateImplCopyWith<$Res> {
  __$$AppParamStateImplCopyWithImpl(
      _$AppParamStateImpl _value, $Res Function(_$AppParamStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppParamState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstEntries = freezed,
    Object? secondEntries = freezed,
    Object? setStateCallback = freezed,
  }) {
    return _then(_$AppParamStateImpl(
      firstEntries: freezed == firstEntries
          ? _value._firstEntries
          : firstEntries // ignore: cast_nullable_to_non_nullable
              as List<OverlayEntry>?,
      secondEntries: freezed == secondEntries
          ? _value._secondEntries
          : secondEntries // ignore: cast_nullable_to_non_nullable
              as List<OverlayEntry>?,
      setStateCallback: freezed == setStateCallback
          ? _value.setStateCallback
          : setStateCallback // ignore: cast_nullable_to_non_nullable
              as void Function(void Function())?,
    ));
  }
}

/// @nodoc

class _$AppParamStateImpl implements _AppParamState {
  const _$AppParamStateImpl(
      {final List<OverlayEntry>? firstEntries,
      final List<OverlayEntry>? secondEntries,
      this.setStateCallback})
      : _firstEntries = firstEntries,
        _secondEntries = secondEntries;

  final List<OverlayEntry>? _firstEntries;
  @override
  List<OverlayEntry>? get firstEntries {
    final value = _firstEntries;
    if (value == null) return null;
    if (_firstEntries is EqualUnmodifiableListView) return _firstEntries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<OverlayEntry>? _secondEntries;
  @override
  List<OverlayEntry>? get secondEntries {
    final value = _secondEntries;
    if (value == null) return null;
    if (_secondEntries is EqualUnmodifiableListView) return _secondEntries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final void Function(void Function())? setStateCallback;

  @override
  String toString() {
    return 'AppParamState(firstEntries: $firstEntries, secondEntries: $secondEntries, setStateCallback: $setStateCallback)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppParamStateImpl &&
            const DeepCollectionEquality()
                .equals(other._firstEntries, _firstEntries) &&
            const DeepCollectionEquality()
                .equals(other._secondEntries, _secondEntries) &&
            (identical(other.setStateCallback, setStateCallback) ||
                other.setStateCallback == setStateCallback));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_firstEntries),
      const DeepCollectionEquality().hash(_secondEntries),
      setStateCallback);

  /// Create a copy of AppParamState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppParamStateImplCopyWith<_$AppParamStateImpl> get copyWith =>
      __$$AppParamStateImplCopyWithImpl<_$AppParamStateImpl>(this, _$identity);
}

abstract class _AppParamState implements AppParamState {
  const factory _AppParamState(
          {final List<OverlayEntry>? firstEntries,
          final List<OverlayEntry>? secondEntries,
          final void Function(void Function())? setStateCallback}) =
      _$AppParamStateImpl;

  @override
  List<OverlayEntry>? get firstEntries;
  @override
  List<OverlayEntry>? get secondEntries;
  @override
  void Function(void Function())? get setStateCallback;

  /// Create a copy of AppParamState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppParamStateImplCopyWith<_$AppParamStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
