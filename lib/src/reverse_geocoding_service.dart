import 'dart:async';
import 'dart:core';

import 'package:angular/core.dart';
import 'package:http/http.dart';

import 'api_key.dart';
import 'http_util.dart';

@Injectable()
class ReverseGeocodingService {
  final Client _http;

  ReverseGeocodingService(this._http);

  Future<String> reverseGeocode(double lat, double lng) async {
      final _url = "https://maps.googleapis.com/maps/api/geocode/json?" +
        "latlng=${lat.toString()},${lng.toString()}" + 
        "&key=${ApiKey}";
      final response = await _http.get(_url);
      final data = extractData(response) as Map<String, dynamic>;
      final address = data["results"][0]["formatted_address"];
      return address;
  }
}