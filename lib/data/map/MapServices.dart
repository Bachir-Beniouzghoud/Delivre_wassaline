import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:wassalni/data/models/map/PlaceResoult.dart';

class MapServices {
  final http.Client _client;
  MapServices([http.Client? client]) : _client = client ?? http.Client();

  Future<List<PlaceResult>?> search(
    String query, {
    String? countryCodes,
    String? codeLa,
    LatLng? near,
  }) async {
    final params = <String, String>{
      "q": query,
      "format": "jsonv2",
      'accept-language': codeLa ?? 'ar',
      'countrycodes': ?countryCodes,
      'addressdetails': '1',
      'limit': '20',
    };
    if (near != null) {
      // مربع بحث حول الموقع (±0.15 درجة ≈ 15 كم)
      const d = 0.1;
      params['viewbox'] =
          '${near.longitude - d},${near.latitude + d},${near.longitude + d},${near.latitude - d}';
      params['bounded'] = '1'; // 1 = ابحث داخل المربع فقط، 0 = فضّله فقط
    }
    final uri = Uri.https('nominatim.openstreetmap.org', '/search', params);

    final response = await _client
        .get(uri, headers: {'User-Agent': 'com.example.wassalni)'})
        .timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw Exception('Search failed: ${response.statusCode}');
    }

    final List data = jsonDecode(utf8.decode(response.bodyBytes));

    // ignore: avoid_function_literals_in_foreach_calls
    List<PlaceResult> d = [];
    for (var e in data) {
      d.add(PlaceResult.tryFromJson(e)!);
    }
  
    return d;
  }
}
