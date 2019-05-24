import 'dart:html';
import 'package:intl/intl.dart';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:service_worker/window.dart' as sw;
import 'package:service_worker/src/service_worker_api.dart' as swa;
import 'package:service_worker/window.dart';

import '../chat_service.dart';
import '../person.dart';
import '../route_paths.dart';

import '../input_bar/input_bar_component.dart';
import '../message_list/message_list_component.dart';
import '../user_list/user_list_component.dart';
import '../get_older_messages_component.dart';
import 'dropdown_menu_component.dart';

@Component(
  selector: 'chat',
  styleUrls: ['chat_component.css'],
  templateUrl: 'chat_component.html',
  directives: [
    ChatDropdownMenuComponent,
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
  @ViewChild(MessageListComponent)
  MessageListComponent messageListComponent;

  @ViewChild(UserListComponent)
  UserListComponent userListComponent;

  final ChatService chatService;

  String username;
  bool signingIn = false;
  bool askingSignIn = false;
  bool stayAtTheBottom = true;

  swa.Notification latestNotification;

  List<Person> users;

  ChatComponent(this.chatService) {
    if (!chatService.requireExplicitSignIn) return;

    chatService.signInState.listen((isSignedIn) async {
      askingSignIn = !isSignedIn;
      if (isSignedIn) {
        chatService.listenToUpdates();
        signingIn = false;
        users = await chatService.getUserList();

        // Ask for permission to send notifications.
        Notification.requestPermission();
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
    // Update user positions.
    final scrollable = querySelector('.scrollable');
    scrollable.onScroll.transform(throttleStream(Duration(milliseconds: 100))).listen((e) {
      messageListComponent.updateLatestPositionFromBubble(users, scrollable.getBoundingClientRect());
      userListComponent.markForCheck();
    });

    // Update title on new message.
    final title = querySelector("title");
    var formatter = new DateFormat('Hm');
    chatService.newMessage
      .listen((newer) {
        if (newer) {
          chatService.getBubbles().then((bubbles) async {
            final last = bubbles?.last;
            if (last == null) return;

            final author = last.author?.name;
            final timestamp = last.dateRange.endTime;
            final notificationText = author + " " + formatter.format(timestamp);;
            title.text = notificationText;

            // Send notification only if it's a different author.
            // Username can be null if chatService hasn't finished signing in yet.
            if (username != author) {
              final registration = await sw.getRegistration('sw.dart.js');
              final notificationEvent = await registration.showNotification(notificationText,
                ShowNotificationOptions()..tag = 'new_message');
              latestNotification = notificationEvent.notification;
            }
          });
        }
      });
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

  maybeScrollToBottom() {
    print('maybeScrollToBottom');
    if (!stayAtTheBottom) {
      return;
    }
    final scrollable = querySelector('.scrollable');
    scrollable.scrollTop = scrollable.scrollHeight;
  }

  onScroll(e) {
    final scrollable = querySelector('.scrollable');
    final userScrolledToTheBottom = scrollable.scrollTop + scrollable.clientHeight == scrollable.scrollHeight;
    stayAtTheBottom = userScrolledToTheBottom;
    clearNotifications();
  }

  clearNotifications() async {
    if (latestNotification == null) return;

    latestNotification.close();
    latestNotification = null;
  }
}
