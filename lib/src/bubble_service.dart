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
        final timeDifference = latestBubble.time.difference(message.time);
        makeNewBubble = timeDifference > MinTimeBetweenBubbles;
      }
    }
    if (makeNewBubble) {
      _bubbles.add(Bubble(message.author, [message.message], message.time));
    } else {
      _bubbles[_bubbles.length - 1].messages.add(message.message);
    }
  }

  get bubbles => _bubbles;
}
