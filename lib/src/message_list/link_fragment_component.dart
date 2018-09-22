import 'package:angular/angular.dart';

@Component(
  selector: 'link-fragment',
  styleUrls: ['link_fragment_component.css'],
  templateUrl: 'link_fragment_component.html',
)

class LinkFragmentComponent {
  @Input()
  String url;

  LinkFragmentComponent();
}
