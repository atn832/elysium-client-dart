import 'dart:async';
import 'dart:convert';

import 'package:angular/core.dart';
import 'package:http/http.dart';

import 'chat_service.dart';
import '../message.dart';
import '../person.dart';

/// Chat service that talks to the server over Http.
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
	int userId;
	
	List<Person> userList = <Person>[];
  List<Message> messageList = <Message>[];
  
  Future signIn(String username) async {
    if (startedSignin) {
      print("Skipping signin");
      print(signedIn);
      return signedIn;
    }
    print("signing in");
    startedSignin = true;

    this.username = username;
    try {
      print("login");
      final _loginUrl = "${host}/login.action?channel.name=Elysium&"
        "channel.password=&user.name=${username}";
      final response = await _http.get(_loginUrl);
      final data = _extractData(response) as Map<String, dynamic>;
      loginToken = data["token"];
      userId = data["user"]["ID"];

      print("getmessages");
      final _getmessagesUrl = "${host}/getmessages.action?token=${loginToken}&"
        "userID=${userId}&log=true&lastEventID=-1&numMessages=-1";
      final response2 = await _http.get(_getmessagesUrl);
      final data2 = _extractData(response2) as Map<String, dynamic>;
      final firstChanEvents = data2["chanUpdates"][0];
      firstChanEvents["events"]
        .where((e) => e["eventType"]["type"] == "Message")
        .map((e) => Message(Person(e["source"]["entity"]["name"]), e["content"] as String))
        .forEach((m) => messageList.add(m));
      
      firstChanEvents["userList"]
        .map((u) => Person(u["name"]))
        .forEach((p) => userList.add(p));
        
      print("done signing in");
      print(userList);

      signInCompleter.complete(true);
    } catch (e) {
      signInCompleter.complete();
      throw _handleError(e);
    }
    return signedIn;
  }

  Future<List<Message>> getTodoList() async {
    print("getTodoList");
    await signedIn;
    return messageList;
  }
  
  Future<List<Person>> getUserList() async {
    print("getUserList");
    await signedIn;
    return userList;
  }

  sendMessage(String message) {
    // TODO: run say.action
    messageList.add(Message(Person(username), message));
  }

  dynamic _extractData(Response resp) => json.decode(resp.body);
  
  Exception _handleError(dynamic e) {
    print(e); // for demo purposes only
    return Exception('Server error; cause: $e');
  }
}
