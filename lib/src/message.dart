import 'person.dart';

class Message {
	final Person author;
	final String message;
  final DateTime time;
	
	Message(this.author, this.message, this.time);
}
