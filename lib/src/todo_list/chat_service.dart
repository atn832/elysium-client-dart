import 'dart:async';

import 'package:angular/core.dart';
import '../message.dart';
import '../person.dart';

/// Mock service emulating access to a to-do list stored on a server.
@Injectable()
class ChatService {
  static final frun = Person("frun");
  static final atn = Person("atn");

  List<Person> mockUserList = <Person>[frun, atn];

  List<Message> mockTodoList = <Message>[
		Message(frun, "hello!\ni just landed."),
		Message(atn, "where are you?")
	];

  ChatService() {
		Timer.periodic(Duration(seconds:2), (t) => mockTodoList.add(
			Message(frun, "new message")
		));
	}

  Future<List<Message>> getTodoList() async => mockTodoList;

  setUsername(String username) {}
  
  Future<List<Person>> getUserList() async => mockUserList;
  
  sendMessage(String message) {
    mockTodoList.add(Message(atn, message));
  }
}
