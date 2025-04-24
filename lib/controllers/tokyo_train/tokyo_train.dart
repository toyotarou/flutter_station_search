import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/http/client.dart';
import '../../data/http/path.dart';
import '../../extensions/extensions.dart';
import '../../models/tokyo_station_model.dart';
import '../../models/tokyo_train_model.dart';
import '../../utility/utility.dart';

part 'tokyo_train.freezed.dart';

part 'tokyo_train.g.dart';

@freezed
class TokyoTrainState with _$TokyoTrainState {
  const factory TokyoTrainState({
    @Default(<TokyoTrainModel>[]) List<TokyoTrainModel> tokyoTrainList,
    @Default(<String, TokyoTrainModel>{}) Map<String, TokyoTrainModel> tokyoTrainMap,
    @Default(<int, TokyoTrainModel>{}) Map<int, TokyoTrainModel> tokyoTrainIdMap,
    @Default(<String, TokyoStationModel>{}) Map<String, TokyoStationModel> tokyoStationMap,
    @Default(<int>[]) List<int> selectTrainList,
    @Default(<String, List<TokyoStationModel>>{})
    Map<String, List<TokyoStationModel>> tokyoStationTokyoStationModelListMap,
    @Default(<String, Map<String, String>>{}) Map<String, Map<String, String>> tokyoStationNextStationMap,
  }) = _TokyoTrainState;
}

@Riverpod(keepAlive: true)
class TokyoTrain extends _$TokyoTrain {
  final Utility utility = Utility();

  ///
  @override
  TokyoTrainState build() => const TokyoTrainState();

  //============================================== api

  ///
  Future<TokyoTrainState> fetchAllTokyoTrainData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final dynamic value = await client.post(path: APIPath.getTokyoTrainStation);

      final List<TokyoTrainModel> list = <TokyoTrainModel>[];

      final Map<String, TokyoTrainModel> map = <String, TokyoTrainModel>{};

      final Map<int, TokyoTrainModel> map2 = <int, TokyoTrainModel>{};

      final Map<String, TokyoStationModel> map3 = <String, TokyoStationModel>{};

      final Map<String, List<TokyoStationModel>> map4 = <String, List<TokyoStationModel>>{};

      final Map<String, Map<String, String>> map5 = <String, Map<String, String>>{};

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
        // ignore: avoid_dynamic_calls
        final TokyoTrainModel val = TokyoTrainModel.fromJson(value['data'][i] as Map<String, dynamic>);

        list.add(val);
        map[val.trainName] = val;

        map2[val.trainNumber] = val;

        for (final TokyoStationModel element in val.station) {
          map3[element.id] = element;

          map4[element.stationName] = <TokyoStationModel>[];
        }
      }

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
        // ignore: avoid_dynamic_calls
        final TokyoTrainModel val = TokyoTrainModel.fromJson(value['data'][i] as Map<String, dynamic>);

        //----------------------------------------------------------------//
        int j = 0;

        for (final TokyoStationModel element in val.station) {
          map4[element.stationName]?.add(element);

          map5[element.stationName] = <String, String>{
            'prev': (j == 0) ? '' : val.station[j - 1].stationName,
            'next': (j == val.station.length - 1) ? '' : val.station[j + 1].stationName,
          };

          j++;
        }
        //----------------------------------------------------------------//
      }

      return state.copyWith(
        tokyoTrainList: list,
        tokyoTrainMap: map,
        tokyoTrainIdMap: map2,
        tokyoStationMap: map3,
        tokyoStationTokyoStationModelListMap: map4,
        tokyoStationNextStationMap: map5,
      );
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllTokyoTrain() async {
    try {
      final TokyoTrainState newState = await fetchAllTokyoTrainData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api

  ///
  void setTrainList({required int trainNumber}) {
    final List<int> list = <int>[...state.selectTrainList];

    if (list.contains(trainNumber)) {
      list.remove(trainNumber);
    } else {
      list.add(trainNumber);
    }

    state = state.copyWith(selectTrainList: list);
  }

  ///
  void clearTrainList() => state = state.copyWith(selectTrainList: <int>[]);
}
