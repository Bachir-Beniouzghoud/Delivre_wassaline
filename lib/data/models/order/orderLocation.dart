class OrderLocation {
  final String address;
  final double lat;
  final double lng;

  const OrderLocation({
    required this.address,
    required this.lat,
    required this.lng,
  });

  factory OrderLocation.fromMap(Map<String, dynamic> map) => OrderLocation(
        address: map['address'] as String,
        lat: (map['lat'] as num).toDouble(),
        lng: (map['lng'] as num).toDouble(),
      );

  Map<String, dynamic> toMap() => {
        'address': address,
        'lat': lat,
        'lng': lng,
      };
}