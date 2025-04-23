import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../controllers/tokyo_train/tokyo_train.dart';
import '../../extensions/extensions.dart';
import '../../models/tokyo_station_model.dart';
import '../../utility/utility.dart';

class BusInfoListDisplayAlert extends ConsumerStatefulWidget {
  const BusInfoListDisplayAlert({
    super.key,
    required this.busInfo,
    required this.height,
    required this.selectedStationLatLng,
  });

  final List<String> busInfo;
  final double height;
  final LatLng selectedStationLatLng;

  @override
  ConsumerState<BusInfoListDisplayAlert> createState() => _BusInfoListDisplayAlertState();
}

class _BusInfoListDisplayAlertState extends ConsumerState<BusInfoListDisplayAlert> {
  Utility utility = Utility();

  ///
  @override
  Widget build(BuildContext context) =>
      Column(children: <Widget>[SizedBox(height: widget.height * 0.8, child: displayBusInfoList())]);

  ///
  Widget displayBusInfoList() {
    final Map<String, List<TokyoStationModel>> tokyoStationTokyoStationModelListMap =
        ref.watch(tokyoTrainProvider.select((TokyoTrainState value) => value.tokyoStationTokyoStationModelListMap));

    final List<Widget> list = <Widget>[];

    List<String> roopData = widget.busInfo;

    if (widget.busInfo.isEmpty) {
      roopData = <String>['no bus data'];
    }

    for (final String element in roopData) {
      if (tokyoStationTokyoStationModelListMap[element] != null) {
        var distance = utility.calcDistance(
          originLat: widget.selectedStationLatLng.latitude,
          originLng: widget.selectedStationLatLng.longitude,
          destLat: tokyoStationTokyoStationModelListMap[element]![0].lat.toDouble(),
          destLng: tokyoStationTokyoStationModelListMap[element]![0].lng.toDouble(),
        );

        if (distance != '') {
          list.add(
            DefaultTextStyle(
              style: const TextStyle(fontSize: 12),
              child: Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.symmetric(vertical: 1),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
                  color: Colors.black.withOpacity(0.3),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(element),
                    Text(distance.toDouble().toStringAsFixed(2)),
                  ],
                ),
              ),
            ),
          );
        }
      }
    }

    return SingleChildScrollView(child: Column(children: list));
  }
}
