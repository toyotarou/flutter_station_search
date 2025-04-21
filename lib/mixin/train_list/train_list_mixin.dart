import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/app_param/app_param.dart';
import '../../models/station_model.dart';

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
