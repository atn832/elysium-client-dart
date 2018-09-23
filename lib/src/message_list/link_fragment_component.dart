import 'package:angular/angular.dart';

import 'link_fragment.dart';

@Component(
  selector: 'link-fragment',
  styleUrls: ['link_fragment_component.css'],
  templateUrl: 'link_fragment_component.html',
  directives: [
    NgSwitch,
    NgSwitchWhen,
    NgSwitchDefault,
  ]
)

class LinkFragmentComponent {
  @Input()
  LinkFragment fragment;

  LinkFragmentComponent();

  String getProtocol(String url) {
    return url.split(":")[0];
  }
}
