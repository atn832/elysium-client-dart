import 'package:angular/angular.dart';

import 'gs_link_fragment_component.dart';
import 'link_fragment.dart';
import 'regular_link_component.dart';

@Component(
  selector: 'link-fragment',
  styleUrls: ['link_fragment_component.css'],
  templateUrl: 'link_fragment_component.html',
  directives: [
    GsLinkFragmentComponent,
    NgSwitch,
    NgSwitchWhen,
    NgSwitchDefault,
    RegularLinkComponent,
  ]
)

class LinkFragmentComponent {
  @Input()
  LinkFragment fragment;

  LinkFragmentComponent();

  String getProtocol(String url) {
    return url.split(":")[0];
  }

  Uri getUri(String url) {
    return Uri.parse(url);
  }
}
