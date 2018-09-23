import 'fragment.dart';

class LinkFragment extends Fragment {
  final url;

  LinkFragment(this.url);

  String get type => "link";
}
