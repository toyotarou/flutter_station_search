import 'dart:math';

import 'package:flutter/material.dart';

class Utility {
  ///
  void showError(String msg) {
    ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  ///
  String calcDistance(
      {required double originLat, required double originLng, required double destLat, required double destLng}) {
    final double distanceKm = 6371 *
        acos(
          cos(originLat / 180 * pi) * cos((destLng - originLng) / 180 * pi) * cos(destLat / 180 * pi) +
              sin(originLat / 180 * pi) * sin(destLat / 180 * pi),
        );

    return distanceKm.toString();
  }

  ///
  List<String> getTokyoWard() {
    const String str = '''
千代田区
中央区
港区
新宿区
文京区
台東区
墨田区
江東区
品川区
目黒区
大田区
世田谷区
渋谷区
中野区
杉並区
豊島区
北区
荒川区
板橋区
練馬区
足立区
葛飾区
江戸川区
''';

    final List<String> list = <String>[];

    str.split('\n').forEach((String element) {
      if (element.trim() != '') {
        list.add(element.trim());
      }
    });

    return list;
  }

  ///
  List<String> getTokyoCity() {
    const String str = '''
八王子市
立川市
武蔵野市
三鷹市
青梅市
府中市
昭島市
調布市
町田市
小金井市
小平市
日野市
東村山市
国分寺市
国立市
福生市
狛江市
東大和市
清瀬市
東久留米市
武蔵村山市
多摩市
稲城市
羽村市
あきる野市
西東京市
瑞穂町
日の出町
檜原村
奥多摩町
大島町
利島村
新島村
神津島村
三宅村
御蔵島村
八丈町
青ヶ島村
小笠原村
    ''';

    final List<String> list = <String>[];

    str.split('\n').forEach((String element) {
      if (element.trim() != '') {
        list.add(element.trim());
      }
    });

    return list;
  }
}

class NavigationService {
  const NavigationService._();

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
