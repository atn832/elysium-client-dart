import 'bubble.dart';
import 'message.dart';

const MinTimeBetweenBubbles = Duration(minutes: 5);

class BubbleService {
  List<Bubble> _bubbles = [];

  void addMessage(Message message) {
    bool makeNewBubble = false;
    if (_bubbles.length == 0) {
      makeNewBubble = true;
    } else {
      final latestBubble = _bubbles[_bubbles.length - 1];
      if (latestBubble.author != message.author) {
        makeNewBubble = true;
      } else {
        final timeDifference = message.time.difference(latestBubble.time);
        print(timeDifference);
        makeNewBubble = timeDifference > MinTimeBetweenBubbles;
      }
    }
    if (makeNewBubble) {
      final b = Bubble(message.author, [message.message], message.time);
      b.location = message.location;
      _bubbles.add(b);
    } else {
      final latestBubble = _bubbles[_bubbles.length - 1];
      latestBubble.messages.add(message.message);
      latestBubble.time = message.time;
      latestBubble.location = message.location;
    }
  }

  get bubbles => _bubbles;
}
