@TestOn('browser')

import 'package:angular_test/angular_test.dart';
import 'package:test/test.dart';

import 'package:elysium_client/src/bubble_service.dart';
import 'package:elysium_client/src/bubble.dart';
import 'package:elysium_client/src/message.dart';
import 'package:elysium_client/src/person.dart';

void main() {
  BubbleService bubbleService;

  setUp(() {
    bubbleService = BubbleService();
  });

  tearDown(disposeAnyRunningTest);

  test('empty initial state', () {
    final bubbles = bubbleService.bubbles;
    expect(bubbles.isEmpty, true);
  });

  test('bubble constructor times', () {
    Person author = Person('atn');
    final time = DateTime.now();
    final bubble = Bubble(author, [], time);
    expect(bubble.dateRange.startTime, time);
    expect(bubble.dateRange.endTime, time);
  });

  test('first messages, one bubble', () {
    final List<Bubble> bubbles = bubbleService.bubbles;
    const location = null;
    bubbleService.addMessage(Message(Person('atn'), 'hello', DateTime.now(), location));
    expect(bubbles.length, 1);
    final firstAndOnlyBubble = bubbles[0];
    expect(firstAndOnlyBubble.messages.length, 1);
    expect(firstAndOnlyBubble.messages[0], 'hello');

    // Add a second message.
    final secondMessageTime = DateTime.now().add(Duration(minutes: 1));
    bubbleService.addMessage(Message(Person('atn'), 'i am here', secondMessageTime, location));
    // It should have reused the same bubble.
    expect(bubbles.length, 1);
    expect(firstAndOnlyBubble.messages.length, 2);
    expect(firstAndOnlyBubble.messages[1], 'i am here');
    expect(firstAndOnlyBubble.dateRange.endTime, secondMessageTime);
  });

  test('two bubbles if messaging again after 10 minutes', () {
    final List<Bubble> bubbles = bubbleService.bubbles;
    const location = null;
    final firstMessageTime = DateTime.now();
    bubbleService.addMessage(Message(Person('atn'), 'hello', firstMessageTime, location));
    expect(bubbles.length, 1);
    expect(bubbles[0].messages.length, 1);

    // Add a second message long after the first one.
    final durationBetweenTheMessages = Duration(minutes: 10);
    final secondMessageTime = DateTime.now().add(durationBetweenTheMessages);
    bubbleService.addMessage(Message(Person('atn'), 'i am here', secondMessageTime, location));
    // It should have created a second bubble.
    expect(bubbles.length, 2);
    expect(bubbles[0].messages.length, 1);
    expect(bubbles[0].dateRange.endTime, firstMessageTime);
    expect(bubbles[1].messages.length, 1);
    expect(bubbles[1].messages[0], 'i am here');
    expect(bubbles[1].dateRange.endTime, secondMessageTime);
  });

  test('two bubbles from different authors', () {
    final List<Bubble> bubbles = bubbleService.bubbles;
    const location = null;
    final firstMessageTime = DateTime.now();
    bubbleService.addMessage(Message(Person('atn'), 'hello', firstMessageTime, location));
    expect(bubbles.length, 1);
    expect(bubbles[0].messages.length, 1);

    // Add a second message long after the first one.
    final secondMessageTime = DateTime.now().add(Duration(minutes: 1));
    bubbleService.addMessage(Message(Person('frun'), 'hello back', secondMessageTime, location));

    // It should have created a second bubble.
    expect(bubbles.length, 2);
    expect(bubbles[0].messages.length, 1);
    expect(bubbles[0].dateRange.endTime, firstMessageTime);
    expect(bubbles[0].author.name, 'atn');
    
    expect(bubbles[1].messages.length, 1);
    expect(bubbles[1].messages[0], 'hello back');
    expect(bubbles[1].dateRange.endTime, secondMessageTime);
    expect(bubbles[1].author.name, 'frun');
  });

  test('getInsertionIndex with no bubble', () {
    final now = DateTime.now();
    expect(bubbleService.getInsertionIndex(now), 0);
  });

  test('getInsertionIndex after the first bubble', () {
    final now = DateTime.now();
    const location = null;
    final firstMessageTime = DateTime.now();
    bubbleService.addMessage(Message(Person('atn'), 'hello', firstMessageTime, location));
  
    final after = now.add(Duration(minutes: 1));
    expect(bubbleService.getInsertionIndex(after), 1);
  });

  test('getInsertionIndex before the first bubble', () {
    final now = DateTime.now();
    const location = null;
    final firstMessageTime = DateTime.now();
    bubbleService.addMessage(Message(Person('atn'), 'hello', firstMessageTime, location));
  
    final before = now.subtract(Duration(minutes: 1));
    expect(bubbleService.getInsertionIndex(before), 0);
  });

  test('getInsertionIndex between two bubbles', () {
    final now = DateTime.now();
    const location = null;
    final firstMessageTime = DateTime.now();
    bubbleService.addMessage(Message(Person('atn'), 'hello', firstMessageTime, location));
    final secondBubbleTime = firstMessageTime.add(Duration(minutes: 20));
    bubbleService.addMessage(Message(Person('atn'), 'hello again', secondBubbleTime, location));
  
    final betweenBubbles = now.add(Duration(minutes: 10));
    expect(bubbleService.getInsertionIndex(betweenBubbles), 1);

    final afterBubbles = secondBubbleTime.add(Duration(minutes: 10));
    expect(bubbleService.getInsertionIndex(afterBubbles), 2);
  });

}
