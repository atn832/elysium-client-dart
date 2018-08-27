import 'dart:async';
import 'dart:convert';

import 'package:angular/core.dart';
import 'package:http/http.dart';

import 'todo_list_service.dart';
import 'message.dart';
import 'person.dart';

/// Mock service emulating access to a to-do list stored on a server.
@Injectable()
class HttpChatService extends TodoListService {
  static const _heroesUrl = "https://m.wafrat.com/Elysium/login.action?sid=0.18527075621220002&channel.name=Elysium&channel.password=&user.name=atn&timeZone=Asia%2FSeoul&userAgent=Mozilla%2F5.0+(Macintosh%3B+Intel+Mac+OS+X+10_13_6)+AppleWebKit%2F537.36+(KHTML%2C+like+Gecko)+Chrome%2F68.0.3440.106+Safari%2F537.36";
  final Client _http;
  
  HttpChatService(this._http);
  
	static final frun = Person("frun");
	
  List<Message> messageList = <Message>[
		Message(frun, "second service."),
  ];

  Future<List<Message>> getTodoList() async {
    try {
      final response = await _http.get(_heroesUrl);
      final data = _extractData(response) as Map<String, dynamic>;
          // .map((json) => Hero.fromJson(json))
          // .toList();
      messageList.add(Message(frun, "teo"));
      messageList.add(Message(frun, data["channel"]["name"] as String));
      return messageList;
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  dynamic _extractData(Response resp) => json.decode(resp.body)['data'];
  
  Exception _handleError(dynamic e) {
    print(e); // for demo purposes only
    return Exception('Server error; cause: $e');
  }
}
