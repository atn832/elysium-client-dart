import 'dart:async';

import 'package:angular/core.dart';

import 'bubble.dart';
import 'bubble_service.dart';
import 'chat_service.dart';
import 'message.dart';
import 'person.dart';

/// Mock service emulating access to a to-do list stored on a server.
@Injectable()
class HardcodedChatService extends ChatService {
  static final frun = Person("frun");
  static final atn = Person("atn");

  List<Person> mockUserList = <Person>[frun, atn];

  List<Bubble> mockBubbles;

  BubbleService mockBubbleService = BubbleService();

  HardcodedChatService() {
    atn.timezone = "America/Los_Angeles";
    mockBubbles = mockBubbleService.bubbles;
    mockBubbleService.addMessage(Message(frun, "hello!", DateTime(2018, 8, 30)));
    mockBubbleService.addMessage(Message(frun, "i just landed.", DateTime(2018, 8, 30)));
		mockBubbleService.addMessage(Message(atn, "where are you?", DateTime(2018, 8, 31)));
		Timer.periodic(Duration(seconds:5), (t) {
      print("New artificial message");
			mockBubbleService.addMessage(Message(frun, "new message",  DateTime.now()));
    });
	}

  Future<List<Bubble>> getBubbles() async => mockBubbles;

  Future signIn(String username) {}
  
  Future<List<Person>> getUserList() async => mockUserList;
  
  Future sendMessage(String message) {
    mockBubbleService.addMessage(Message(atn, message, DateTime.now()));
  }

  Stream<Null> get newMessage => StreamController<Null>().stream;
  Stream<Null> get newUsers => StreamController<Null>().stream;
}
