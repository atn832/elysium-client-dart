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

  test('two messages, one bubble', () {
    final List<Bubble> bubbles = bubbleService.bubbles;
    const location = null;
    final bool newerMessage = bubbleService.addMessage(Message(Person('atn'), 'hello', DateTime.now(), location));
    expect(bubbles.length, 1);
    final firstAndOnlyBubble = bubbles[0];
    expect(firstAndOnlyBubble.messages.length, 1);
    expect(firstAndOnlyBubble.messages[0], 'hello');
    expect(newerMessage, true);

    // Add a second message.
    final secondMessageTime = DateTime.now().add(Duration(minutes: 1));
    final bool secondNewerMessage = bubbleService.addMessage(Message(Person('atn'), 'i am here', secondMessageTime, location));
    // It should have reused the same bubble.
    expect(bubbles.length, 1);
    expect(firstAndOnlyBubble.messages.length, 2);
    expect(firstAndOnlyBubble.messages[1], 'i am here');
    expect(firstAndOnlyBubble.dateRange.endTime, secondMessageTime);
    expect(secondNewerMessage, true);
  });

  test('two bubbles if messaging again after 10 minutes', () {
    final List<Bubble> bubbles = bubbleService.bubbles;
    const location = null;
    final firstMessageTime = DateTime.now();
    final bool newerMessage = bubbleService.addMessage(Message(Person('atn'), 'hello', firstMessageTime, location));
    expect(bubbles.length, 1);
    expect(bubbles[0].messages.length, 1);
    expect(newerMessage, true);

    // Add a second message long after the first one.
    final durationBetweenTheMessages = Duration(minutes: 10);
    final secondMessageTime = DateTime.now().add(durationBetweenTheMessages);
    final bool secondNewerMessage = bubbleService.addMessage(Message(Person('atn'), 'i am here', secondMessageTime, location));
    // It should have created a second bubble.
    expect(bubbles.length, 2);
    expect(bubbles[0].messages.length, 1);
    expect(bubbles[0].dateRange.endTime, firstMessageTime);
    expect(bubbles[1].messages.length, 1);
    expect(bubbles[1].messages[0], 'i am here');
    expect(bubbles[1].dateRange.endTime, secondMessageTime);
    expect(secondNewerMessage, true);
  });

  test('two bubbles from different authors', () {
    final List<Bubble> bubbles = bubbleService.bubbles;
    const location = null;
    final firstMessageTime = DateTime.now();
    final bool newerMessage = bubbleService.addMessage(Message(Person('atn'), 'hello', firstMessageTime, location));
    expect(bubbles.length, 1);
    expect(bubbles[0].messages.length, 1);
    expect(newerMessage, true);

    // Add a second message long after the first one.
    final secondMessageTime = DateTime.now().add(Duration(minutes: 1));
    final bool secondNewerMessage = bubbleService.addMessage(Message(Person('frun'), 'hello back', secondMessageTime, location));

    // It should have created a second bubble.
    expect(bubbles.length, 2);
    expect(bubbles[0].messages.length, 1);
    expect(bubbles[0].dateRange.endTime, firstMessageTime);
    expect(bubbles[0].author.name, 'atn');
    
    expect(bubbles[1].messages.length, 1);
    expect(bubbles[1].messages[0], 'hello back');
    expect(bubbles[1].dateRange.endTime, secondMessageTime);
    expect(bubbles[1].author.name, 'frun');
    expect(secondNewerMessage, true);
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

  test('new bubble if receiving very old message', () {
    final List<Bubble> bubbles = bubbleService.bubbles;
    const location = null;
    final firstMessageTime = DateTime.now();
    bubbleService.addMessage(Message(Person('atn'), 'hello', firstMessageTime, location));
    expect(bubbles.length, 1);
    expect(bubbles[0].messages.length, 1);

    // Add a second message long before the first one.
    final oldMessageTime = firstMessageTime.subtract(Duration(minutes: 30));
    final bool newerMessage = bubbleService.addMessage(Message(Person('atn'), 'i am here', oldMessageTime, location));
    // It should have prepended a new bubble.
    expect(bubbles.length, 2);
    expect(bubbles[0].messages.length, 1);
    expect(bubbles[0].dateRange.startTime, oldMessageTime);
    expect(bubbles[0].messages[0], 'i am here');

    expect(bubbles[1].messages.length, 1);
    expect(bubbles[1].messages[0], 'hello');
    expect(bubbles[1].dateRange.endTime, firstMessageTime);
    expect(newerMessage, false);
  });

  test('merge to previous bubble if old message from 3 minutes after', () {
    final List<Bubble> bubbles = bubbleService.bubbles;
    const location = null;
    final firstMessageTime = DateTime.now();
    bubbleService.addMessage(Message(Person('atn'), 'hello', firstMessageTime, location));
    expect(bubbles.length, 1);
    expect(bubbles[0].messages.length, 1);

    // Add a second message long after the first one.
    final oldMessageTime = firstMessageTime.subtract(Duration(minutes: 3));
    final bool newerMessage = bubbleService.addMessage(Message(Person('atn'), 'i am here', oldMessageTime, location));
    // It should have prepended the message to the only bubble.
    expect(bubbles.length, 1);
    expect(bubbles[0].messages.length, 2);
    expect(bubbles[0].dateRange.startTime, oldMessageTime);
    expect(bubbles[0].messages[0], 'i am here');
    expect(bubbles[0].messages[1], 'hello');
    expect(bubbles[0].dateRange.endTime, firstMessageTime);
    expect(newerMessage, false);
  });
}
