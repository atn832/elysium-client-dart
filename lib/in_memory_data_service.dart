import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'src/message.dart';
import 'src/person.dart';

class InMemoryDataService extends MockClient {
  static const loginActionResponse = {
    "channel":{
      "ID":1,
      "entityType":{
        "ID":1,
        "name":"Channel",
        "type":"Channel"
      },
      "name":"Elysium",
      "password":"",
      "userList":[
        4,
        5,
        6,
        7,
        8,
        9,
      ]
    },
    "invalidLoginMessage":null,
    "token":"1479789241",
    "user":{
      "ID":4,
      "chanList":[
        1
      ],
      "emailAddress":null,
      "entityType":{
        "ID":2,
        "name":"User",
        "type":"User"
      },
      "latestSource":{
        "ID":779966,
        "connection":{
          "ID":304800,
          "IP":{
            "ID":4325,
            "IP":"17.154.10.75"
          },
          "hostname":{
            "ID":4147,
            "hostname":"17.154.10.75"
          }
        },
        "datetime":"2018-08-27T07:40:24",
        "entity":null,
        "location":{
          "ID":272646,
          "accuracy":828.0,
          "altitude":null,
          "altitudeAccuracy":null,
          "heading":null,
          "latitude": 37.792830699999996,
          "locationName": null,
          "longitude": -122.42401169999998,
          "speed":null
        },
        "timeZone":{
          "ID":21,
          "timeZone":"America/Los_Angeles"
        },
        "userAgent":{
          "ID":530,
          "userAgent":"Mozilla\/5.0 (X11; Linux x86_64) AppleWebKit\/537.36 (KHTML, like Gecko) Chrome\/68.0.3440.106 Safari\/537.36"
        }
      },
      "name":"atn",
      "newSourceInstance":{
        "ID":0,
        "connection":null,
        "datetime":"2018-08-27T08:28:42",
        "entity":null,
        "location":null,
        "timeZone":null,
        "userAgent":null
      },
      "on":true,
      "password":"",
      "tokens":[
        {
          "ID":7348,
          "token":"1653277433"
        },
        {
          "ID":7349,
          "token":"1609466214"
        },
        {
          "ID":7350,
          "token":"1698542826"
        },
      ]
    }
  };
  static Future<Response> _handler(Request request) async {
    var data;
    switch (request.method) {
      case 'GET':
        data = loginActionResponse;
        print(request.url);
        // final id = int.tryParse(request.url.pathSegments.last);
        // if (id != null) {
        //   data = _heroesDb
        //       .firstWhere((hero) => hero.id == id); // throws if no match
        // } else {
        //   String prefix = request.url.queryParameters['name'] ?? '';
        //   final regExp = RegExp(prefix, caseSensitive: false);
        //   data = _heroesDb.where((hero) => hero.name.contains(regExp)).toList();
        // }
        break;
      default:
        throw 'Unimplemented HTTP method ${request.method}';
    }
    return Response(json.encode(data), 200,
        headers: {'content-type': 'application/json'});
  }
  InMemoryDataService() : super(_handler);
}
