import 'person.dart';

bool areListsEqual(List<Person> l1, List<Person> l2) {
  if (l1.length != l2.length) return false;
  for (var i = 0; i < l1.length; i++) {
    if (l1[i] != l2[i]) return false;
  }
  return true;
}
