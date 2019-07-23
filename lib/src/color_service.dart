import 'package:angular/core.dart';
import 'person.dart';

enum Color { green, light_blue, orange }

/// Service that returns the color associated to a person.
@Injectable()
class ColorService {
  RegExp startsWithAlphabet = RegExp(r"^[a-zA-Z]");
  Map<String, Color> personNameToColor = Map();
  Map<String, String> personNameToColorClass = Map();

  Color getColor(Person person) {
    final name = person.name;
    if (personNameToColor.containsKey(name)) {
      return personNameToColor[name];
    }
    Color result;
    final modulo = startsWithAlphabetLetter(name) ?
      name.codeUnitAt(0) % 3 : (name.codeUnitAt(0) + 1) % 3;
    switch (modulo) {
      case 0:
        result = Color.light_blue;
        break;
      case 1:
        result = Color.orange;
        break;
      default:
        result = Color.green;
    }
    personNameToColor[name] = result;
    return result;
  }

  startsWithAlphabetLetter(String s) {
    return startsWithAlphabet.hasMatch(s);
  }

  String getColorClass(Person person) {
    final name = person.name;
    if (personNameToColorClass.containsKey(name)) {
      return personNameToColorClass[name];
    }
    final result = getColor(person).toString().split('.')[1].replaceAll('_', '-');;
    personNameToColorClass[name] = result;
    return result;
  }

}
