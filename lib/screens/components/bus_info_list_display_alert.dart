import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../extensions/extensions.dart';
import '../../models/station_extends_model.dart';
import '../../models/tokyo_station_model.dart';
import '../../utility/utility.dart';

class BusInfoListDisplayAlert extends ConsumerStatefulWidget {
  const BusInfoListDisplayAlert({
    super.key,
    required this.busInfo,
    required this.height,
    required this.selectedStationLatLng,
    required this.tokyoStationTokyoStationModelListMap,
  });

  final List<String> busInfo;
  final double height;
  final LatLng selectedStationLatLng;
  final Map<String, List<TokyoStationModel>> tokyoStationTokyoStationModelListMap;

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
    final List<Widget> list = <Widget>[];

    List<String> roopData = widget.busInfo;

    if (widget.busInfo.isEmpty) {
      roopData = <String>['no bus data'];
    }

    final List<StationExtendsModel> busStationList = <StationExtendsModel>[];

    for (final String element in roopData) {
      if (widget.tokyoStationTokyoStationModelListMap[element] != null) {
        final String distance = utility.calcDistance(
          originLat: widget.selectedStationLatLng.latitude,
          originLng: widget.selectedStationLatLng.longitude,
          destLat: widget.tokyoStationTokyoStationModelListMap[element]![0].lat.toDouble(),
          destLng: widget.tokyoStationTokyoStationModelListMap[element]![0].lng.toDouble(),
        );

        if (distance != '') {
          busStationList.add(
            StationExtendsModel(
              id: 0,
              stationName: widget.tokyoStationTokyoStationModelListMap[element]![0].stationName,
              address: widget.tokyoStationTokyoStationModelListMap[element]![0].address,
              lat: widget.tokyoStationTokyoStationModelListMap[element]![0].lat,
              lng: widget.tokyoStationTokyoStationModelListMap[element]![0].lng,
              lineNumber: '',
              lineName: '',
              distance: distance.toDouble(),
            ),
          );
        }
      }
    }

    if (busStationList.isEmpty) {
      return const Text('no bus data');
    }

    busStationList
      ..sort((StationExtendsModel a, StationExtendsModel b) => a.distance.compareTo(b.distance) * -1)
      ..forEach((StationExtendsModel element) {
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
                  Text(element.stationName),
                  Text(element.distance.toStringAsFixed(2)),
                ],
              ),
            ),
          ),
        );
      });

    return SingleChildScrollView(child: Column(children: list));
  }
}
