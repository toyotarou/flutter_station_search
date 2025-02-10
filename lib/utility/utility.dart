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
}

class NavigationService {
  const NavigationService._();

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
