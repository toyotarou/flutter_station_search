import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../controllers/controllers_mixin.dart';
import '../extensions/extensions.dart';
import '../mixin/near_station/near_station_widget.dart';
import '../mixin/train_list/train_list_widget.dart';
import '../models/station_model.dart';
import '../models/tokyo_station_model.dart';
import '../utility/tile_provider.dart';
import '../utility/utility.dart';
import 'components/station_search_alert.dart';
import 'parts/station_dialog.dart';
import 'parts/station_search_overlay.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with ControllersMixin<HomeScreen> {
  String _locationMessage = '位置情報が取得されていません。';

  double spotLatitude = 0;
  double spotLongitude = 0;

  final MapController mapController = MapController();

  double currentZoomEightTeen = 18;

  Utility utility = Utility();

  final List<OverlayEntry> _firstEntries = <OverlayEntry>[];

  final List<OverlayEntry> _secondEntries = <OverlayEntry>[];

  List<StationModel> stationModelList = <StationModel>[];

  List<Marker> lineStationMarkerList = <Marker>[];

  List<LatLng> linePolylineList = <LatLng>[];

  int searchRadius = 2;

  List<Polyline<Object>> selectTrainPolylinesList = <Polyline<Object>>[];

  List<Marker> selectTrainStationMarkerList = <Marker>[];

  ///
  Future<void> _getCurrentLocation() async {
    try {
      final Position position = await _determinePosition();

      setState(() {
        spotLatitude = position.latitude;
        spotLongitude = position.longitude;
      });

      mapController.move(LatLng(spotLatitude, spotLongitude), 13);

      makeStationModelList();
    } catch (e) {
      setState(() => _locationMessage = '位置情報の取得に失敗しました。\n$e');
    }
  }

  ///
  void makeStationModelList() {
    for (final StationModel element in stationState.stationList) {
      final String di = utility.calcDistance(
        originLat: spotLatitude,
        originLng: spotLongitude,
        destLat: element.lat.toDouble(),
        destLng: element.lng.toDouble(),
      );

      final double dis = di.toDouble() * 1000;

      if (dis <= (searchRadius * 1000)) {
        stationModelList.add(element);
      }
    }
  }

  ///
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      // ignore: always_specify_types
      return Future.error('位置情報サービスが無効です。');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        // ignore: always_specify_types
        return Future.error('位置情報の権限が拒否されています。');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // ignore: always_specify_types
      return Future.error('位置情報の権限が「常に拒否」に設定されています。');
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 100),
    );
  }

  ///
  @override
  void initState() {
    super.initState();

    stationNotifier.getStationData();

    tokyoTrainNotifier.getAllTokyoTrain();

    busIntoNotifier.getBusInfoData();
  }

  ///
  @override
  Widget build(BuildContext context) {
    if (appParamState.selectedLineNumber != '') {
      makeLineStationMarkerList();
    } else {
      lineStationMarkerList.clear();
      linePolylineList.clear();
    }

    makeSelectTrainPolylineList();

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: const LatLng(35.718532, 139.586639),
                initialZoom: currentZoomEightTeen,
              ),
              children: <Widget>[
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  tileProvider: CachedTileProvider(),
                  userAgentPackageName: 'com.example.app',
                ),
                if (spotLatitude != 0 && spotLongitude != 0)
                  MarkerLayer(
                    markers: <Marker>[
                      Marker(
                        point: LatLng(spotLatitude, spotLongitude),
                        child: const Icon(Icons.location_on, color: Colors.redAccent),
                      ),
                      if (appParamState.selectedStationLatLng != null) ...<Marker>[
                        Marker(
                          point: appParamState.selectedStationLatLng!,
                          child: const Icon(Icons.location_on, color: Colors.blueAccent),
                        ),
                      ],
                    ],
                  ),
                if ((spotLatitude > 0 && spotLongitude > 0) &&
                    (appParamState.selectedStationLatLng != null)) ...<Widget>[
                  // ignore: always_specify_types
                  PolylineLayer(
                    polylines: <Polyline<Object>>[
                      // ignore: always_specify_types
                      Polyline(
                        points: <LatLng>[LatLng(spotLatitude, spotLongitude), appParamState.selectedStationLatLng!],
                        color: Colors.redAccent.withOpacity(0.4),
                        strokeWidth: 5,
                      ),

                      if (linePolylineList.isNotEmpty) ...<Polyline<Object>>[
                        // ignore: always_specify_types
                        Polyline(points: linePolylineList, color: Colors.green.withOpacity(0.4), strokeWidth: 10),
                      ],
                    ],
                  ),
                ],
                if (lineStationMarkerList.isNotEmpty) ...<Widget>[MarkerLayer(markers: lineStationMarkerList)],
                if (selectTrainPolylinesList.isNotEmpty) ...<Widget>[
                  // ignore: always_specify_types
                  PolylineLayer(polylines: selectTrainPolylinesList),

                  MarkerLayer(markers: selectTrainStationMarkerList),
                ],
              ],
            ),
            if (spotLatitude == 0 && spotLongitude == 0) ...<Widget>[
              Positioned(
                top: 5,
                right: 5,
                child: SizedBox(
                  width: context.screenSize.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const SizedBox.shrink(),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
                        child: IconButton(
                          onPressed: () {
                            StationDialog(
                              context: context,
                              widget: const StationSearchAlert(),
                            );
                          },
                          icon: const Icon(Icons.search),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (spotLatitude > 0 && spotLongitude > 0) ...<Widget>[
              Positioned(
                top: 5,
                left: 5,
                child: SizedBox(
                  width: context.screenSize.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
                            child: IconButton(
                              onPressed: () {
                                appParamNotifier.clearSelectedStationLatLng();

                                appParamNotifier.setSelectedLineNumber(lineNumber: '');

                                Offset initialPosition =
                                    Offset(context.screenSize.width * 0.5, context.screenSize.height * 0.15);

                                if (appParamState.overlayPosition != null) {
                                  initialPosition = appParamState.overlayPosition!;
                                }

                                const double height = 300;

                                addFirstOverlay(
                                  context: context,
                                  firstEntries: _firstEntries,
                                  setStateCallback: setState,
                                  width: context.screenSize.width * 0.5,
                                  height: height,
                                  color: Colors.blueGrey.withOpacity(0.3),
                                  initialPosition: initialPosition,
                                  widget: Consumer(
                                    builder: (BuildContext context, WidgetRef ref, Widget? child) {
                                      return NearStationWidget(
                                        context: context,
                                        ref: ref,
                                        from: 'HomeScreen',
                                        height: height,
                                        spotLatitude: spotLatitude,
                                        spotLongitude: spotLongitude,
                                        stationModelList: stationModelList,
                                        setDefaultBoundsMap: setDefaultBoundsMap,
                                        stationStationModelListMap: stationState.stationStationModelListMap,
                                      );
                                    },
                                  ),
                                  onPositionChanged: (Offset newPos) => appParamNotifier.updateOverlayPosition(newPos),
                                  secondEntries: _secondEntries,
                                  ref: ref,
                                  from: 'HomeScreen',
                                );
                              },
                              icon: const Icon(Icons.train),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
                            child: IconButton(
                              onPressed: () => mapController.rotate(0),
                              icon: const Icon(Icons.compass_calibration),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
                            child: IconButton(
                              onPressed: () {
                                appParamNotifier.clearTrainNameList();

                                addSecondOverlay(
                                  context: context,
                                  secondEntries: _secondEntries,
                                  setStateCallback: setState,
                                  width: context.screenSize.width,
                                  height: context.screenSize.height * 0.3,
                                  color: Colors.blueGrey.withOpacity(0.3),
                                  initialPosition: Offset(0, context.screenSize.height * 0.7),
                                  widget: Consumer(
                                    builder: (BuildContext context, WidgetRef ref, Widget? child) {
                                      return TrainListWidget(
                                        context: context,
                                        ref: ref,
                                        trainStationMap: stationState.trainStationMap,
                                        tokyoTrainMap: tokyoTrainState.tokyoTrainMap,
                                      );
                                    },
                                  ),
                                  onPositionChanged: (Offset newPos) => appParamNotifier.updateOverlayPosition(newPos),
                                  fixedFlag: true,
                                );
                              },
                              icon: const Icon(Icons.list),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: (searchRadius == 2)
                                  ? Colors.orangeAccent.withOpacity(0.3)
                                  : Colors.blue.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                setState(() => searchRadius = 2);

                                makeStationModelList();
                              },
                              child: const Icon(FontAwesomeIcons.two, size: 15),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: (searchRadius == 5)
                                  ? Colors.orangeAccent.withOpacity(0.3)
                                  : Colors.blue.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                setState(() => searchRadius = 5);

                                makeStationModelList();
                              },
                              child: const Icon(FontAwesomeIcons.five, size: 15),
                            ),
                          ),
                          const SizedBox(width: 20),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
            Positioned(
              bottom: 5,
              right: 5,
              child: DefaultTextStyle(
                style: const TextStyle(color: Colors.black),
                child: SizedBox(
                  width: context.screenSize.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      if (spotLatitude != 0 && spotLongitude != 0) ...<Widget>[
                        Text(spotLatitude.toString()),
                        Text(spotLongitude.toString()),
                      ],
                      if (spotLatitude == 0 || spotLongitude == 0) ...<Widget>[Text(_locationMessage)],
                      ElevatedButton(
                        onPressed: _getCurrentLocation,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                        child: const Text('現在地を取得'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///
  void setDefaultBoundsMap() {
    if (appParamState.selectedStationLatLng != null) {
      LatLngBounds bounds =
          LatLngBounds.fromPoints(<LatLng>[LatLng(spotLatitude, spotLongitude), appParamState.selectedStationLatLng!]);

      if (appParamState.selectedLineNumber != '') {
        final List<double> latList = <double>[];
        final List<double> lngList = <double>[];

        double minLat = 0.0;
        double maxLat = 0.0;
        double minLng = 0.0;
        double maxLng = 0.0;

        for (final StationModel element in stationState.stationList) {
          if (element.lineNumber == appParamState.selectedLineNumber) {
            latList.add(element.lat.toDouble());
            lngList.add(element.lng.toDouble());
          }
        }

        if (latList.isNotEmpty && lngList.isNotEmpty) {
          minLat = latList.reduce(min);
          maxLat = latList.reduce(max);
          minLng = lngList.reduce(min);
          maxLng = lngList.reduce(max);
        }

        bounds = LatLngBounds.fromPoints(<LatLng>[LatLng(minLat, maxLng), LatLng(maxLat, minLng)]);
      }

      final CameraFit cameraFit = CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(50));

      mapController.fitCamera(cameraFit);

      final double newZoom = mapController.camera.zoom;

      appParamNotifier.setCurrentZoom(zoom: newZoom);
    }
  }

  ///
  void makeLineStationMarkerList() {
    lineStationMarkerList.clear();

    if (appParamState.selectedLineNumber != '') {
      for (final StationModel element in stationState.stationList) {
        if (element.lineNumber == appParamState.selectedLineNumber) {
          lineStationMarkerList.add(
            Marker(
              point: LatLng(element.lat.toDouble(), element.lng.toDouble()),
              child: const Icon(Icons.location_on, color: Colors.green),
            ),
          );
        }
      }
    }

    makeLinePolylineList(selectedLineNumber: appParamState.selectedLineNumber);
  }

  ///
  void makeLinePolylineList({required String selectedLineNumber}) {
    linePolylineList.clear();

    if (selectedLineNumber != '') {
      for (final StationModel element in stationState.stationList) {
        if (element.lineNumber == selectedLineNumber) {
          linePolylineList.add(LatLng(element.lat.toDouble(), element.lng.toDouble()));
        }
      }
    }
  }

  ///
  void makeSelectTrainPolylineList() {
    selectTrainPolylinesList.clear();

    final List<LatLng> markerPoints = <LatLng>[];

    for (int i = 0; i < appParamState.trainNameList.length; i++) {
      final List<LatLng> points = <LatLng>[];

      if (appParamState.limitTokyoTrain) {
        if (tokyoTrainState.tokyoTrainMap[appParamState.trainNameList[i]] != null) {
          for (final TokyoStationModel element
              in tokyoTrainState.tokyoTrainMap[appParamState.trainNameList[i]]!.station) {
            points.add(LatLng(element.lat.toDouble(), element.lng.toDouble()));

            markerPoints.add(LatLng(element.lat.toDouble(), element.lng.toDouble()));
          }
        }
      } else {
        if (stationState.trainStationMap[appParamState.trainNameList[i]] != null) {
          for (final StationModel element in stationState.trainStationMap[appParamState.trainNameList[i]]!) {
            points.add(LatLng(element.lat.toDouble(), element.lng.toDouble()));

            markerPoints.add(LatLng(element.lat.toDouble(), element.lng.toDouble()));
          }
        }
      }

      // ignore: always_specify_types
      selectTrainPolylinesList.add(Polyline(points: points, color: Colors.redAccent, strokeWidth: 4));
    }

    if (markerPoints.isNotEmpty) {
      makeSelectTrainStationMarkerList(markerPoints: markerPoints);
    }
  }

  ///
  void makeSelectTrainStationMarkerList({required List<LatLng> markerPoints}) {
    selectTrainStationMarkerList.clear();

    for (final LatLng element in markerPoints) {
      selectTrainStationMarkerList
          .add(Marker(point: element, child: const Icon(Icons.location_on, color: Colors.redAccent)));
    }
  }
}
