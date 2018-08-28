import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import '../chat_service.dart';
import '../message.dart';
import '../person.dart';

@Component(
  selector: 'todo-list',
  styleUrls: ['todo_list_component.css'],
  templateUrl: 'todo_list_component.html',
  directives: [
    MaterialChipComponent,
    NgFor,
    NgIf,
  ],
)
class TodoListComponent implements OnInit {
  final ChatService chatService;

  List<Message> items = [];

  TodoListComponent(this.chatService);

  @override
  Future<Null> ngOnInit() async {
    items = await chatService.getTodoList();
  }
}
