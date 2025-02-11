import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../controllers/app_param/app_param.dart';
import '../controllers/station/station.dart';
import '../extensions/extensions.dart';
import '../mixin/near_station/near_station_widget.dart';
import '../models/station_model.dart';
import '../utility/tile_provider.dart';
import '../utility/utility.dart';
import 'parts/station_search_overlay.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _locationMessage = '位置情報が取得されていません。';

  double spotLatitude = 0;
  double spotLongitude = 0;

  final MapController mapController = MapController();

  double currentZoomEightTeen = 18;

  Utility utility = Utility();

  final List<OverlayEntry> _firstEntries = <OverlayEntry>[];

  final List<OverlayEntry> _secondEntries = <OverlayEntry>[];

  List<StationModel> stationModelList = <StationModel>[];

  ///
  Future<void> _getCurrentLocation() async {
    try {
      final Position position = await _determinePosition();

      setState(() {
        spotLatitude = position.latitude;
        spotLongitude = position.longitude;

        mapController.move(LatLng(spotLatitude, spotLongitude), 13);

        ref.watch(stationProvider.select((StationState value) => value.stationList)).forEach((StationModel element) {
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
        });
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

    ref.read(stationProvider.notifier).getStationData();
  }

  ///
  @override
  Widget build(BuildContext context) {
    final LatLng? selectedStationLatLng =
        ref.watch(appParamProvider.select((AppParamState value) => value.selectedStationLatLng));

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
                      if (selectedStationLatLng != null) ...<Marker>[
                        Marker(
                          point: selectedStationLatLng,
                          child: const Icon(Icons.location_on, color: Colors.blueAccent),
                        ),
                      ],
                    ],
                  ),
                if ((spotLatitude > 0 && spotLongitude > 0) && (selectedStationLatLng != null)) ...<Widget>[
                  // ignore: always_specify_types
                  PolylineLayer(
                    polylines: <Polyline<Object>>[
                      // ignore: always_specify_types
                      Polyline(
                        points: <LatLng>[
                          LatLng(spotLatitude, spotLongitude),
                          selectedStationLatLng,
                        ],
                        color: Colors.redAccent.withOpacity(0.4),
                        strokeWidth: 5,
                      ),
                    ],
                  ),
                ],
              ],
            ),
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
                              final AppParamState appParamState = ref.watch(appParamProvider);

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
                                onPositionChanged: (Offset newPos) =>
                                    ref.read(appParamProvider.notifier).updateOverlayPosition(newPos),
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
    final LatLng? selectedStationLatLng =
        ref.watch(appParamProvider.select((AppParamState value) => value.selectedStationLatLng));

    if (selectedStationLatLng != null) {
      final LatLngBounds bounds =
          LatLngBounds.fromPoints(<LatLng>[LatLng(spotLatitude, spotLongitude), selectedStationLatLng]);

      final CameraFit cameraFit = CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(50));

      mapController.fitCamera(cameraFit);

      final double newZoom = mapController.camera.zoom;

      ref.read(appParamProvider.notifier).setCurrentZoom(zoom: newZoom);
    }
  }
}
