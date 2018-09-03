import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import '../chat_service.dart';
import '../color_service.dart';
import '../person.dart';

@Component(
  selector: 'user-list',
  styleUrls: ['user_list_component.css'],
  templateUrl: 'user_list_component.html',
  directives: [
    MaterialChipComponent,
    materialInputDirectives,
    NgFor,
    NgIf,
  ],
)
class UserListComponent implements OnInit {
  final ChatService chatService;
  final ColorService _colorService;

  List<Person> items = [];

  UserListComponent(this.chatService, this._colorService);

  @override
  Future<Null> ngOnInit() async {
    items = await chatService.getUserList();
  }

  String getColorClass(Person person) {
    return _colorService.getColorClass(person);
  }
}
