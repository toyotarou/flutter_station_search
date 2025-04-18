import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/station_model.dart';
import 'train_list_mixin.dart';

class TrainListWidget extends ConsumerWidget with TrainListMixin {
  const TrainListWidget({super.key, required this.context, required this.ref, required this.trainStationMap});

  final BuildContext context;
  final WidgetRef ref;
  final Map<String, List<StationModel>> trainStationMap;

  ///
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return trainListDisplayParts(ref: ref, context: context, trainStationMap: trainStationMap);
  }
}
