import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_param/app_param.dart';
import 'station/station.dart';

mixin ControllersMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  //==========================================//

  AppParamState get appParamState => ref.watch(appParamProvider);

  AppParam get appParamNotifier => ref.read(appParamProvider.notifier);

//==========================================//

  StationState get stationState => ref.watch(stationProvider);

  Station get stationNotifier => ref.read(stationProvider.notifier);

//==========================================//
}
