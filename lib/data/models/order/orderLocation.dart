import 'package:latlong2/latlong.dart';

class OrderLocation {
  String address;
  // final double lat;
  // final double lng;
  LatLng loction;
  OrderLocation({
    required this.address,
    // required this.lat,
    // required this.lng,
    required this.loction,
  });

  factory OrderLocation.fromMap(Map<String, dynamic> map) => OrderLocation(
    address: map['address'] as String,
    // lat: (map['lat'] as num).toDouble(),
    // lng: (map['lng'] as num).toDouble(),
    loction: map['loction'],
  );

  Map<String, dynamic> toMap() => {
    'address': address,
    // 'lat': lat,
    // 'lng': lng,
    'loction': loction,
  };
}
