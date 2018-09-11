import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:time_machine/time_machine.dart';

import '../color_service.dart';
import '../bubble.dart';
import '../person.dart';

@Component(
  selector: 'bubble',
  styleUrls: ['bubble_component.css'],
  templateUrl: 'bubble_component.html',
  directives: [
    MaterialChipComponent,
    NgFor,
    NgIf,
  ],
)
class BubbleComponent {
  final ColorService _colorService;

  @Input()
  Bubble bubble;

  BubbleComponent(this._colorService);

  String renderTime(DateTime time) {
    var instant = Instant.dateTime(time);
    // Use DDC variant because of https://github.com/dart-lang/sdk/issues/33876.
    return instant.inLocalZone().toStringDDC('HH:mm');
  }

  String getColorClass(Person person) {
    return _colorService.getColorClass(person);
  }

  String getHeader(Person person) {
    return person.name[0];
  }
}
