import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/http/client.dart';
import '../../data/http/path.dart';
import '../../extensions/extensions.dart';
import '../../models/station_model.dart';
import '../../utility/utility.dart';

part 'station.freezed.dart';

part 'station.g.dart';

@freezed
class StationState with _$StationState {
  const factory StationState({
    @Default(<StationModel>[]) List<StationModel> stationList,
    @Default(<String, StationModel>{}) Map<String, StationModel> stationMap,
    @Default(<String, List<StationModel>>{}) Map<String, List<StationModel>> trainStationMap,
    @Default(<String, List<StationModel>>{}) Map<String, List<StationModel>> stationStationModelListMap,
  }) = _StationState;
}

@Riverpod(keepAlive: true)
class Station extends _$Station {
  final Utility utility = Utility();

  ///
  @override
  StationState build() => const StationState();

  ///
  Future<StationState> fetchStationData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final dynamic value = await client.post(path: APIPath.getAllStation);

      final List<StationModel> list = <StationModel>[];
      final Map<String, StationModel> map = <String, StationModel>{};

      final Map<String, List<StationModel>> map2 = <String, List<StationModel>>{};

      final Map<String, List<StationModel>> map3 = <String, List<StationModel>>{};

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
        // ignore: avoid_dynamic_calls
        final StationModel val = StationModel.fromJson(value['data'][i] as Map<String, dynamic>);

        map2[val.lineName] = <StationModel>[];

        map3[val.stationName] = <StationModel>[];
      }

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
        // ignore: avoid_dynamic_calls
        final StationModel val = StationModel.fromJson(value['data'][i] as Map<String, dynamic>);

        list.add(val);

        map['${val.lat}|${val.lng}'] = val;

        map2[val.lineName]?.add(val);

        map3[val.stationName]?.add(val);
      }

      return state.copyWith(
        stationList: list,
        stationMap: map,
        trainStationMap: map2,
        stationStationModelListMap: map3,
      );
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getStationData() async {
    try {
      final StationState newState = await fetchStationData();

      state = newState;
    } catch (_) {}
  }
}
