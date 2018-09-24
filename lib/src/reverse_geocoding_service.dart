import 'dart:async';
import 'dart:core';

import 'package:angular/core.dart';
import 'package:http/http.dart';

import 'api_key.dart';
import 'http_util.dart';

@Injectable()
class ReverseGeocodingService {
  final Client _http;

  final Map<String, Future<Response>> _httpCache = Map();

  ReverseGeocodingService(this._http);

  Future<String> reverseGeocode(double lat, double lng) async {
      final _url = "https://maps.googleapis.com/maps/api/geocode/json?" +
        "latlng=${lat.toString()},${lng.toString()}" + 
        "&key=${ApiKey}";
      if (!_httpCache.containsKey(_url)) {
        _httpCache[_url] = _http.get(_url);
      }
      final response = await _httpCache[_url];
      final data = extractData(response) as Map<String, dynamic>;
      final firstResult = data["results"][0];
      final components = firstResult["address_components"];
      final List<String> usefulComponents = [];
      maybeAddLevel(components, "sublocality_level_2", usefulComponents);
      maybeAddLevel(components, "sublocality_level_1", usefulComponents);
      maybeAddLevel(components, "administrative_area_level_3", usefulComponents);
      maybeAddLevel(components, "administrative_area_level_2", usefulComponents);
      maybeAddLevel(components, "administrative_area_level_1", usefulComponents);
      final address = usefulComponents.isNotEmpty ? usefulComponents.join(", ") : firstResult["formatted_address"];;
      return address;
  }

  maybeAddLevel(List<dynamic> components, String level, List<String> usefulComponents) {
    try {
      final component = components
          .firstWhere((c) => c["types"].contains(level));
      final value = component["long_name"] as String;
      if (value == null) return;
      usefulComponents.add(value);
    } catch (e) {
      // Silently ignore.
      // print(e);
    }
  }
}