import 'package:angular/angular.dart';

@Component(
  selector: 'image-link',
  styleUrls: ['image_link_component.css'],
  templateUrl: 'image_link_component.html',
)

class ImageLinkComponent {
  @Input()
  String displayName;

  @Input()
  Uri uri;
}
