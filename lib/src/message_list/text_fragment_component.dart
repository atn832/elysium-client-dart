import 'package:angular/angular.dart';

@Component(
  selector: 'text-fragment',
  styleUrls: ['text_fragment_component.css'],
  templateUrl: 'text_fragment_component.html',
)

class TextFragmentComponent {
  @Input()
  String text;

  TextFragmentComponent();
}
