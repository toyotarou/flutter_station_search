import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/http/client.dart';
import '../../extensions/extensions.dart';
import '../../models/bus_info_model.dart';
import '../../utility/utility.dart';

part 'bus_info.freezed.dart';

part 'bus_info.g.dart';

@freezed
class BusInfoState with _$BusInfoState {
  const factory BusInfoState({
    @Default(<BusInfoModel>[]) List<BusInfoModel> busInfoList,
    @Default(<String, List<String>>{}) Map<String, List<String>> busInfoMap,
  }) = _BusInfoState;
}

@Riverpod(keepAlive: true)
class BusInfo extends _$BusInfo {
  final Utility utility = Utility();

  ///
  @override
  BusInfoState build() => const BusInfoState();

  ///
  Future<BusInfoState> fetchBusInfoData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final dynamic value = await client.getByPath(path: 'http://49.212.175.205:3000/api/v1/bus');

      final List<BusInfoModel> list = <BusInfoModel>[];
      final Map<String, List<String>> map = <String, List<String>>{};

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value.length.toString().toInt(); i++) {
        // ignore: avoid_dynamic_calls
        final BusInfoModel val = BusInfoModel.fromJson(value[i] as Map<String, dynamic>);

        list.add(val);

        map[val.endA] = <String>[];

        map[val.endB] = <String>[];
      }

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value.length.toString().toInt(); i++) {
        // ignore: avoid_dynamic_calls
        final BusInfoModel val = BusInfoModel.fromJson(value[i] as Map<String, dynamic>);

        map[val.endA]?.add(val.endB);

        map[val.endB]?.add(val.endA);
      }

      return state.copyWith(busInfoList: list, busInfoMap: map);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getBusInfoData() async {
    try {
      final BusInfoState newState = await fetchBusInfoData();

      state = newState;
    } catch (_) {}
  }
}
