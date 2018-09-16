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

  test('first message, first bubble', () {
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
    expect(firstAndOnlyBubble.time, secondMessageTime);
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
    expect(bubbles[0].time, firstMessageTime);
    expect(bubbles[1].messages.length, 1);
    expect(bubbles[1].messages[0], 'i am here');
    expect(bubbles[1].time, secondMessageTime);
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
    expect(bubbles[0].time, firstMessageTime);
    expect(bubbles[0].author.name, 'atn');
    
    expect(bubbles[1].messages.length, 1);
    expect(bubbles[1].messages[0], 'hello back');
    expect(bubbles[1].time, secondMessageTime);
    expect(bubbles[1].author.name, 'frun');
  });

}
