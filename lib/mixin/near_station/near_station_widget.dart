import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'near_station_mixin.dart'; // mixinのパスを適宜調整してください

class NearStationWidget extends ConsumerWidget with NearStationMixin {
  const NearStationWidget(
      {super.key, required this.height, required this.context, required this.ref, required this.from});

  final BuildContext context;
  final WidgetRef ref;
  final String from;
  final double height;

  ///
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return nearStationDisplayParts(ref: ref, context: context, from: 'NearStation', height: height);
  }
}
