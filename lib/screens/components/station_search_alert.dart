import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/station_model.dart';

class StationSearchAlert extends ConsumerStatefulWidget {
  const StationSearchAlert({super.key});

  @override
  ConsumerState<StationSearchAlert> createState() => _StationSearchAlertState();
}

class _StationSearchAlertState extends ConsumerState<StationSearchAlert> with ControllersMixin<StationSearchAlert> {
  final TextEditingController _stationNameEditingController = TextEditingController();

  ///
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: double.infinity,
        child: DefaultTextStyle(
          style: GoogleFonts.kiwiMaru(fontSize: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              Container(width: context.screenSize.width),
              const Text('Station Search'),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _stationNameEditingController,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                        hintText: '駅名',
                        filled: true,
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                      ),
                      style: const TextStyle(fontSize: 13, color: Colors.white),
                      onTapOutside: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
                    ),
                  ),
                  IconButton(onPressed: () => setState(() {}), icon: const Icon(Icons.search))
                ],
              ),
              Expanded(child: displayStationSearchResult()),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget displayStationSearchResult() {
    if (_stationNameEditingController.text.trim().isEmpty) {
      return Container();
    }

    final List<Widget> list = <Widget>[];

    final RegExp reg = RegExp(_stationNameEditingController.text.trim());

    final List<StationModel> roopList = List<StationModel>.from(stationState.stationList);

    roopList
      ..sort((StationModel a, StationModel b) =>
          '${a.stationName}|${a.lineName}'.compareTo('${b.stationName}|${b.lineName}'))
      ..forEach((StationModel element) {
        if (reg.firstMatch(element.stationName) != null) {
          list.add(Container(
            padding: const EdgeInsets.symmetric(vertical: 3),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(element.stationName),
                    Container(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(element.lineName),
                        Text(element.address),
                        Text(
                          '${element.lat} / ${element.lng}',
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ));
        }
      });

    return SingleChildScrollView(child: Column(children: list));
  }
}
