import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import '../chat_service.dart';
import '../message.dart';

@Component(
  selector: 'message-list',
  styleUrls: ['message_list_component.css'],
  templateUrl: 'message_list_component.html',
  directives: [
    MaterialChipComponent,
    NgFor,
    NgIf,
  ],
)
class MessageListComponent implements OnInit {
  final ChatService chatService;

  List<Message> items = [];

  MessageListComponent(this.chatService);

  @override
  Future<Null> ngOnInit() async {
    items = await chatService.getMessageList();
  }
}
