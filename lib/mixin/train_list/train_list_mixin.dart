import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/app_param/app_param.dart';
import '../../models/station_model.dart';
import '../../utility/utility.dart';

mixin TrainListMixin {
  ///
  Widget trainListDisplayParts(
      {required WidgetRef ref,
      required BuildContext context,
      required Map<String, List<StationModel>> trainStationMap}) {
    final List<Widget> list = <Widget>[];

    final bool limitTokyoTrain = ref.watch(appParamProvider.select((AppParamState value) => value.limitTokyoTrain));

    list.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const SizedBox.shrink(),
          TextButton(
            onPressed: () {
              ref.read(appParamProvider.notifier).setLimitTokyoTrain(flag: !limitTokyoTrain);
            },
            child: Text(
              'select tokyo train',
              style: TextStyle(color: limitTokyoTrain ? Colors.yellowAccent : Colors.white),
            ),
          ),
        ],
      ),
    );

    ///////////////////////////////

    final List<int> stationIdList = <int>[];

    final Utility utility = Utility();

    final List<String> tokyoWard = utility.getTokyoWard();

    trainStationMap.forEach((String key, List<StationModel> value) {
      for (final String element2 in tokyoWard) {
        final RegExp reg = RegExp(element2);

        for (final StationModel element in value) {
          if (reg.firstMatch(element.address) != null) {
            stationIdList.add(element.id);
          }
        }
      }
    });

    final List<String> tokyoCity = utility.getTokyoCity();

    trainStationMap.forEach((String key, List<StationModel> value) {
      for (final String element2 in tokyoCity) {
        final RegExp reg = RegExp(element2);

        for (final StationModel element in value) {
          if (reg.firstMatch(element.address) != null) {
            if (!stationIdList.contains(element.id)) {
              stationIdList.add(element.id);
            }
          }
        }
      }
    });

    ///////////////////////////////

    trainStationMap.forEach((String key, List<StationModel> value) {
      list.add(Text(key));
    });

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list,
      ),
    );
  }
}
