import 'location.dart';
import 'person.dart';

class Bubble {
  final Person author;
  final List<String> messages;
  DateTime endTime;
  Location location;

  Bubble(this.author, this.messages, this.endTime);
}
