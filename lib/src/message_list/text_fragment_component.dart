import 'package:angular/angular.dart';

import 'text_fragment.dart';

@Component(
  selector: 'text-fragment',
  styleUrls: ['text_fragment_component.css'],
  templateUrl: 'text_fragment_component.html',
)

class TextFragmentComponent {
  @Input()
  TextFragment fragment;

  TextFragmentComponent();
}
