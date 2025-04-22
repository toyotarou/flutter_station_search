import 'package:flutter/material.dart';

class BusInfoListDisplayAlert extends StatefulWidget {
  const BusInfoListDisplayAlert(
      {super.key, required this.busInfo, required this.setDefaultBoundsMap, required this.height});

  final List<String> busInfo;
  final VoidCallback setDefaultBoundsMap;

  final double height;

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

    for (final String element in widget.busInfo) {
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
              children: <Widget>[
                Icon(Icons.location_on, color: Colors.white.withOpacity(0.5)),
                const SizedBox(width: 10),
                Text(element),
              ],
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(child: Column(children: list));
  }
}
