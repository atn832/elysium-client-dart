import 'dart:async';

import 'package:angular/core.dart';
import 'todo_list_service.dart';
import 'message.dart';
import 'person.dart';

/// Mock service emulating access to a to-do list stored on a server.
@Injectable()
class HttpChatService extends TodoListService {
	static final frun = Person("frun");
	
  List<Message> messageList = <Message>[
		Message(frun, "second service."),
  ];

  HttpChatService() {
	}

  Future<List<Message>> getTodoList() async => messageList;
}
