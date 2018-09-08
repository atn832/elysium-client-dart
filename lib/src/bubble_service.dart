import 'bubble.dart';
import 'message.dart';

class BubbleService {
  List<Bubble> _bubbles = [];

  void addMessage(Message message) {
    _bubbles.add(Bubble(message.author, [message.message], message.time));
    print(_bubbles);
  }

  get bubbles => _bubbles;
}