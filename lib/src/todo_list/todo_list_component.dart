import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'chat_service.dart';
import 'http_chat_service.dart';
import '../message.dart';
import '../person.dart';

@Component(
  selector: 'todo-list',
  styleUrls: ['todo_list_component.css'],
  templateUrl: 'todo_list_component.html',
  directives: [
    MaterialChipComponent,
    MaterialFabComponent,
    MaterialIconComponent,
    materialInputDirectives,
    NgFor,
    NgIf,
  ],
  providers: [const ClassProvider(ChatService, useClass: HttpChatService)],
)
class TodoListComponent implements OnInit {
  final ChatService chatService;

  List<Message> items = [];
  String newTodo = '';

  TodoListComponent(this.chatService);

  @override
  Future<Null> ngOnInit() async {
    chatService.setUsername("atn");
    items = await chatService.getTodoList();
  }

  void add() {
    items.add(Message(Person('me'), newTodo));
    newTodo = '';
  }

  Message remove(int index) => items.removeAt(index);
}
