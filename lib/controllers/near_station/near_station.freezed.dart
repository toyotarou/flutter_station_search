// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'near_station.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NearStationState {
  List<LatLng> get nearStationList => throw _privateConstructorUsedError;
  List<StationExtendsModel> get stationExtendsList =>
      throw _privateConstructorUsedError;

  /// Create a copy of NearStationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NearStationStateCopyWith<NearStationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NearStationStateCopyWith<$Res> {
  factory $NearStationStateCopyWith(
          NearStationState value, $Res Function(NearStationState) then) =
      _$NearStationStateCopyWithImpl<$Res, NearStationState>;
  @useResult
  $Res call(
      {List<LatLng> nearStationList,
      List<StationExtendsModel> stationExtendsList});
}

/// @nodoc
class _$NearStationStateCopyWithImpl<$Res, $Val extends NearStationState>
    implements $NearStationStateCopyWith<$Res> {
  _$NearStationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NearStationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nearStationList = null,
    Object? stationExtendsList = null,
  }) {
    return _then(_value.copyWith(
      nearStationList: null == nearStationList
          ? _value.nearStationList
          : nearStationList // ignore: cast_nullable_to_non_nullable
              as List<LatLng>,
      stationExtendsList: null == stationExtendsList
          ? _value.stationExtendsList
          : stationExtendsList // ignore: cast_nullable_to_non_nullable
              as List<StationExtendsModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NearStationStateImplCopyWith<$Res>
    implements $NearStationStateCopyWith<$Res> {
  factory _$$NearStationStateImplCopyWith(_$NearStationStateImpl value,
          $Res Function(_$NearStationStateImpl) then) =
      __$$NearStationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<LatLng> nearStationList,
      List<StationExtendsModel> stationExtendsList});
}

/// @nodoc
class __$$NearStationStateImplCopyWithImpl<$Res>
    extends _$NearStationStateCopyWithImpl<$Res, _$NearStationStateImpl>
    implements _$$NearStationStateImplCopyWith<$Res> {
  __$$NearStationStateImplCopyWithImpl(_$NearStationStateImpl _value,
      $Res Function(_$NearStationStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of NearStationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nearStationList = null,
    Object? stationExtendsList = null,
  }) {
    return _then(_$NearStationStateImpl(
      nearStationList: null == nearStationList
          ? _value._nearStationList
          : nearStationList // ignore: cast_nullable_to_non_nullable
              as List<LatLng>,
      stationExtendsList: null == stationExtendsList
          ? _value._stationExtendsList
          : stationExtendsList // ignore: cast_nullable_to_non_nullable
              as List<StationExtendsModel>,
    ));
  }
}

/// @nodoc

class _$NearStationStateImpl implements _NearStationState {
  const _$NearStationStateImpl(
      {final List<LatLng> nearStationList = const <LatLng>[],
      final List<StationExtendsModel> stationExtendsList =
          const <StationExtendsModel>[]})
      : _nearStationList = nearStationList,
        _stationExtendsList = stationExtendsList;

  final List<LatLng> _nearStationList;
  @override
  @JsonKey()
  List<LatLng> get nearStationList {
    if (_nearStationList is EqualUnmodifiableListView) return _nearStationList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nearStationList);
  }

  final List<StationExtendsModel> _stationExtendsList;
  @override
  @JsonKey()
  List<StationExtendsModel> get stationExtendsList {
    if (_stationExtendsList is EqualUnmodifiableListView)
      return _stationExtendsList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stationExtendsList);
  }

  @override
  String toString() {
    return 'NearStationState(nearStationList: $nearStationList, stationExtendsList: $stationExtendsList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NearStationStateImpl &&
            const DeepCollectionEquality()
                .equals(other._nearStationList, _nearStationList) &&
            const DeepCollectionEquality()
                .equals(other._stationExtendsList, _stationExtendsList));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_nearStationList),
      const DeepCollectionEquality().hash(_stationExtendsList));

  /// Create a copy of NearStationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NearStationStateImplCopyWith<_$NearStationStateImpl> get copyWith =>
      __$$NearStationStateImplCopyWithImpl<_$NearStationStateImpl>(
          this, _$identity);
}

abstract class _NearStationState implements NearStationState {
  const factory _NearStationState(
          {final List<LatLng> nearStationList,
          final List<StationExtendsModel> stationExtendsList}) =
      _$NearStationStateImpl;

  @override
  List<LatLng> get nearStationList;
  @override
  List<StationExtendsModel> get stationExtendsList;

  /// Create a copy of NearStationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NearStationStateImplCopyWith<_$NearStationStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
