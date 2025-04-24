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
    required this.nextStationMap,
  });

  final List<String> busInfo;
  final double height;
  final LatLng selectedStationLatLng;
  final Map<String, List<TokyoStationModel>> tokyoStationTokyoStationModelListMap;
  final List<Map<String, String>> nextStationMap;

  @override
  ConsumerState<BusInfoListDisplayAlert> createState() => _BusInfoListDisplayAlertState();
}

class _BusInfoListDisplayAlertState extends ConsumerState<BusInfoListDisplayAlert> {
  Utility utility = Utility();

  ///
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          bottom: 30,
          right: 5,
          child: Transform(
            transform: Matrix4.diagonal3Values(1.0, 3.0, 1.0),
            child: Text('BUS', style: TextStyle(color: Colors.white.withOpacity(0.6))),
          ),
        ),
        Column(
          children: <Widget>[
            SizedBox(
              height: widget.height * 0.8,
              child: displayBusInfoList(),
            ),
          ],
        ),
      ],
    );
  }

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
              distance: distance.toDouble() * 1000,
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
        final List<String> nextStation = <String>[];
        for (final Map<String, String> element2 in widget.nextStationMap) {
          element2.forEach((String key, String value) {
            if (value != '') {
              nextStation.add(value);
            }
          });
        }

        list.add(
          DefaultTextStyle(
            style: const TextStyle(fontSize: 12),
            child: Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.symmetric(vertical: 1),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
                color: (nextStation.contains(element.stationName))
                    ? Colors.blueGrey.withOpacity(0.3)
                    : Colors.black.withOpacity(0.3),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(element.stationName),
                  Text('${element.distance.toStringAsFixed(0)} m'),
                ],
              ),
            ),
          ),
        );
      });

    return SingleChildScrollView(child: Column(children: list));
  }
}
