import '../extensions/extensions.dart';
import 'station_model.dart';

class StationExtendsModel extends StationModel {
  StationExtendsModel({
    required super.id,
    required super.stationName,
    required super.address,
    required super.lat,
    required super.lng,
    required super.lineNumber,
    required super.lineName,
    required this.distance,
  });

  factory StationExtendsModel.fromStation({required StationModel station, required double distance}) {
    return StationExtendsModel(
      id: station.id,
      stationName: station.stationName,
      address: station.address,
      lat: station.lat,
      lng: station.lng,
      lineNumber: station.lineNumber,
      lineName: station.lineName,
      distance: distance,
    );
  }

  factory StationExtendsModel.fromJson(Map<String, dynamic> json) {
    return StationExtendsModel(
      id: int.parse(json['id'].toString()),
      stationName: json['station_name'].toString(),
      address: json['address'].toString(),
      lat: json['lat'].toString(),
      lng: json['lng'].toString(),
      lineNumber: json['line_number'].toString(),
      lineName: json['line_name'].toString(),
      distance: json['distance'].toString().toDouble(),
    );
  }

  final double distance;

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = super.toJson();
    json['distance'] = distance;
    return json;
  }
}
