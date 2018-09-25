import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

@Component(
  selector: 'image-link',
  styleUrls: ['image_link_component.css'],
  templateUrl: 'image_link_component.html',
  directives: [
    MaterialToggleComponent,
    NgIf,
  ],
)

class ImageLinkComponent {
  @Input()
  String displayName;

  @Input()
  Uri uri;

  bool isImageVisible = false;
}
