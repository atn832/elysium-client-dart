import 'dart:async';

import 'package:angular/angular.dart';

import '../chat_service.dart';

import '../input_bar/input_bar_component.dart';
import '../message_list/message_list_component.dart';
import '../user_list/user_list_component.dart';

@Component(
  selector: 'chat',
  styleUrls: ['chat_component.css'],
  templateUrl: 'chat_component.html',
  directives: [InputBarComponent, MessageListComponent, UserListComponent],
)
class ChatComponent implements OnInit {
  final ChatService _chatService;
  String username = "atn";

  ChatComponent(this._chatService);

  @override
  Future<Null> ngOnInit() async {
    _chatService.signIn(username);
  }
}
