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
class MessageListComponent implements OnInit, AfterViewChecked {
  final ChatService chatService;

  List<Message> items = [];

  bool newMessageAdded = false;
  final _newMessage = StreamController<Null>();
  @Output()
  Stream<Null> get newMessage => _newMessage.stream;

  MessageListComponent(this.chatService);

  @override
  Future<Null> ngOnInit() async {
    chatService.newMessage.listen((t) {
      newMessageAdded = true;
    });
    items = await chatService.getMessageList();
  }

  ngAfterViewChecked() {
    print('AfterViewChecked');
    // Notify that new messages have been rendered.
    if (newMessageAdded) {
      _newMessage.add(null);
      newMessageAdded = false;
    }
  }
}
