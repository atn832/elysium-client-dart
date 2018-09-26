import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:time_machine/time_machine.dart';

import '../chat_service.dart';
import '../color_service.dart';
import '../person.dart';

@Component(
  selector: 'user-list',
  styleUrls: ['user_list_component.css'],
  templateUrl: 'user_list_component.html',
  directives: [
    MaterialChipComponent,
    materialInputDirectives,
    NgFor,
    NgIf,
  ],
)
class UserListComponent implements OnInit {
  final ChatService chatService;
  final ColorService _colorService;

  List<Person> items = [];
  Map<String, DateTimeZone> timezones = Map();
  Map<String, String> timezoneToShortTimezone = Map();

  UserListComponent(this.chatService, this._colorService);

  @override
  Future<Null> ngOnInit() async {
    items = await chatService.getUserList();
    this.chatService.newUsers.listen((e) async {
      collectMissingTimeZonesFromUsers();
    });
  }

  String getColorClass(Person person) {
    return _colorService.getColorClass(person);
  }

  String getShortTimezone(String timezone) {
    if (timezoneToShortTimezone.containsKey(timezone)) {
      return timezoneToShortTimezone[timezone];
    }
    String result;
    if (timezone.contains("/")) {
      result = timezone.split("/")[1].replaceAll("_", " ");
    } else {
      // Support "UTC".
      result = timezone;
    }
    timezoneToShortTimezone[timezone] = result;
    return result;
  }

  String getLocalTime(String timezone) {  
    final now = Instant.now();
    final tz = timezones[timezone];
    if (tz == null) return "";

    final localTime = now.inZone(tz);
    return localTime.toStringDDC('ddd HH:mm');
  }

  void collectMissingTimeZonesFromUsers() async {
    final users = await this.chatService.getUserList();
    users.forEach((u) async {
      final timezone = u.timezone;
      if (timezone == null || timezones.containsKey(timezone)) return;

      try {
        await TimeMachine.initialize();
        final tzdb = await DateTimeZoneProviders.tzdb;
        var tz = await tzdb[timezone];
        timezones[timezone] =  tz;
      } catch(e) {
        print("Could not get timezone info for " + timezone + ": " + e);
      }
    });
  }
}
