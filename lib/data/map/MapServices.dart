import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wassalni/data/models/map/PlaceResoult.dart';

class MapServices {
  final http.Client _client;
  MapServices([http.Client? client]) : _client = client ?? http.Client();

  Future<List<Placeresoult>> search(
    String query, {
    String? countryCodes,
    String? codeLa,
  }) async {
    final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
      "q": query,
      "format": "jsonv2",
      'accept-language': codeLa ?? 'ar',
      'countrycodes': ?countryCodes,
    });
    final response = await _client
        .get(uri, headers: {'User-Agent': 'com.example.wassalni)'})
        .timeout(const Duration(seconds: 15));

         if (response.statusCode != 200) {
      throw Exception('Search failed: ${response.statusCode}');
    }

    final List data =jsonDecode(utf8.decode(response.bodyBytes) );
    return data.map((e) =>  Placeresoult.fromJson(e),).toList() ;
  }
}
