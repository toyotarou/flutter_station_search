import '../extensions/extensions.dart';

class BusInfoModel {
  BusInfoModel({required this.id, required this.endA, required this.endB});

  factory BusInfoModel.fromJson(Map<String, dynamic> json) =>
      BusInfoModel(id: json['id'].toString().toInt(), endA: json['end_a'].toString(), endB: json['end_b'].toString());
  int id;
  String endA;
  String endB;

  Map<String, dynamic> toJson() => <String, dynamic>{'id': id, 'end_a': endA, 'end_b': endB};
}
