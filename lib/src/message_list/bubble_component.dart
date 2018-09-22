import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:time_machine/time_machine.dart';

import '../color_service.dart';
import '../bubble.dart';
import '../person.dart';
import 'text_fragment_component.dart';

@Component(
  selector: 'bubble',
  styleUrls: ['bubble_component.css'],
  templateUrl: 'bubble_component.html',
  directives: [
    MaterialChipComponent,
    NgFor,
    NgIf,
    TextFragmentComponent,
  ],
)
class BubbleComponent {
  final ColorService _colorService;

  @Input()
  Bubble bubble;

  @Input()
  bool sending;

  BubbleComponent(this._colorService);

  String renderTime(DateTime time) {
    final instant = Instant.dateTime(time);
    final localTimeDate = instant.inLocalZone();
    // Use DDC variant because of https://github.com/dart-lang/sdk/issues/33876.
    final todayInLocalTime = Instant.now().inLocalZone();
    if (todayInLocalTime.date.equals(localTimeDate.date)) {
      return localTimeDate.toStringDDC('HH:mm');
    }
    return localTimeDate.toStringDDC('ddd dd MMM, HH:mm');
  }

  String getColorClass(Person person) {
    return _colorService.getColorClass(person);
  }

  String getHeader(Person person) {
    return person.name[0];
  }
}
