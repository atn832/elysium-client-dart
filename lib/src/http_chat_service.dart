import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:angular/core.dart';
import 'package:http/http.dart';

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

  Completer signInCompleter;
  Future signedIn;
  bool startedSignin = false;
	String username;
	String loginToken;
  int channelId;
	int userId;

  int clientMessageId = 0;
  int lastEventId = -1;
	
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
    events["events"]
      .where((e) => e["eventType"]["type"] == "Message")
      .map((e) => Message(Person(e["source"]["entity"]["name"]), e["content"] as String))
      .forEach((m) => messageList.add(m));
    events["events"].forEach((e) {
      lastEventId = max(lastEventId, e["ID"]);
    });
  }

  updateUserList(events) {
    events["userList"]
      .map((u) => Person(u["name"]))
      .forEach((p) => userList.add(p));
  }

  getMoreMessages() async {
    print("Getting more messages");
    getMessages(false, lastEventId, -1);
    Timer(Duration(seconds:2), this.getMoreMessages);
  }

  dynamic getMessages(bool log, int lastEventId, int numMessages) async {
    final _getMessagesUrl = "${host}/getmessages.action?token=${loginToken}&"
      "userID=${userId}&log=${log}&lastEventID=${lastEventId}&numMessages=${numMessages}";
    final response = await _http.get(_getMessagesUrl);
    final data = _extractData(response) as Map<String, dynamic>;
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
        }
      ).toString();
      clientMessageId++;
      final response = await _http.get(_sayUrl);
      messageList.add(Message(Person(username), message));
    } catch (e) {
      throw _handleError(e);
    }
  }

  dynamic _extractData(Response resp) => json.decode(resp.body);
  
  Exception _handleError(dynamic e) {
    print(e); // for demo purposes only
    return Exception('Server error; cause: $e');
  }
}
