import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/station_model.dart';
import '../../models/tokyo_train_model.dart';
import 'train_list_mixin.dart';

class TrainListWidget extends ConsumerWidget with TrainListMixin {
  const TrainListWidget(
      {super.key,
      required this.context,
      required this.ref,
      required this.trainStationMap,
      required this.tokyoTrainMap});

  final BuildContext context;
  final WidgetRef ref;
  final Map<String, List<StationModel>> trainStationMap;
  final Map<String, TokyoTrainModel> tokyoTrainMap;

  ///
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return trainListDisplayParts(
      ref: ref,
      context: context,
      trainStationMap: trainStationMap,
      tokyoTrainMap: tokyoTrainMap,
    );
  }
}
