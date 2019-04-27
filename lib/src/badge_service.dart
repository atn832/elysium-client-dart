import 'dart:async';
import 'dart:core';

import 'package:angular/core.dart';
import 'package:http/http.dart';

import 'api_key.dart';
import 'http_util.dart';

@Injectable()
class BadgeService {
  final Client _http;

  String _cache;

  BadgeService(this._http);

  Future<String> getBadge(String name) async {
    if (name != '元元') {
      return Future.value('');
    }
    if (_cache != null) {
      return _cache;
    }
    final _url = 'https://www.googleapis.com/youtube/v3/channels?part=statistics&' +
      'forUsername=Fruncoyy&key=$ApiKey';
    try {
      final response = await _http.get(_url);
      final data = extractData(response) as Map<String, dynamic>;
      final subscriberCount = data["items"][0]["statistics"]["subscriberCount"];
      _cache = '$subscriberCount followers';
      Future.delayed(Duration(minutes: 30), () {
        _cache = null;
      });
      return _cache;
    } catch (e) {
      print(e);
    }
  }
}