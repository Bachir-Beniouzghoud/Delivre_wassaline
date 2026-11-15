import 'package:latlong2/latlong.dart';

class Placeresoult {
  final String name;
  final LatLng posetion;
  const Placeresoult({required this.name, required this.posetion});
  factory Placeresoult.fromJson(Map<String, dynamic> json) => Placeresoult(
    name: json["name"] as String,
    posetion: LatLng(
      double.parse(json['lat'] as String),
      double.parse(json['lon'] as String),
    ),
  );
}
