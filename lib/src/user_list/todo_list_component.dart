import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import '../chat_service.dart';
import '../person.dart';

@Component(
  selector: 'user-list',
  styleUrls: ['todo_list_component.css'],
  templateUrl: 'todo_list_component.html',
  directives: [
    MaterialChipComponent,
    materialInputDirectives,
    NgFor,
    NgIf,
  ],
)
class UserListComponent implements OnInit {
  final ChatService chatService;

  List<Person> items = [];

  UserListComponent(this.chatService);

  @override
  Future<Null> ngOnInit() async {
    items = await chatService.getUserList();
  }
}
