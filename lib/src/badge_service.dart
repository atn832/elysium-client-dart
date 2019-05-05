import 'dart:async';
import 'dart:core';

import 'package:angular/core.dart';
import 'package:firebase/firebase.dart';
import 'package:http/http.dart';

import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart' as fs;
import 'package:intl/intl.dart';

import 'firebase_cards_info.dart';
import 'api_key.dart';
import 'http_util.dart';

final numberFormat = NumberFormat.decimalPattern('fr');

@Injectable()
class BadgeService {
  App app;
  final Client _http;

  Map<String, String> _cache = Map();

  BadgeService(this._http) {
    app = fb.initializeApp(
      name: 'Cards',
      apiKey: apiKey,
      authDomain: authDomain,
      databaseURL: databaseURL,
      projectId: projectId,
      storageBucket: storageBucket,
      messagingSenderId: messagingSenderId
    );
  }

  Future<String> getBadge(String name) async {
    if (_cache.containsKey(name)) {
      return _cache[name];
    }
    if (name == '元元') {
      final _url = 'https://www.googleapis.com/youtube/v3/channels?part=statistics&' +
        'forUsername=Fruncoyy&key=$ApiKey';
      try {
        final response = await _http.get(_url);
        final data = extractData(response) as Map<String, dynamic>;
        final subscriberCount = int.parse(data["items"][0]["statistics"]["subscriberCount"]);
        final formattedCount = numberFormat.format(subscriberCount);
        _cache[name] = '$formattedCount fans';
        setResetTimeout(name);
        return _cache[name];
      } catch (e) {
        print(e);
      }
    } else if (name == '퇀') {
      _cache[name] = await getStats();
      setResetTimeout(name);
      return _cache[name];
    } else {
      return Future.value('');
    }
  }

  setResetTimeout(String name) {
    Future.delayed(Duration(minutes: 30), () {
      _cache.remove(name);
    });
  }

  Future<String> getStats() async {
    fs.Firestore firestore = fb.firestore(app);
    final latest = await firestore.collection("users").doc("SD9Do3G9ylbFMjVGeqdyaBO3LH02").collection("statistics")
      .orderBy("datetime", "desc")
      .limit(1)
      .get();
    final data = latest.docs.first.data();
    final knownCards = data['LearningProgress.known'] +
      data['LearningProgress.newish'] +
      data['LearningProgress.wellKnown'];
    final knownWords = numberFormat.format((knownCards / 2).toInt());
    return '$knownWords mots';
  }
}