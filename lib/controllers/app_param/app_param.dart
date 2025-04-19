import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../utility/utility.dart';

part 'app_param.freezed.dart';

part 'app_param.g.dart';

@freezed
class AppParamState with _$AppParamState {
  const factory AppParamState({
    List<OverlayEntry>? firstEntries,
    List<OverlayEntry>? secondEntries,
    void Function(VoidCallback fn)? setStateCallback,
    Offset? overlayPosition,
    LatLng? selectedStationLatLng,
    @Default(0) double currentZoom,
    @Default('') String selectedLineNumber,
    @Default(<String>[]) List<String> trainNumberList,
    @Default(false) bool limitTokyoTrain,
  }) = _AppParamState;
}

@Riverpod(keepAlive: true)
class AppParam extends _$AppParam {
  final Utility utility = Utility();

  ///
  @override
  AppParamState build() => const AppParamState();

  ///
  void setFirstOverlayParams({required List<OverlayEntry>? firstEntries}) =>
      state = state.copyWith(firstEntries: firstEntries);

  ///
  void setSecondOverlayParams({required List<OverlayEntry>? secondEntries}) =>
      state = state.copyWith(secondEntries: secondEntries);

  ///
  void updateOverlayPosition(Offset newPos) => state = state.copyWith(overlayPosition: newPos);

  ///
  void setSelectedStationLatLng({required LatLng latlng}) => state = state.copyWith(selectedStationLatLng: latlng);

  ///
  void clearSelectedStationLatLng() => state = state.copyWith(selectedStationLatLng: null);

  ///
  void setCurrentZoom({required double zoom}) => state = state.copyWith(currentZoom: zoom);

  ///
  void setSelectedLineNumber({required String lineNumber}) => state = state.copyWith(selectedLineNumber: lineNumber);

  ///
  void setTrainNumberList({required String trainNumber}) {
    final List<String> trainNumberList = <String>[...state.trainNumberList];

    if (trainNumberList.contains(trainNumber)) {
      trainNumberList.remove(trainNumber);
    } else {
      trainNumberList.add(trainNumber);
    }

    state = state.copyWith(trainNumberList: trainNumberList);
  }

  ///
  void clearTrainNumberList() => state = state.copyWith(trainNumberList: <String>[]);

  ///
  void setLimitTokyoTrain({required bool flag}) => state = state.copyWith(limitTokyoTrain: flag);
}
