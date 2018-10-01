import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';

import 'bubble_component.dart';
import '../bubble.dart';
import '../chat_service.dart';
import '../person.dart';

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

  @ViewChildren(BubbleComponent)
  List<BubbleComponent> bubbleComponents;

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

  updateLatestPositionFromBubble(List<Person> users, Rectangle viewport) {
    final messages = querySelector('.messages');
    // Start from the bottom.
    // As soon as
    bool startListening = false;
    Set<Person> peopleToProcess = Set.from(users);
    messages.children.reversed.forEach((c) {
      if (c == null || c.id == null || c.id == "") return;

      if (peopleToProcess.isEmpty) return;
      
      if (!startListening && isVisible(c, viewport)) {
        startListening = true;
      }
      if (!startListening) return;

      // if not processed yet, check if the bubble gives the location.
      List<Person> processed = [];
      peopleToProcess.forEach((p) {
        try {
          Bubble bubble = bubbles[int.parse(c.id)];
          // TODO: compare better.
          if (p.name == bubble.author.name) {
            processed.add(p);
            p.location = bubble.location;
          }
        } catch (e) {
          print(e);
        }
      });
      peopleToProcess.removeAll(processed);
    });
  }

  bool isVisible(Element element, Rectangle viewport) {
    final bounds = element.getBoundingClientRect();
    return bounds.intersects(viewport);
  }
}
