import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../controllers/near_station/near_station.dart';
import '../controllers/station/station.dart';
import '../controllers/tokyo_train/tokyo_train.dart';
import '../extensions/extensions.dart';
import '../models/station_extends_model.dart';
import '../models/station_model.dart';
import '../utility/tile_provider.dart';
import '../utility/utility.dart';

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

  ///
  /// ボタン押下時に呼ばれるメソッド
  Future<void> _getCurrentLocation() async {
    try {
      // 実際に位置情報を取得する
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
            ref
                .read(nearStationProvider.notifier)
                .setNearStationList(latlng: LatLng(element.lat.toDouble(), element.lng.toDouble()));
          }
        });
      });
    } catch (e) {
      setState(() {
        _locationMessage = '位置情報の取得に失敗しました。\n$e';
      });
    }
  }

  ///
  /// 実際に位置情報を取得するためのメソッド
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. 位置情報サービス（GPSなど）が有効になっているか確認
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // ignore: always_specify_types
      return Future.error('位置情報サービスが無効です。');
    }

    // 2. 現在の権限状態をチェック
    permission = await Geolocator.checkPermission();

    // 3. 権限が「拒否」なら、権限リクエストを実行
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // ユーザーが権限を拒否した場合
        // ignore: always_specify_types
        return Future.error('位置情報の権限が拒否されています。');
      }
    }

    // 4. ユーザーが「常に拒否」にしていた場合
    if (permission == LocationPermission.deniedForever) {
      // 端末の設定アプリから権限を変更してもらう必要がある
      // ignore: always_specify_types
      return Future.error('位置情報の権限が「常に拒否」に設定されています。');
    }

    // 5. ここまで到達すれば権限は許可済みなので、位置情報を取得
    return Geolocator.getCurrentPosition(
      // 注意: `settings` ではなく `locationSettings` を使用
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100, // 必要に応じて調整
      ),
    );
  }

  ///
  @override
  void initState() {
    super.initState();

    ref.read(tokyoTrainProvider.notifier).getTokyoTrainData();

    ref.read(stationProvider.notifier).getStationData();
  }

  ///
  @override
  Widget build(BuildContext context) {
    final List<LatLng> nearStationList =
        ref.watch(nearStationProvider.select((NearStationState value) => value.nearStationList));

    final Map<String, StationModel> stationMap =
        ref.watch(stationProvider.select((StationState value) => value.stationMap));

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: const LatLng(35.718532, 139.586639),

                initialZoom: currentZoomEightTeen,
                // onPositionChanged: (MapCamera position, bool isMoving) {
                //   if (isMoving) {
                //     ref.read(appParamProvider.notifier).setCurrentZoom(zoom: position.zoom);
                //   }
                // },
//                onTap: (TapPosition tapPosition, LatLng latlng) => setState(() => tappedPoints.add(latlng)),
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
                    ],
                  ),
              ],
            ),
            Positioned(
                child: IconButton(
                    onPressed: () {
                      print(nearStationList.length);

                      for (final LatLng element in nearStationList) {
                        if (stationMap['${element.latitude}|${element.longitude}'] != null) {
                          print(stationMap['${element.latitude}|${element.longitude}']!.stationName);

                          final String di = utility.calcDistance(
                              originLat: spotLatitude,
                              originLng: spotLongitude,
                              destLat: element.latitude,
                              destLng: element.longitude);

                          final double dis = di.toDouble() * 1000;

                          final StationModel station = stationMap['${element.latitude}|${element.longitude}']!;

                          final StationExtendsModel stationExtendsModel =
                              StationExtendsModel.fromStation(station: station, distance: dis);

                          ref
                              .read(nearStationProvider.notifier)
                              .setStationExtendsList(stationExtendsModel: stationExtendsModel);
                        }
                      }
                    },
                    icon: const Icon(Icons.ac_unit, color: Colors.black))),
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
}
