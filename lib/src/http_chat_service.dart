import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:core';
import 'dart:math';

import 'package:angular/core.dart';
import 'package:http/http.dart';
import 'package:time_machine/time_machine.dart';

import 'chat_service.dart';
import 'message.dart';
import 'person.dart';

/// Chat service that talks to the server over http.
@Injectable()
class HttpChatService extends ChatService {
  final Client _http;
  final host = "/Elysium";
  
  HttpChatService(this._http) {
    signInCompleter = Completer();
    signedIn = signInCompleter.future;
  }

  final _newMessage = StreamController<Null>();
  final _newUsers = StreamController<Null>();

  Completer signInCompleter;
  Future signedIn;
  bool startedSignin = false;
	String username;
	String loginToken;
  int channelId;
	int userId;

  int clientMessageId = 0;
  int lastEventId = -1;
  HashSet<int> sentMessageEventIds = HashSet();
	
	List<Person> userList = <Person>[];
  List<Message> messageList = <Message>[];
  
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
      final data = _extractData(response) as Map<String, dynamic>;
      loginToken = data["token"];
      userId = data["user"]["ID"];
      channelId = data["channel"]["ID"];

      startPolling();

      // Initialize time zone info.
      await TimeMachine.initialize();

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
    // updateMessageList(events);
    // updateUserList(events);

    // TODO: Poll messages.
    getMoreMessages();
  }

  updateMessageList(events) {
    if (events == null) return;

    // Add new messages to the list.
    final newMessages = events["events"]
      .where((e) => e["eventType"]["type"] == "Message" && !sentMessageEventIds.contains(e["ID"]))
      .map((e) => Message(Person(
          e["source"]["entity"]["name"]),
          e["content"] as String,
          // Append Z to force UTC.
          DateTime.parse(e["source"]["datetime"] + " Z"),
      ));
    if (newMessages.isNotEmpty) {
      newMessages.forEach((m) => messageList.add(m));
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
      if (!arePersonsEqual(l1[i], l2[i])) return false;
    }
    return true;
  }

  bool arePersonsEqual(Person p1, Person p2) {
    return p1.name == p2.name && p1.timezone == p2.timezone;
  }

  getMoreMessages() async {
    try {
      final events = await getMessages(false, lastEventId, -1);
      updateMessageList(events);
      updateUserList(events);
    } catch (e) {
      print("get messages failed. keep retrying");
    }
    // Timer(Duration(seconds:1), getMoreMessages);
  }

  dynamic getMessages(bool log, int lastEventId, int numMessages) async {
    final _getMessagesUrl = "${host}/getmessages.action?token=${loginToken}&"
      "userID=${userId}&log=${log}&lastEventID=${lastEventId}&numMessages=${numMessages}&" +
      "timeZone=${DateTimeZone.local}";
    final response = await _http.get(_getMessagesUrl);
    final data = _extractData(response) as Map<String, dynamic>;
    if (data["chanUpdates"] == null) return null;
    final currentChanEvents = data["chanUpdates"].where((u) => u["chanID"] == channelId).first;
    return currentChanEvents;
  }

  Future<List<Message>> getMessageList() async {
    await signedIn;
    return messageList;
  }
  
  Future<List<Person>> getUserList() async {
    await signedIn;
    return userList;
  }

  Future sendMessage(String message) async {
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
        }
      ).toString();
      clientMessageId++;
      final response = await _http.get(_sayUrl);
      final data = _extractData(response) as Map<String, dynamic>;
      final eventId = data["eventID"];
      sentMessageEventIds.add(eventId);
      messageList.add(Message(Person(username), message, DateTime.now().toUtc()));
      // Notify listeners.
      _newMessage.add(null);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Stream<Null> get newMessage => _newMessage.stream;
  Stream<Null> get newUsers => _newUsers.stream;

  dynamic _extractData(Response resp) => json.decode(resp.body);

  Exception _handleError(dynamic e) {
    print(e); // for demo purposes only
    return Exception('Server error; cause: $e');
  }
}
