import 'dart:async';
import 'package:angular/angular.dart';

import 'src/chat_service.dart';
import 'src/http_chat_service.dart';

import 'src/input_bar/input_bar_component.dart';
import 'src/todo_list/todo_list_component.dart';
import 'src/user_list/todo_list_component.dart';

// AngularDart info: https://webdev.dartlang.org/angular
// Components info: https://webdev.dartlang.org/components

@Component(
  selector: 'my-app',
  styleUrls: ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: [InputBarComponent, TodoListComponent, UserListComponent],
  providers: [const ClassProvider(ChatService, useClass: HttpChatService)],
)
class AppComponent implements OnInit {
  final ChatService _chatService;

  AppComponent(this._chatService);

  @override
  Future<Null> ngOnInit() async {
    _chatService.signIn("atn");
  }
}
