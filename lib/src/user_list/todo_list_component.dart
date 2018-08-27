import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import '../todo_list/http_chat_service.dart';
import '../todo_list/todo_list_service.dart';
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
  providers: [const ClassProvider(TodoListService, useClass: HttpChatService)],
)
class UserListComponent implements OnInit {
  final TodoListService chatService;

  List<Person> items = [];

  UserListComponent(this.chatService);

  @override
  Future<Null> ngOnInit() async {
    items = await chatService.getUserList();
  }
}
