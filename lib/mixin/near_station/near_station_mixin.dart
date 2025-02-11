import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../controllers/app_param/app_param.dart';
import '../../extensions/extensions.dart';
import '../../models/station_extends_model.dart';
import '../../models/station_model.dart';
import '../../utility/utility.dart';

mixin NearStationMixin {
  ///
  Widget nearStationDisplayParts(
      {required WidgetRef ref,
      required BuildContext context,
      required String from,
      required double height,
      required List<StationModel> stationModelList,
      required double spotLatitude,
      required double spotLongitude}) {
    return DefaultTextStyle(
      style: const TextStyle(fontSize: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: height - 60,
            child: displayNearStationList(
              ref: ref,
              spotLatitude: spotLatitude,
              spotLongitude: spotLongitude,
              stationModelList: stationModelList,
            ),
          ),
        ],
      ),
    );
  }

  ///
  Widget displayNearStationList(
      {required WidgetRef ref,
      required List<StationModel> stationModelList,
      required double spotLatitude,
      required double spotLongitude}) {
    final Utility utility = Utility();

    final List<Widget> list = <Widget>[];

    final List<StationExtendsModel> list2 = <StationExtendsModel>[];

    for (final StationModel element in stationModelList) {
      final String di = utility.calcDistance(
          originLat: spotLatitude,
          originLng: spotLongitude,
          destLat: element.lat.toDouble(),
          destLng: element.lng.toDouble());

      final double dis = di.toDouble() * 1000;

      list2.add(StationExtendsModel.fromStation(station: element, distance: dis));
    }

    list2
      ..sort((StationExtendsModel a, StationExtendsModel b) => a.distance.compareTo(b.distance))
      ..forEach((StationExtendsModel element) {
        list.add(
          Container(
            padding: const EdgeInsets.symmetric(vertical: 3),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        ref
                            .read(appParamProvider.notifier)
                            .setSelectedStationLatLng(latlng: LatLng(element.lat.toDouble(), element.lng.toDouble()));
                      },
                      child: Icon(Icons.location_on, color: Colors.white.withOpacity(0.5)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Text(element.stationName, maxLines: 1, overflow: TextOverflow.ellipsis)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(),
                    Container(
                      alignment: Alignment.topRight,
                      child: Text('${element.distance.toStringAsFixed(0)} m'),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(child: Container(alignment: Alignment.topRight, child: Text(element.lineName))),
                    const SizedBox(width: 10),
                    Icon(Icons.train, color: Colors.white.withOpacity(0.5)),
                  ],
                ),
              ],
            ),
          ),
        );
      });

    return SingleChildScrollView(child: Column(children: list));
  }
}
