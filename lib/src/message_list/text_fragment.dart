import 'fragment.dart';

class TextFragment implements Fragment {
  final String text;

  TextFragment(this.text);

  String get type => "text";
}
