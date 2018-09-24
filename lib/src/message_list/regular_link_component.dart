import 'package:angular/angular.dart';

@Component(
  selector: 'regular-link',
  styleUrls: ['regular_link_component.css'],
  templateUrl: 'regular_link_component.html',
)

class RegularLinkComponent {
  @Input()
  String displayName;

  @Input()
  Uri uri;
}
