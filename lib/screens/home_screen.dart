import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

//import '../controllers/app_param/app_param.dart';
import '../controllers/controllers_mixin.dart';

//import '../controllers/station/station.dart';
import '../extensions/extensions.dart';
import '../mixin/near_station/near_station_widget.dart';
import '../models/station_model.dart';
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

  ///
  Future<void> _getCurrentLocation() async {
    try {
      final Position position = await _determinePosition();

      setState(() {
        spotLatitude = position.latitude;
        spotLongitude = position.longitude;

        mapController.move(LatLng(spotLatitude, spotLongitude), 13);

        for (final StationModel element in stationState.stationList) {
          final String di = utility.calcDistance(
            originLat: spotLatitude,
            originLng: spotLongitude,
            destLat: element.lat.toDouble(),
            destLng: element.lng.toDouble(),
          );

          final double dis = di.toDouble() * 1000;

          if (dis <= 2000) {
            stationModelList.add(element);
          }
        }
      });
    } catch (e) {
      setState(() => _locationMessage = '位置情報の取得に失敗しました。\n$e');
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
                      Container(),
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
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
                          child: IconButton(
                            onPressed: () {
                              appParamNotifier.clearSelectedStationLatLng();

                              appParamNotifier.setSelectedLineNumber(lineNumber: '');

                              Offset initialPosition =
                                  Offset(context.screenSize.width * 0.5, context.screenSize.height * 0.1);

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
                        Container(),
                      ],
                    ),
                  ],
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
}
