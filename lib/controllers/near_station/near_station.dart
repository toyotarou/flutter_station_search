import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/station_extends_model.dart';

part 'near_station.freezed.dart';

part 'near_station.g.dart';

@freezed
class NearStationState with _$NearStationState {
  const factory NearStationState({
    @Default(<LatLng>[]) List<LatLng> nearStationList,
    @Default(<StationExtendsModel>[]) List<StationExtendsModel> stationExtendsList,
  }) = _NearStationState;
}

@Riverpod(keepAlive: true)
class NearStation extends _$NearStation {
  ///
  @override
  NearStationState build() => const NearStationState();

  ///
  void setNearStationList({required LatLng latlng}) {
    final List<LatLng> list = <LatLng>[...state.nearStationList];
    list.add(latlng);
    state = state.copyWith(nearStationList: list);
  }

  ///
  void setStationExtendsList({required StationExtendsModel stationExtendsModel}) {
    final List<StationExtendsModel> list = <StationExtendsModel>[...state.stationExtendsList];
    list.add(stationExtendsModel);
    state = state.copyWith(stationExtendsList: list);
  }
}
