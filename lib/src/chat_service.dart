import 'dart:async';

import 'package:angular/core.dart';

import 'bubble.dart';
import 'message.dart';
import 'person.dart';

/// Mock service emulating access to a to-do list stored on a server.
@Injectable()
class ChatService {
  static final frun = Person("frun");
  static final atn = Person("atn");

  List<Person> mockUserList = <Person>[frun, atn];

  List<Message> mockMessageList = <Message>[
		Message(frun, "hello!\ni just landed.", DateTime(2018, 8, 30)),
		Message(atn, "where are you?",  DateTime(2018, 8, 31))
	];
  List<Bubble> mockBubbles = <Bubble>[
		Bubble(frun, ["hello!", "i just landed."], DateTime(2018, 8, 30)),
		Bubble(atn, ["where are you?"], DateTime(2018, 8, 31)),
  ];

  ChatService() {
		Timer.periodic(Duration(seconds:2), (t) => mockMessageList.add(
			Message(frun, "new message",  DateTime.now())
		));
	}

  Future<List<Message>> getMessageList() async => mockMessageList;
  Future<List<Bubble>> getBubbles() async => mockBubbles;

  Future signIn(String username) {}
  
  Future<List<Person>> getUserList() async => mockUserList;
  
  Future sendMessage(String message) {
    mockMessageList.add(Message(atn, message, DateTime.now()));
  }

  Stream<Null> get newMessage => StreamController<Null>().stream;
  Stream<Null> get newUsers => StreamController<Null>().stream;

}
