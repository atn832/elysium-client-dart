import 'dart:async';

import 'package:angular/angular.dart';

import 'bubble_component.dart';
import '../chat_service.dart';
import '../bubble.dart';

@Component(
  selector: 'message-list',
  styleUrls: ['message_list_component.css'],
  templateUrl: 'message_list_component.html',
  directives: [
    NgFor,
    NgIf,
    BubbleComponent,
  ],
)
class MessageListComponent implements OnInit, AfterViewChecked {
  final ChatService chatService;

  List<Bubble> bubbles = [];
  Bubble unsentBubble;

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
    bubbles = await chatService.getBubbles();
    unsentBubble = chatService.getUnsentBubble();
  }

  ngAfterViewChecked() {
    // Notify that new messages have been rendered.
    if (newMessageAdded) {
      _newMessage.add(null);
      newMessageAdded = false;
    }
  }
}
