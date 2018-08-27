import 'dart:async';
import 'dart:convert';

import 'package:angular/core.dart';
import 'package:http/http.dart';

import 'todo_list_service.dart';
import '../message.dart';
import '../person.dart';

/// Mock service emulating access to a to-do list stored on a server.
@Injectable()
class HttpChatService extends TodoListService {
  static const _heroesUrl = "login.action?channel.name=Elysium&channel.password=&user.name=atn";
  static const _getmessagesUrl = "getmessages.action?token=155567289&userID=4&timeZone=America%2FLos_Angeles&log=true&lastEventID=-1&numMessages=-1";
  final Client _http;
  
  HttpChatService(this._http);
  
	static final frun = Person("frun");
	static final atn = Person("atn");
	
  List<Message> messageList = <Message>[
		Message(frun, "second service."),
  ];

  Future<List<Message>> getTodoList() async {
    try {
      final response = await _http.get(_heroesUrl);
      final data = _extractData(response) as Map<String, dynamic>;
      messageList.add(Message(frun, "Channel is " + (data["channel"]["name"] as String)));
      final response2 = await _http.get(_getmessagesUrl);
      final data2 = _extractData(response2) as Map<String, dynamic>;
      data2["chanUpdates"][0]["events"]
        .where((e) => e["eventType"]["type"] == "Message")
        .map((e) => e["content"])
        .forEach((s) => messageList.add(Message(atn, s as String)));
      return messageList;
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
