import 'package:angular/core.dart';
import 'person.dart';

enum Color { green, light_blue }

/// Service that returns the color associated to a person.
@Injectable()
class ColorService {
  RegExp startsWithAlphabet = RegExp(r"^[a-zA-Z]");

  Color getColor(Person person) {
    final modulo = startsWithAlphabetLetter(person.name) ?
      person.name.codeUnitAt(0) % 2 : (person.name.codeUnitAt(0) + 1) % 2;
    switch (modulo) {
      case 0:
        return Color.green;
      default:
        return Color.light_blue;
    }
  }

  startsWithAlphabetLetter(String s) {
    return startsWithAlphabet.hasMatch(s);
  }

  String getColorClass(Person person) {
    return getColor(person).toString().split('.')[1].replaceAll('_', '-');
  }

}
