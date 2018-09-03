import 'package:angular/core.dart';
import 'person.dart';

enum Color { green, light_blue }

/// Service that returns the color associated to a person.
@Injectable()
class ColorService {
  Color getColor(Person person) {
    switch (person.name.codeUnitAt(0) % 2) {
      case 0:
        return Color.green;
      default:
        return Color.light_blue;
    }
  }

  String getColorClass(Person person) {
    return getColor(person).toString().split('.')[1].replaceAll('_', '-');
  }

}
