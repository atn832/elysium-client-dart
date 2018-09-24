import 'dart:async';
import 'dart:html';

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

  final List<Person> mockUserList = <Person>[frun, atn];
  List<Bubble> mockBubbles;
  Bubble mockUnsentBubble;

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

    mockUnsentBubble = Bubble(atn, ["looks like I lost connectivity"], DateTime.now());
	}

  Future<List<Bubble>> getBubbles() async => mockBubbles;
  Bubble getUnsentBubble() => mockUnsentBubble;

  Future signIn(String username) {}
  
  Future<List<Person>> getUserList() async => mockUserList;
  
  Future sendMessage(String message) {
    mockBubbleService.addMessage(Message(atn, message, DateTime.now(), null));
  }

  Future<void> getOlderMessages() async {
    await Future.delayed(Duration(seconds: 5));

    final oldestTime = mockBubbles[0].dateRange.startTime;
    final wayOlder = oldestTime.subtract(Duration(hours: 1));
    for (var i = 0; i < 10; i++) {
      mockBubbleService.addMessage(Message(Person('atn'), 'message ' + i.toString(), wayOlder, null));
    }
  }

  Stream<Null> get newMessage => StreamController<Null>().stream;
  Stream<Null> get newUsers => StreamController<Null>().stream;

  get supportsUpload => true;
  Future sendFiles(List<File> files) {
    return Future.delayed(Duration(seconds: 5));
  }
}
