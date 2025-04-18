import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/station_model.dart';
import '../../utility/utility.dart';

mixin TrainListMixin {
  ///
  Widget trainListDisplayParts(
      {required WidgetRef ref,
      required BuildContext context,
      required Map<String, List<StationModel>> trainStationMap}) {
    final List<Widget> list = <Widget>[];

    final Utility utility = Utility();

    final List<String> aaa = utility.getTokyoWard();

    print(aaa);

    final List<String> bbb = utility.getTokyoCity();

    print(bbb);

    trainStationMap.forEach((String key, List<StationModel> value) {
      list.add(Text(key));
    });

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list,
      ),
    );
  }
}
