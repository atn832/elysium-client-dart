import 'dart:async';
import 'dart:convert';

import 'package:angular/core.dart';
import 'package:http/http.dart';

import 'chat_service.dart';
import '../message.dart';
import '../person.dart';

/// Mock service emulating access to a to-do list stored on a server.
@Injectable()
class HttpChatService extends ChatService {
  final Client _http;
  
  HttpChatService(this._http);
  
	String username;
	String loginToken;
	int userId;
	
	List<Person> userList = <Person>[];
  List<Message> messageList = <Message>[];
  
  setUsername(String username) {
    this.username = username;
  }

  Future<List<Message>> getTodoList() async {
    try {
      final _loginUrl = "login.action?channel.name=Elysium&channel.password=&"
        "user.name=${username}";
      final response = await _http.get(_loginUrl);
      final data = _extractData(response) as Map<String, dynamic>;
      loginToken = data["token"];
      userId = data["user"]["ID"];
      
      final _getmessagesUrl = "getmessages.action?token=${loginToken}&"
        "userID=${userId}&log=true&lastEventID=-1&numMessages=-1";
      final response2 = await _http.get(_getmessagesUrl);
      final data2 = _extractData(response2) as Map<String, dynamic>;
      final firstChanEvents = data2["chanUpdates"][0];
      firstChanEvents["events"]
        .where((e) => e["eventType"]["type"] == "Message")
        .map((e) => Message(Person(e["source"]["entity"]["name"]), e["content"] as String))
        .forEach((m) => messageList.add(m));
      
      userList = [];
      firstChanEvents["userList"]
        .map((u) => Person(u["name"]))
        .forEach((p) => userList.add(p));

      return messageList;
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<List<Person>> getUserList() async {
    await getTodoList();
    return userList;
  }

  dynamic _extractData(Response resp) => json.decode(resp.body);
  
  Exception _handleError(dynamic e) {
    print(e); // for demo purposes only
    return Exception('Server error; cause: $e');
  }
}
