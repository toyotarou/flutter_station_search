import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/station_model.dart';
import 'near_station_mixin.dart';

class NearStationWidget extends ConsumerWidget with NearStationMixin {
  const NearStationWidget(
      {super.key,
      required this.height,
      required this.context,
      required this.ref,
      required this.from,
      required this.stationModelList,
      required this.spotLatitude,
      required this.spotLongitude,
      required this.setDefaultBoundsMap});

  final BuildContext context;
  final WidgetRef ref;
  final String from;
  final double height;
  final double spotLatitude;
  final double spotLongitude;
  final List<StationModel> stationModelList;
  final VoidCallback setDefaultBoundsMap;

  ///
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return nearStationDisplayParts(
      ref: ref,
      context: context,
      from: 'NearStation',
      height: height,
      spotLatitude: spotLatitude,
      spotLongitude: spotLongitude,
      stationModelList: stationModelList,
      setDefaultBoundsMap: setDefaultBoundsMap,
    );
  }
}
