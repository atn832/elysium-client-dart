import 'person.dart';

class Message {
	final Person author;
	final String message;
  DateTime time;
	
	Message(this.author, this.message, this.time);
}
