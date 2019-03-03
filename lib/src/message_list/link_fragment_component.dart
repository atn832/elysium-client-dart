import 'package:angular/angular.dart';

import 'image_link_component.dart';
import 'link_fragment.dart';
import 'regular_link_component.dart';
import 'resolve_pipe.dart';

@Component(
  selector: 'link-fragment',
  styleUrls: ['link_fragment_component.css'],
  templateUrl: 'link_fragment_component.html',
  directives: [
    ImageLinkComponent,
    NgSwitch,
    NgSwitchWhen,
    NgSwitchDefault,
    RegularLinkComponent,
  ],
  pipes: [commonPipes, ResolvePipe],
)

class LinkFragmentComponent {

  @Input()
  LinkFragment fragment;

  bool isImage(String url) {
    return url.endsWith(".png") || url.endsWith(".jpg") || url.endsWith(".jpeg");
  }

  getMediaType(String url) {
    if (isImage(url)) return "image";
    return "unknown";
  }
}
