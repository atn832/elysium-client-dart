import 'person.dart';

class Bubble {
  final Person author;
  final List<String> messages;
  DateTime time;

  Bubble(this.author, this.messages, this.time);
}
