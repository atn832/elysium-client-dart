import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:time_machine/time_machine.dart';

import '../api_key.dart';
import '../color_service.dart';
import '../location.dart';
import '../person.dart';

@Component(
  selector: 'user-list',
  styleUrls: ['user_list_component.css'],
  templateUrl: 'user_list_component.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
  directives: [
    MaterialChipComponent,
    materialInputDirectives,
    NgFor,
    NgIf,
  ],
)
class UserListComponent {
  final ColorService _colorService;

  @Input()
  List<Person> users;

  Map<String, DateTimeZone> timezones = Map();
  Map<String, String> timezoneToShortTimezone = Map();
  ChangeDetectorRef ref;

  UserListComponent(this._colorService, ChangeDetectorRef this.ref) {
    Timer.periodic(Duration(seconds: 3), (t) {
      collectMissingTimeZonesFromUsers();
    });
  }

  markForCheck() {
    ref.markForCheck();
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
    if (timezone == null || !timezones.containsKey(timezone)) {
      return "";
    }

    final tz = timezones[timezone];
    final now = Instant.now();
    final localTime = now.inZone(tz);
    return localTime.toStringDDC('ddd HH:mm');
  }

  void collectMissingTimeZonesFromUsers() async {
    if (users == null) return;

    users.forEach((u) async {
      final timezone = u.timezone;
      if (timezone == null || timezones.containsKey(timezone)) return;

      try {
        await TimeMachine.initialize();
        final tzdb = await DateTimeZoneProviders.tzdb;
        var tz = await tzdb[timezone];
        timezones[timezone] =  tz;
        ref.markForCheck();
      } catch(e) {
        print("Could not get timezone info for " + timezone + ": " + e);
      }
    });
  }

  String getImageLink(Location location) {
    final lat = location.lat;
    final lng = location.lng;
    return "https://maps.googleapis.com/maps/api/staticmap?center=${lat}%2C%20${lng}&"
      "zoom=10&size=150x100&maptype=roadmap&markers=color:red%7C${lat}%2C%20${lng}"
      "&key=${ApiKey}";
  }
}
