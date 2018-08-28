import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart';
import 'package:http/testing.dart';

import 'message.dart';
import 'person.dart';

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
  static const getMessagesResponse = {
    "chanList": [
      {
        "ID": 1,
        "name": "Elysium"
      }
    ],
    "chanUpdates": [
      {
        "chanID": 1,
        "events": [
          {
            "ID": 735455,
            "eventType": {
              "ID": 7,
              "name": "Session Resume",
              "type": "SessionResume"
            },
            "source": {
              "connection": {
                "ID": 304804,
                "IP": {
                  "ID": 2951,
                  "IP": "202.89.121.20"
                },
                "hostname": {
                  "ID": 2711,
                  "hostname": "202.89.121.20"
                }
              },
              "datetime": "2018-08-27T09:29:08",
              "entity": {
                "ID": 5,
                "entityType": {
                  "ID": 2,
                  "name": "User",
                  "type": "User"
                },
                "name": "frun"
              },
              "location": {
                "ID": 272649,
                "accuracy": 69,
                "altitude": null,
                "altitudeAccuracy": null,
                "heading": null,
                "latitude": 25.0576449,
                "locationName": null,
                "longitude": 121.6147452,
                "speed": null
              },
              "timeZone": {
                "ID": 10,
                "timeZone": "Asia/Taipei"
              },
              "userAgent": {
                "ID": 525,
                "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Safari/537.36"
              }
            }
          },
          {
            "ID": 735456,
            "eventType": {
              "ID": 7,
              "name": "Session Resume",
              "type": "SessionResume"
            },
            "source": {
              "connection": {
                "ID": 304805,
                "IP": {
                  "ID": 4324,
                  "IP": "17.154.10.75"
                },
                "hostname": {
                  "ID": 4146,
                  "hostname": "17.154.10.75"
                }
              },
              "datetime": "2018-08-27T09:32:32",
              "entity": {
                "ID": 4,
                "entityType": {
                  "ID": 2,
                  "name": "User",
                  "type": "User"
                },
                "name": "atn"
              },
              "location": null,
              "timeZone": {
                "ID": 21,
                "timeZone": "America/Los_Angeles"
              },
              "userAgent": {
                "ID": 525,
                "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Safari/537.36"
              }
            }
          },
          {
            "ID": 735457,
            "eventType": {
              "ID": 6,
              "name": "Session Pause",
              "type": "SessionPause"
            },
            "source": {
              "connection": null,
              "datetime": "2018-08-27T09:39:34",
              "entity": {
                "ID": 5,
                "entityType": {
                  "ID": 2,
                  "name": "User",
                  "type": "User"
                },
                "name": "frun"
              },
              "location": null,
              "timeZone": null,
              "userAgent": null
            }
          },
          {
            "ID": 735458,
            "content": "bon",
            "eventType": {
              "ID": 3,
              "name": "Message",
              "type": "Message"
            },
            "source": {
              "connection": {
                "ID": 304806,
                "IP": {
                  "ID": 4324,
                  "IP": "17.154.10.75"
                },
                "hostname": {
                  "ID": 4146,
                  "hostname": "17.154.10.75"
                }
              },
              "datetime": "2018-08-27T09:58:24",
              "entity": {
                "ID": 4,
                "entityType": {
                  "ID": 2,
                  "name": "User",
                  "type": "User"
                },
                "name": "atn"
              },
              "location": null,
              "timeZone": {
                "ID": 21,
                "timeZone": "America/Los_Angeles"
              },
              "userAgent": {
                "ID": 525,
                "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Safari/537.36"
              }
            }
          },
          {
            "ID": 735459,
            "content": "débat philosophique encore une fois",
            "eventType": {
              "ID": 3,
              "name": "Message",
              "type": "Message"
            },
            "source": {
              "connection": {
                "ID": 304807,
                "IP": {
                  "ID": 4324,
                  "IP": "17.154.10.75"
                },
                "hostname": {
                  "ID": 4146,
                  "hostname": "17.154.10.75"
                }
              },
              "datetime": "2018-08-27T09:58:27",
              "entity": {
                "ID": 4,
                "entityType": {
                  "ID": 2,
                  "name": "User",
                  "type": "User"
                },
                "name": "atn"
              },
              "location": {
                "ID": 272650,
                "accuracy": 30,
                "altitude": null,
                "altitudeAccuracy": null,
                "heading": null,
                "latitude": 37.792830699999996,
                "locationName": null,
                "longitude": -122.42401169999998,
                "speed": null
              },
              "timeZone": {
                "ID": 21,
                "timeZone": "America/Los_Angeles"
              },
              "userAgent": {
                "ID": 525,
                "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Safari/537.36"
              }
            }
          },
          {
            "ID": 735460,
            "content": "est-ce que je mets le code de mon nouveau elysium client sur github ou bitbucket ?",
            "eventType": {
              "ID": 3,
              "name": "Message",
              "type": "Message"
            },
            "source": {
              "connection": {
                "ID": 304808,
                "IP": {
                  "ID": 4324,
                  "IP": "17.154.10.75"
                },
                "hostname": {
                  "ID": 4146,
                  "hostname": "17.154.10.75"
                }
              },
              "datetime": "2018-08-27T09:58:35",
              "entity": {
                "ID": 4,
                "entityType": {
                  "ID": 2,
                  "name": "User",
                  "type": "User"
                },
                "name": "atn"
              },
              "location": {
                "ID": 272651,
                "accuracy": 30,
                "altitude": null,
                "altitudeAccuracy": null,
                "heading": null,
                "latitude": 37.792830699999996,
                "locationName": null,
                "longitude": -122.42401169999998,
                "speed": null
              },
              "timeZone": {
                "ID": 21,
                "timeZone": "America/Los_Angeles"
              },
              "userAgent": {
                "ID": 525,
                "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Safari/537.36"
              }
            }
          },
          {
            "ID": 735461,
            "content": "allez",
            "eventType": {
              "ID": 3,
              "name": "Message",
              "type": "Message"
            },
            "source": {
              "connection": {
                "ID": 304809,
                "IP": {
                  "ID": 4324,
                  "IP": "17.154.10.75"
                },
                "hostname": {
                  "ID": 4146,
                  "hostname": "17.154.10.75"
                }
              },
              "datetime": "2018-08-27T10:03:15",
              "entity": {
                "ID": 4,
                "entityType": {
                  "ID": 2,
                  "name": "User",
                  "type": "User"
                },
                "name": "atn"
              },
              "location": {
                "ID": 272652,
                "accuracy": 30,
                "altitude": null,
                "altitudeAccuracy": null,
                "heading": null,
                "latitude": 37.792830699999996,
                "locationName": null,
                "longitude": -122.42401169999998,
                "speed": null
              },
              "timeZone": {
                "ID": 21,
                "timeZone": "America/Los_Angeles"
              },
              "userAgent": {
                "ID": 525,
                "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Safari/537.36"
              }
            }
          },
          {
            "ID": 735462,
            "content": "ça sera github encore une fois",
            "eventType": {
              "ID": 3,
              "name": "Message",
              "type": "Message"
            },
            "source": {
              "connection": {
                "ID": 304810,
                "IP": {
                  "ID": 4324,
                  "IP": "17.154.10.75"
                },
                "hostname": {
                  "ID": 4146,
                  "hostname": "17.154.10.75"
                }
              },
              "datetime": "2018-08-27T10:03:17",
              "entity": {
                "ID": 4,
                "entityType": {
                  "ID": 2,
                  "name": "User",
                  "type": "User"
                },
                "name": "atn"
              },
              "location": {
                "ID": 272653,
                "accuracy": 30,
                "altitude": null,
                "altitudeAccuracy": null,
                "heading": null,
                "latitude": 37.792830699999996,
                "locationName": null,
                "longitude": -122.42401169999998,
                "speed": null
              },
              "timeZone": {
                "ID": 21,
                "timeZone": "America/Los_Angeles"
              },
              "userAgent": {
                "ID": 525,
                "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Safari/537.36"
              }
            }
          },
          {
            "ID": 735465,
            "eventType": {
              "ID": 5,
              "name": "Session Stop",
              "type": "SessionStop"
            },
            "source": {
              "connection": {
                "ID": 304813,
                "IP": {
                  "ID": 4324,
                  "IP": "17.154.10.75"
                },
                "hostname": {
                  "ID": 4146,
                  "hostname": "17.154.10.75"
                }
              },
              "datetime": "2018-08-27T10:13:57",
              "entity": {
                "ID": 4,
                "entityType": {
                  "ID": 2,
                  "name": "User",
                  "type": "User"
                },
                "name": "atn"
              },
              "location": {
                "ID": 272656,
                "accuracy": 30,
                "altitude": null,
                "altitudeAccuracy": null,
                "heading": null,
                "latitude": 37.792830699999996,
                "locationName": null,
                "longitude": -122.42401169999998,
                "speed": null
              },
              "timeZone": {
                "ID": 21,
                "timeZone": "America/Los_Angeles"
              },
              "userAgent": {
                "ID": 525,
                "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Safari/537.36"
              }
            }
          },
        ],
        "userList": [
          {
            "ID": 4,
            "latestSource": {
              "datetime": "2018-08-27T10:03:24",
              "location": {
                "ID": 272655,
                "accuracy": 30,
                "altitude": null,
                "altitudeAccuracy": null,
                "heading": null,
                "latitude": 37.792830699999996,
                "locationName": null,
                "longitude": -122.42401169999998,
                "speed": null
              },
              "timeZone": {
                "ID": 21,
                "timeZone": "America/Los_Angeles"
              }
            },
            "name": "atn",
            "on": true
          },
          {
            "ID": 5,
            "latestSource": {
              "datetime": "2018-08-27T01:21:51",
              "location": {
                "ID": 272607,
                "accuracy": 108,
                "altitude": null,
                "altitudeAccuracy": null,
                "heading": null,
                "latitude": 25.0575661,
                "locationName": null,
                "longitude": 121.61500389999999,
                "speed": null
              },
              "timeZone": {
                "ID": 10,
                "timeZone": "Asia/Taipei"
              }
            },
            "name": "frun",
            "on": false
          }
        ],
        "userListUpdated": true
      }
    ],
    "lastEventID": -1,
    "numMessages": -1,
    "token": "1041471832",
    "userID": 4,
    "validResponse": true
  };
  static Future<Response> _handler(Request request) async {
    var data;
    switch (request.method) {
      case 'GET':
        print(request.url);
        switch (request.url.pathSegments.last) {
          case 'login.action':
            data = loginActionResponse;
            break;
          case 'getmessages.action':
            data = getMessagesResponse;
            break;
        }
        break;
      default:
        throw 'Unimplemented HTTP method ${request.method}';
    }
    return Response(json.encode(data), 200,
        headers: {'content-type': 'application/json'});
  }
  InMemoryDataService() : super(_handler);
}
