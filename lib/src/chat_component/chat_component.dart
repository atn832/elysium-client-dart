import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import '../chat_service.dart';
import '../route_paths.dart';

import '../input_bar/input_bar_component.dart';
import '../message_list/message_list_component.dart';
import '../user_list/user_list_component.dart';

@Component(
  selector: 'chat',
  styleUrls: ['chat_component.css'],
  templateUrl: 'chat_component.html',
  directives: [InputBarComponent, MessageListComponent, UserListComponent],
)
class ChatComponent implements OnActivate {
  final ChatService _chatService;
  final Location _location;

  String username;

  ChatComponent(this._chatService, this._location);

  @override
  void onActivate(_, RouterState current) async {
    username = getUsername(current.parameters);
    if (username == null) {
      return;
    }
    _chatService.signIn(username);
  }

  String getUsername(Map<String, String> parameters) {
    return parameters[usernameParam];
  }
}
