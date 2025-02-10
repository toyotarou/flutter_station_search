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
  }) = _TokyoTrainState;
}

@Riverpod(keepAlive: true)
class TokyoTrain extends _$TokyoTrain {
  final Utility utility = Utility();

  ///
  @override
  TokyoTrainState build() => const TokyoTrainState();

  ///
  Future<TokyoTrainState> fetchTokyoTrainData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final dynamic value = await client.post(path: APIPath.getTokyoTrainStation);

      final List<TokyoTrainModel> list = <TokyoTrainModel>[];
      final Map<String, TokyoTrainModel> map = <String, TokyoTrainModel>{};
      final Map<int, TokyoTrainModel> idMap = <int, TokyoTrainModel>{};
      final Map<String, TokyoStationModel> stationMap = <String, TokyoStationModel>{};

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
        final TokyoTrainModel val = TokyoTrainModel.fromJson(
          // ignore: avoid_dynamic_calls
          value['data'][i] as Map<String, dynamic>,
        );

        list.add(val);
        map[val.trainName] = val;

        idMap[val.trainNumber] = val;

        for (final TokyoStationModel element in val.station) {
          stationMap[element.id] = element;
        }
      }

      return state.copyWith(
          tokyoTrainList: list, tokyoTrainMap: map, tokyoStationMap: stationMap, tokyoTrainIdMap: idMap);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getTokyoTrainData() async {
    try {
      final TokyoTrainState newState = await fetchTokyoTrainData();

      state = newState;
    } catch (_) {}
  }
}
