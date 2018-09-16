import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'chat_service.dart';

@Component(
  selector: 'get-older-messages',
  styleUrls: ['get_older_messages_component.css'],
  templateUrl: 'get_older_messages_component.html',
  directives: [
    NgIf,
    MaterialButtonComponent,
    MaterialSpinnerComponent,
    materialInputDirectives,
  ],
)

class GetOlderMessagesComponent {
  final ChatService chatService;
  var gettingMore = false;
  GetOlderMessagesComponent(this.chatService);

  void getOlderMessages() async {
    gettingMore = true;
    await chatService.getOlderMessages();
    gettingMore = false;
  }
}
