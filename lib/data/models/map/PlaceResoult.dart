import 'package:latlong2/latlong.dart';

class PlaceResult {
  final String name;
  final String address;
  final LatLng position;
  final String? type; // town, hospital, bus_stop ...

  const PlaceResult({
    required this.name,
    required this.address,
    required this.position,
    this.type,
  });

  static PlaceResult? tryFromJson(Map<String, dynamic> json) {
    final lat = double.tryParse(json['lat']?.toString() ?? '');
    final lon = double.tryParse(json['lon']?.toString() ?? '');
    if (lat == null || lon == null) return null;

    final displayName = (json['display_name'] as String?) ?? '';
    final rawName = (json['name'] as String?)?.trim() ?? '';

    return PlaceResult(
      // إذا كان name فارغاً نأخذ أول جزء من display_name
      name: rawName.isNotEmpty
          ? rawName
          : (displayName.isNotEmpty
              ? displayName.split(',').first.trim()
              : 'مكان بدون اسم'),
      address: displayName,
      position: LatLng(lat, lon),
      type: json['type'] as String?,
    );
  }
}