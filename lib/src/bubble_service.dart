import 'package:meta/meta.dart';

import 'bubble.dart';
import 'message.dart';

const MinTimeBetweenBubbles = Duration(minutes: 5);

class BubbleService {
  List<Bubble> _bubbles = [];

  /**
   * @return {bool} whether a newer message was added.
   */
  bool addMessage(Message message) {
    final insertionIndex = getInsertionIndex(message.time);
    final prepended = _maybePrependToNextBubble(insertionIndex, message);
    if (prepended) return false;
    final appended = _maybeAppendToPreviousBubble(insertionIndex, message);
    if (appended) return true;

    // Make a new bubble.
    final b = Bubble(message.author, [message.message], message.time);
    b.location = message.location;
    final bool last = insertionIndex == _bubbles.length;
    _bubbles.insert(insertionIndex, b);
    return last;
  }

  bool _maybePrependToNextBubble(int insertionIndex, Message message) {
    // Check if we can prepend with the next one.
    final nextBubble = insertionIndex < _bubbles.length ? _bubbles[insertionIndex] : null;
    if (nextBubble != null && nextBubble.author == message.author) {
      // Check if the time difference is alright.
      final timeDifference = nextBubble.dateRange.startTime.difference(message.time);
      if (timeDifference < MinTimeBetweenBubbles) {
        // Prepend.
        nextBubble.messages.insert(0, message.message);
        nextBubble.dateRange.expand(message.time);
        // Do not update location since we store the latest location.
        return true;
      } 
    }
    return false;
  }

  bool _maybeAppendToPreviousBubble(int insertionIndex, Message message) {
    // Check if we can append to the previous one.
    final prevBubble = insertionIndex - 1 >= 0 ? _bubbles[insertionIndex - 1] : null;
    if (prevBubble != null && prevBubble.author == message.author) {
      // Check if the time difference is alright.
      final timeDifference = message.time.difference(prevBubble.dateRange.endTime);
      if (timeDifference < MinTimeBetweenBubbles) {
        // Append.
        prevBubble.messages.add(message.message);
        prevBubble.dateRange.expand(message.time);
        prevBubble.location = message.location;        
        return true;
      } 
    }
    return false;
  }

  /**
   * Computes the index at which to insert the message. Later we have to decide
   * whether to create a new bubble or not.
   * 0 means beginning,
   * length means at the end.
   */
  @visibleForTesting
  int getInsertionIndex(DateTime time) {
    return _getInsertionIndex(0, _bubbles.length, time);
  }

  int _getInsertionIndex(int start, int end, DateTime time) {
    if (start >= end) {
      return start;
    }
    final midIndex = (start + end) ~/ 2;
    if (_bubbles[midIndex].dateRange.isAfter(time)) {
      return _getInsertionIndex(start, midIndex, time);
    } else {
      return _getInsertionIndex(midIndex + 1, end, time);
    }
  }

  get bubbles => _bubbles;

  clear() {
    _bubbles.clear();
  }

  keepLatestBubbles(int latestToKeep) {
    if (_bubbles.length - latestToKeep <= 0) return;

    _bubbles.removeRange(0, _bubbles.length - latestToKeep);
  }
}
