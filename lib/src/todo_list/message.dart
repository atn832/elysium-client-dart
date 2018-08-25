import 'package:angular/core.dart';
import 'person.dart';

class Message {
	final Person author;
	final String message;
	
	Message(this.author, this.message);
}
