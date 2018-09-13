import 'dart:async';
import 'dart:collection';
import 'dart:core';
import 'dart:math';

import 'package:angular/core.dart';
import 'package:http/http.dart';
import 'package:time_machine/time_machine.dart';

import 'bubble.dart';
import 'bubble_service.dart';
import 'chat_service.dart';
import 'geolocation_dartdevc_polyfill.dart';
import 'http_util.dart';
import 'location.dart';
import 'message.dart';
import 'person.dart';
import 'reverse_geocoding_service.dart';

/// Chat service that talks to the server over http.
@Injectable()
class HttpChatService extends ChatService {
  final Client _http;
  final ReverseGeocodingService _reverseGeocodingService;
  final Geolocation _geolocation;
  final bubbleService = BubbleService();
  final host = "/Elysium";

  Coordinates currentLocation;
  
  HttpChatService(this._http, this._reverseGeocodingService) :
      _geolocation = Geolocation(),
      signInCompleter = Completer() {
    signedIn = signInCompleter.future;
    bubbles = bubbleService.bubbles;
  }

  final _newMessage = StreamController<Null>();
  final _newUsers = StreamController<Null>();

  final Completer signInCompleter;
  Future signedIn;
  bool startedSignin = false;
	String username;
	String loginToken;
  int channelId;
	int userId;

  int clientMessageId = 0;
  int lastEventId = -1;
  HashMap<int, String> sentMessages = HashMap();
	
	final List<Person> userList = [];
  List<Bubble> bubbles;
  Bubble unsentBubble;
  
  Future signIn(String username) async {
    if (startedSignin) {
      print("Skipping signin");
      print(signedIn);
      return signedIn;
    }
    print("signing in " + username);
    startedSignin = true;

    this.username = username;
    try {
      final _loginUrl = "${host}/login.action?channel.name=Elysium&"
        "channel.password=&user.name=${username}";
      final response = await _http.get(_loginUrl);
      final data = extractData(response) as Map<String, dynamic>;
      loginToken = data["token"];
      userId = data["user"]["ID"];
      channelId = data["channel"]["ID"];

      startPolling();

      // Initialize message queue.
      unsentBubble = Bubble(Person(username), [], DateTime.now());

      // Initialize time zone info.
      await TimeMachine.initialize();

      // Track position.
      _geolocation.watchPosition(enableHighAccuracy: true, timeout: Duration(seconds: 1)).listen((p) {
        currentLocation = p.coordinates;
      });

      print("done signing in");
      signInCompleter.complete(true);
    } catch (e) {
      signInCompleter.complete();
      throw _handleError(e);
    }
    return signedIn;
  }

  startPolling() async {
    final events = await getMessages(true, -1, -1);
    updateMessageList(events);
    updateUserList(events);

    // TODO: Poll messages.
    getMoreMessages();
  }

  updateMessageList(events) {
    if (events == null) return;

    // Add new messages to the list.
    final newMessages = events["events"]
      .where((e) => e["eventType"]["type"] == "Message")
      .map((e) {
        // Remove from unsent bubble.
        String content = e["content"] as String;
        if (sentMessages.containsKey(e["ID"])) {
          unsentBubble.messages.remove(content);
        }
        // Reverse geocode.
        final location = e["source"]["location"];
        final loc = location != null ? Location(location["latitude"], location["longitude"]) : null;
        if (loc != null) {
          _reverseGeocodingService.reverseGeocode(loc.lat, loc.lng)
              .then((s) => loc.name = s);
        }
        // Parse the rest of the message.
        return Message(
            Person(e["source"]["entity"]["name"]),
            content,
            // Append Z to force UTC.
            DateTime.parse(e["source"]["datetime"] + " Z"),
            loc,
        );
      });
    if (newMessages.isNotEmpty) {
      newMessages.forEach((m) {
        final message = m as Message;
        // Add to bubbles.
        bubbleService.addMessage(message);
      });
      // Notify listeners.
      _newMessage.add(null);
    }

    // Update lastEventId.
    events["events"].forEach((e) {
      lastEventId = max(lastEventId, e["ID"]);
    });
  }

  updateUserList(events) {
    if (events == null) return;

    List<Person> newUserList = List();
    events["userList"]
      .map((u) {
        // print(u);
        final p = Person(u["name"]);
        try {
          p.timezone = u["latestSource"]["timeZone"]["timeZone"];
        } catch(e) {
          // fail silently.
        }
        return p;
      })
      .forEach((p) => newUserList.add(p));
    if (!areListsEqual(userList, newUserList)) {
      print("Updating user list");
      userList.removeRange(0, userList.length);
      userList.addAll(newUserList);
      // Notify of a change.
      _newUsers.add(null);
    }
  }

  bool areListsEqual(List<Person> l1, List<Person> l2) {
    if (l1.length != l2.length) return false;
    for (var i = 0; i < l1.length; i++) {
      if (l1[i] != l2[i]) return false;
    }
    return true;
  }

  getMoreMessages() async {
    try {
      final events = await getMessages(false, lastEventId, -1);
      updateMessageList(events);
      updateUserList(events);
    } catch (e) {
      print("get messages failed. keep retrying");
    }
    Timer(Duration(seconds:1), getMoreMessages);
  }

  dynamic getMessages(bool log, int lastEventId, int numMessages) async {
    final _getMessagesUrl = "${host}/getmessages.action?token=${loginToken}&"
      "userID=${userId}&log=${log}&lastEventID=${lastEventId}&numMessages=${numMessages}&" +
      "timeZone=${DateTimeZone.local}";
    final response = await _http.get(_getMessagesUrl);
    final data = extractData(response) as Map<String, dynamic>;
    if (data["chanUpdates"] == null) return null;
    final currentChanEvents = data["chanUpdates"].where((u) => u["chanID"] == channelId).first;
    return currentChanEvents;
  }

  Future<List<Bubble>> getBubbles() async {
    await signedIn;
    return bubbles;
  }

  Future<List<Person>> getUserList() async {
    await signedIn;
    return userList;
  }

  Future sendMessage(String message) async {
    unsentBubble.messages.add(message);
    unsentBubble.time = DateTime.now().toUtc();
    // Notify listeners.
    _newMessage.add(null);

    try {
      var base = Uri.base;
      final _sayUrl = Uri(
        scheme: base.scheme,
        host: base.host,
        path: "${host}/say.action",
        queryParameters: {
          "token": loginToken,
          "userID": userId.toString(),
          "destinationID": channelId.toString(),
          "clientMessageID": clientMessageId.toString(),
          "content": message,
          "timeZone": DateTimeZone.local.toString(),
          "location.latitude": currentLocation?.latitude.toString(),
          "location.longitude": currentLocation?.longitude.toString(),
        }
      ).toString();
      clientMessageId++;
      final response = await _http.get(_sayUrl);
      final data = extractData(response) as Map<String, dynamic>;
      final eventId = data["eventID"];
      sentMessages[eventId] = message;
    } catch (e) {
      // Display the error message.
      bubbleService.addMessage(Message(Person(username), e.toString(), DateTime.now().toUtc(), null));
      throw _handleError(e);
    }
  }

  Bubble getUnsentBubble() => unsentBubble;

  Stream<Null> get newMessage => _newMessage.stream;
  Stream<Null> get newUsers => _newUsers.stream;

  Exception _handleError(dynamic e) {
    print(e); // for demo purposes only
    return Exception('Server error; cause: $e');
  }
}
