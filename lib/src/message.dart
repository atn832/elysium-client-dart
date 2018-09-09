import 'person.dart';
import 'location.dart';

class Message {
	final Person author;
	final String message;
  final DateTime time;
  final Location location;
	
	Message(this.author, this.message, this.time, this.location);
}
