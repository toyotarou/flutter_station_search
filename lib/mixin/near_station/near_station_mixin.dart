import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../controllers/app_param/app_param.dart';
import '../../controllers/bus_info/bus_info.dart';
import '../../controllers/tokyo_train/tokyo_train.dart';
import '../../extensions/extensions.dart';
import '../../models/station_extends_model.dart';
import '../../models/station_model.dart';
import '../../models/tokyo_station_model.dart';
import '../../screens/components/bus_info_list_display_alert.dart';

import '../../screens/parts/station_search_overlay.dart';
import '../../utility/utility.dart';
import 'near_station_widget.dart';

mixin NearStationMixin on ConsumerState<NearStationWidget> {
  final List<OverlayEntry> _secondEntries = <OverlayEntry>[];

  ///
  Widget nearStationDisplayParts({
    required WidgetRef ref,
    required BuildContext context,
    required String from,
    required double height,
    required List<StationModel> stationModelList,
    required double spotLatitude,
    required double spotLongitude,
    required VoidCallback setDefaultBoundsMap,
  }) {
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
              context: context,
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
  Widget displayNearStationList({
    required WidgetRef ref,
    required BuildContext context,
    required List<StationModel> stationModelList,
    required double spotLatitude,
    required double spotLongitude,
    required VoidCallback setDefaultBoundsMap,
  }) {
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

    final Map<String, List<String>> busInfoMap =
        ref.watch(busInfoProvider.select((BusInfoState value) => value.busInfoMap));

    final AppParam appParamNotifier = ref.read(appParamProvider.notifier);

    final Map<String, List<TokyoStationModel>> tokyoStationTokyoStationModelListMap =
        ref.watch(tokyoTrainProvider.select((TokyoTrainState value) => value.tokyoStationTokyoStationModelListMap));

    final Map<String, List<Map<String, String>>> tokyoStationNextStationMap =
        ref.watch(tokyoTrainProvider.select((TokyoTrainState value) => value.tokyoStationNextStationMap));

    final String selectedBusRouteStartStation =
        ref.watch(appParamProvider.select((AppParamState value) => value.selectedBusRouteStartStation));

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
                      GestureDetector(
                        onTap: () {
                          ref
                              .read(appParamProvider.notifier)
                              .setSelectedStationLatLng(latlng: LatLng(element.lat.toDouble(), element.lng.toDouble()));

                          appParamNotifier.setSecondOverlayParams(secondEntries: _secondEntries);

                          addSecondOverlay(
                            context: context,
                            secondEntries: _secondEntries,
                            setStateCallback: setState,
                            width: context.screenSize.width * 0.5,
                            height: context.screenSize.height * 0.3,
                            color: Colors.blueGrey.withOpacity(0.3),
                            initialPosition: Offset(context.screenSize.width * 0.5, context.screenSize.height * 0.6),
                            onPositionChanged: (Offset newPos) => appParamNotifier.updateOverlayPosition(newPos),
                            widget: BusInfoListDisplayAlert(
                              busInfo: busInfoMap[element.stationName] ?? <String>[],
                              height: context.screenSize.height * 0.3,
                              selectedStationLatLng: LatLng(element.lat.toDouble(), element.lng.toDouble()),
                              tokyoStationTokyoStationModelListMap: tokyoStationTokyoStationModelListMap,
                              nextStationMap:
                                  tokyoStationNextStationMap[element.stationName] ?? <Map<String, String>>[],
                            ),
                          );

                          setDefaultBoundsMap();
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              color: ((selectedStationLatLng != null) &&
                                      ((selectedStationLatLng.latitude == element.lat.toDouble()) &&
                                          (selectedStationLatLng.longitude == element.lng.toDouble())))
                                  ? Colors.yellowAccent.withOpacity(0.5)
                                  : Colors.white.withOpacity(0.5),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                element.stationName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: ((selectedStationLatLng != null) &&
                                          ((selectedStationLatLng.latitude == element.lat.toDouble()) &&
                                              (selectedStationLatLng.longitude == element.lng.toDouble())))
                                      ? Colors.yellowAccent
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const SizedBox.shrink(),
                          Text(element.lineName),
                        ],
                      ),
                      const SizedBox(height: 5),
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
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const SizedBox.shrink(),
                          Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  if (selectedStationLatLng == null) {
                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.black.withOpacity(0.5),
                                        content: const Text(
                                          'select bus route start station',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        action: SnackBarAction(
                                          label: 'close',
                                          onPressed: () => ScaffoldMessenger.of(context).clearSnackBars(),
                                        ),
                                      ),
                                    );

                                    return;
                                  }

                                  if (selectedBusRouteStartStation == element.stationName) {
                                    ref.read(appParamProvider.notifier).clearBusRouteStartStation();
                                    return;
                                  }

                                  final List<StationExtendsModel> busStationList = <StationExtendsModel>[];

                                  if (busInfoMap[element.stationName] != null) {
                                    for (final String element2 in busInfoMap[element.stationName]!) {
                                      if (tokyoStationTokyoStationModelListMap[element2] != null) {
                                        final String distance = utility.calcDistance(
                                          originLat: element.lat.toDouble(),
                                          originLng: element.lng.toDouble(),
                                          destLat: tokyoStationTokyoStationModelListMap[element2]![0].lat.toDouble(),
                                          destLng: tokyoStationTokyoStationModelListMap[element2]![0].lng.toDouble(),
                                        );

                                        if (distance != '') {
                                          busStationList.add(
                                            StationExtendsModel(
                                              id: 0,
                                              stationName:
                                                  tokyoStationTokyoStationModelListMap[element2]![0].stationName,
                                              address: tokyoStationTokyoStationModelListMap[element2]![0].address,
                                              lat: tokyoStationTokyoStationModelListMap[element2]![0].lat,
                                              lng: tokyoStationTokyoStationModelListMap[element2]![0].lng,
                                              lineNumber: '',
                                              lineName: '',
                                              distance: distance.toDouble(),
                                            ),
                                          );
                                        }
                                      }
                                    }
                                  }

                                  ref.read(appParamProvider.notifier).setBusRouteStartStation(
                                        busRouteStartStation: element.stationName,
                                        busRouteGoalStationList: busStationList,
                                      );
                                },
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.directions_bus,
                                      color: (element.stationName == selectedBusRouteStartStation)
                                          ? const Color(0xFFFBB6CE).withOpacity(0.5)
                                          : Colors.white.withOpacity(0.5),
                                    ),
                                    Text(
                                      'BUS',
                                      style: TextStyle(
                                        color: (element.stationName == selectedBusRouteStartStation)
                                            ? const Color(0xFFFBB6CE)
                                            : Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  ref.read(appParamProvider.notifier).setSelectedLineNumber(
                                        lineNumber:
                                            (element.lineNumber == selectedLineNumber) ? '' : element.lineNumber,
                                      );

                                  setDefaultBoundsMap();
                                },
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.train,
                                      color: (element.lineNumber == selectedLineNumber)
                                          ? Colors.yellowAccent.withOpacity(0.5)
                                          : Colors.white.withOpacity(0.5),
                                    ),
                                    Text(
                                      'TRAIN',
                                      style: TextStyle(
                                        color: (element.lineNumber == selectedLineNumber)
                                            ? Colors.yellowAccent
                                            : Colors.white,
                                      ),
                                    ),
                                  ],
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
      ..forEach(
        (StationExtendsModel element) {
          if (!list3.contains(element.lineName)) {
            list3.add(element.lineName);

            list.add(
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
                  color: Colors.black.withOpacity(0.3),
                ),
                child: GestureDetector(
                  onTap: () {
                    ref.read(appParamProvider.notifier).setSelectedLineNumber(
                          lineNumber: (element.lineNumber == selectedLineNumber) ? '' : element.lineNumber,
                        );

                    setDefaultBoundsMap();
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.train,
                        color: (element.lineNumber == selectedLineNumber)
                            ? Colors.yellowAccent.withOpacity(0.5)
                            : Colors.white.withOpacity(0.5),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          element.lineName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: (element.lineNumber == selectedLineNumber) ? Colors.yellowAccent : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      );

    return SingleChildScrollView(child: Column(children: list));
  }
}
