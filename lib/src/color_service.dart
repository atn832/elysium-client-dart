import 'package:angular/core.dart';
import 'person.dart';

enum Color { green, light_blue }

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
      name.codeUnitAt(0) % 2 : (name.codeUnitAt(0) + 1) % 2;
    switch (modulo) {
      case 0:
        result = Color.green;
        break;
      default:
        result = Color.light_blue;
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
