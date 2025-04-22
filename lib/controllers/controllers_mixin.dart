import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_param/app_param.dart';
import 'bus_info/bus_info.dart';
import 'station/station.dart';
import 'tokyo_train/tokyo_train.dart';

mixin ControllersMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  //==========================================//

  AppParamState get appParamState => ref.watch(appParamProvider);

  AppParam get appParamNotifier => ref.read(appParamProvider.notifier);

//==========================================//

  StationState get stationState => ref.watch(stationProvider);

  Station get stationNotifier => ref.read(stationProvider.notifier);

//==========================================//

  TokyoTrainState get tokyoTrainState => ref.watch(tokyoTrainProvider);

  TokyoTrain get tokyoTrainNotifier => ref.read(tokyoTrainProvider.notifier);

//==========================================//

  BusInfoState get busInfoState => ref.watch(busInfoProvider);

  BusInfo get busIntoNotifier => ref.read(busInfoProvider.notifier);

//==========================================//
}
