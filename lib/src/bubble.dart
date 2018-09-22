import 'date_range.dart';
import 'location.dart';
import 'person.dart';

class Bubble {
  final Person author;
  final List<String> messages;
  DateRange dateRange;
  Location location;

  Bubble(this.author, this.messages, DateTime time) : dateRange = DateRange(time, time);
}
