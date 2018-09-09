import 'dart:async';

import 'package:angular/core.dart';

import 'bubble.dart';
import 'bubble_service.dart';
import 'chat_service.dart';
import 'location.dart';
import 'message.dart';
import 'person.dart';
import 'reverse_geocoding_service.dart';

/// Mock service emulating access to a to-do list stored on a server.
@Injectable()
class HardcodedChatService extends ChatService {
  static final frun = Person("frun");
  static final atn = Person("atn");

  List<Person> mockUserList = <Person>[frun, atn];
  List<Bubble> mockBubbles;

  BubbleService mockBubbleService = BubbleService();
  ReverseGeocodingService _reverseGeocodingService;

  HardcodedChatService(this. _reverseGeocodingService) {
    Location location = Location(0.0, 0.0);
    _reverseGeocodingService.reverseGeocode(location.lat, location.lng)
        .then((s) => location.name = s);
    location.name = "Narita Airport";
    atn.timezone = "America/Los_Angeles";
    mockBubbles = mockBubbleService.bubbles;
    mockBubbleService.addMessage(Message(frun, "hello!", DateTime(2018, 8, 30), location));
    mockBubbleService.addMessage(Message(frun, "i just landed.", DateTime(2018, 8, 30), location));
		mockBubbleService.addMessage(Message(atn, "where are you?", DateTime(2018, 8, 31), null));
		Timer.periodic(Duration(seconds:5), (t) {
      print("New artificial message");
			mockBubbleService.addMessage(Message(frun, "new message",  DateTime.now(), location));
    });
	}

  Future<List<Bubble>> getBubbles() async => mockBubbles;

  Future signIn(String username) {}
  
  Future<List<Person>> getUserList() async => mockUserList;
  
  Future sendMessage(String message) {
    mockBubbleService.addMessage(Message(atn, message, DateTime.now(), null));
  }

  Stream<Null> get newMessage => StreamController<Null>().stream;
  Stream<Null> get newUsers => StreamController<Null>().stream;
}
