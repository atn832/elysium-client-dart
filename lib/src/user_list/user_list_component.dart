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
    print("getShortTimeZone");
    return timezone.split("/")[1].replaceAll("_", " ");
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

      final tzdb = await DateTimeZoneProviders.tzdb;
      var tz = await tzdb[timezone];
      timezones[timezone] =  tz;
    });
  }
}
