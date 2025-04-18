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
      required double spotLongitude,
      required VoidCallback setDefaultBoundsMap}) {
    return DefaultTextStyle(
      style: const TextStyle(fontSize: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: height - 230,
            child: displayTrainList(
              ref: ref,
              spotLatitude: spotLatitude,
              spotLongitude: spotLongitude,
              stationModelList: stationModelList,
              setDefaultBoundsMap: setDefaultBoundsMap,
            ),
          ),
          Divider(color: Colors.white.withOpacity(0.3), thickness: 5),
          SizedBox(
            height: height - 140,
            child: displayNearStationList(
              ref: ref,
              spotLatitude: spotLatitude,
              spotLongitude: spotLongitude,
              stationModelList: stationModelList,
              setDefaultBoundsMap: setDefaultBoundsMap,
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
      required double spotLongitude,
      required VoidCallback setDefaultBoundsMap}) {
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

    final LatLng? selectedStationLatLng =
        ref.watch(appParamProvider.select((AppParamState value) => value.selectedStationLatLng));

    final String selectedLineNumber =
        ref.watch(appParamProvider.select((AppParamState value) => value.selectedLineNumber));

    final List<int> keepStation = <int>[];

    list2
      ..sort((StationExtendsModel a, StationExtendsModel b) => a.distance.compareTo(b.distance))
      ..forEach((StationExtendsModel element) {
        if (!keepStation.contains(element.id)) {
          list.add(
            Stack(
              children: <Widget>[
                Positioned(
                  top: 5,
                  right: 5,
                  child: Transform(
                    transform: Matrix4.diagonal3Values(1.0, 3.0, 1.0),
                    child: Text(
                      element.id.toString(),
                      style: TextStyle(color: Colors.white.withOpacity(0.6)),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
                    color: Colors.black.withOpacity(0.3),
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              ref.read(appParamProvider.notifier).setSelectedStationLatLng(
                                  latlng: LatLng(element.lat.toDouble(), element.lng.toDouble()));

                              setDefaultBoundsMap();
                            },
                            child: Icon(Icons.location_on,
                                color: ((selectedStationLatLng != null) &&
                                        ((selectedStationLatLng.latitude == element.lat.toDouble()) &&
                                            (selectedStationLatLng.longitude == element.lng.toDouble())))
                                    ? Colors.yellowAccent.withOpacity(0.5)
                                    : Colors.white.withOpacity(0.5)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: Text(element.stationName, maxLines: 1, overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const SizedBox.shrink(),
                          Container(
                            alignment: Alignment.topRight,
                            child: Text(
                              '${element.distance.toStringAsFixed(0)} m',
                              style: TextStyle(
                                  color: ((selectedStationLatLng != null) &&
                                          ((selectedStationLatLng.latitude == element.lat.toDouble()) &&
                                              (selectedStationLatLng.longitude == element.lng.toDouble())))
                                      ? Colors.yellowAccent
                                      : Colors.white),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(child: Container(alignment: Alignment.topRight, child: Text(element.lineName))),
                          const SizedBox(width: 10),
                          Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  ref
                                      .read(appParamProvider.notifier)
                                      .setSelectedLineNumber(lineNumber: element.lineNumber);

                                  setDefaultBoundsMap();
                                },
                                child: Icon(Icons.train,
                                    color: (element.lineNumber == selectedLineNumber)
                                        ? Colors.yellowAccent.withOpacity(0.5)
                                        : Colors.white.withOpacity(0.5)),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  ref.read(appParamProvider.notifier).setSelectedLineNumber(lineNumber: '');

                                  setDefaultBoundsMap();
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        keepStation.add(element.id);
      });

    return SingleChildScrollView(child: Column(children: list));
  }

  ///
  Widget displayTrainList(
      {required WidgetRef ref,
      required List<StationModel> stationModelList,
      required double spotLatitude,
      required double spotLongitude,
      required VoidCallback setDefaultBoundsMap}) {
    final Utility utility = Utility();

    final List<Widget> list = <Widget>[];

    final List<String> list3 = <String>[];

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

    final String selectedLineNumber =
        ref.watch(appParamProvider.select((AppParamState value) => value.selectedLineNumber));

    list2
      ..sort((StationExtendsModel a, StationExtendsModel b) => a.distance.compareTo(b.distance))
      ..forEach((StationExtendsModel element) {
        if (!list3.contains(element.lineName)) {
          list3.add(element.lineName);

          list.add(Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
              color: Colors.black.withOpacity(0.3),
            ),
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    ref.read(appParamProvider.notifier).setSelectedLineNumber(lineNumber: element.lineNumber);

                    setDefaultBoundsMap();
                  },
                  child: Icon(Icons.train,
                      color: (element.lineNumber == selectedLineNumber)
                          ? Colors.yellowAccent.withOpacity(0.5)
                          : Colors.white.withOpacity(0.5)),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(element.lineName, maxLines: 1, overflow: TextOverflow.ellipsis)),
              ],
            ),
          ));
        }
      });

    return SingleChildScrollView(child: Column(children: list));
  }
}
