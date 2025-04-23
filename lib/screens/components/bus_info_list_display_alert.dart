import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../extensions/extensions.dart';

class BusInfoListDisplayAlert extends StatefulWidget {
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
  State<BusInfoListDisplayAlert> createState() => _BusInfoListDisplayAlertState();
}

class _BusInfoListDisplayAlertState extends State<BusInfoListDisplayAlert> {
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

    for (final String element in roopData) {
      const String distance = '';

      // if (widget.stationStationModelListMap[element] != null) {
      //   distance = utility.calcDistance(
      //     originLat: widget.selectedStationLatLng.latitude,
      //     originLng: widget.selectedStationLatLng.longitude,
      //     destLat: widget.stationStationModelListMap[element]![0].lat.toDouble(),
      //     destLng: widget.stationStationModelListMap[element]![0].lng.toDouble(),
      //   );
      // }

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
                Text((distance == '') ? '' : distance.toDouble().toStringAsFixed(2)),
              ],
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(child: Column(children: list));
  }
}
