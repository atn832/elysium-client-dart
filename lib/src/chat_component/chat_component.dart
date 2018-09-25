import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';

import '../chat_service.dart';
import '../route_paths.dart';

import '../input_bar/input_bar_component.dart';
import '../message_list/message_list_component.dart';
import '../user_list/user_list_component.dart';
import '../get_older_messages_component.dart';

@Component(
  selector: 'chat',
  styleUrls: ['chat_component.css'],
  templateUrl: 'chat_component.html',
  directives: [
    GetOlderMessagesComponent,
    InputBarComponent,
    MaterialButtonComponent,
    MaterialSpinnerComponent,
    MessageListComponent,
    NgIf,
    UserListComponent,
  ],
)
class ChatComponent implements OnActivate {
  final ChatService chatService;

  String username;
  bool signingIn = false;
  bool askingSignIn = false;

  ChatComponent(this.chatService) {
    if (!chatService.requireExplicitSignIn) return;

    chatService.signInState.listen((isSignedIn) {
      askingSignIn = !isSignedIn;
      if (isSignedIn) {
        signingIn = false;
      }
    });
  }

  @override
  void onActivate(_, RouterState current) async {
    username = getUsername(current.parameters);
    if (username == null) {
      return;
    }
    if (!chatService.requireExplicitSignIn) {
      await signIn();
      chatService.listenToUpdates();
    } else {
      askingSignIn = true;
    }
  }

  void signIn() async {
    askingSignIn = false;
    signingIn = true;
    try {
      await chatService.signIn(username);
    } catch(e) {
      window.alert(e);
    }
    signingIn = false;
  }

  void signOut() {
    chatService.signOut();
  }

  String getUsername(Map<String, String> parameters) {
    return parameters[usernameParam];
  }

  scrollToBottom() {
    final scrollable = querySelector('.scrollable');
    scrollable.scrollTop = scrollable.scrollHeight;
  }
}
