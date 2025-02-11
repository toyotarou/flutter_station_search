import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/near_station/near_station.dart';
import '../../models/station_extends_model.dart';

mixin NearStationMixin {
  /// 近隣駅の表示パーツを作成する
  Widget nearStationDisplayParts({
    required WidgetRef ref,
    required BuildContext context,
    required String from,
    required double height,
  }) {
    return DefaultTextStyle(
      style: const TextStyle(fontSize: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: height - 60,
            child: displayNearStationList(ref: ref),
          ),
        ],
      ),
    );
  }

  /// 近隣駅リストを表示するウィジェットを作成する
  Widget displayNearStationList({required WidgetRef ref}) {
    final List<Widget> list = <Widget>[];

    final List<StationExtendsModel> stationExtendsList =
        ref.watch(nearStationProvider.select((NearStationState value) => value.stationExtendsList));

    // リストのコピー作成（ソート用）
    final List<StationExtendsModel> stationExList = <StationExtendsModel>[];
    // ignore: prefer_foreach
    for (final StationExtendsModel element in stationExtendsList) {
      stationExList.add(element);
    }

    // 距離順にソートし、Rowウィジェットとしてリストに追加
    stationExList
      ..sort((StationExtendsModel a, StationExtendsModel b) => a.distance.compareTo(b.distance))
      ..forEach((StationExtendsModel element) {
        list.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(element.stationName),
              Text(element.distance.toStringAsFixed(2)),
            ],
          ),
        );
      });

    return SingleChildScrollView(
      child: Column(children: list),
    );
  }
}
