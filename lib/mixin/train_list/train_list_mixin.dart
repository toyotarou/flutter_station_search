import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/app_param/app_param.dart';
import '../../models/station_model.dart';
import '../../models/tokyo_train_model.dart';

mixin TrainListMixin {
  ///
  Widget trainListDisplayParts(
      {required WidgetRef ref,
      required BuildContext context,
      required Map<String, List<StationModel>> trainStationMap,
      required Map<String, TokyoTrainModel> tokyoTrainMap}) {
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

    final List<String> trainNameList = ref.watch(appParamProvider.select((AppParamState value) => value.trainNameList));

    if (limitTokyoTrain) {
      tokyoTrainMap.forEach((String key, TokyoTrainModel value) {
        list.add(Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  ref.read(appParamProvider.notifier).setTrainNameList(trainNumber: value.trainName);
                },
                child: Icon(
                  Icons.location_on,
                  color: (trainNameList.contains(value.trainName)) ? Colors.yellowAccent : Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Text(key),
            ],
          ),
        ));
      });
    } else {
      trainStationMap.forEach((String key, List<StationModel> value) {
        list.add(Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  ref.read(appParamProvider.notifier).setTrainNameList(trainNumber: value[0].lineNumber);
                },
                child: Icon(
                  Icons.location_on,
                  color: (trainNameList.contains(value[0].lineNumber)) ? Colors.yellowAccent : Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Text(key),
            ],
          ),
        ));
      });
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list,
      ),
    );
  }
}
