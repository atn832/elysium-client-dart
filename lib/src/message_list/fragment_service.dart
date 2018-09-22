import 'fragment.dart';
import 'text_fragment.dart';

class FragmentService {
  List<Fragment> parse(String text) {
    return [TextFragment(text)];
  }
}
