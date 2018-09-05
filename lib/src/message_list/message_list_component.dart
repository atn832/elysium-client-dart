import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:time_machine/time_machine.dart';

import '../chat_service.dart';
import '../color_service.dart';
import '../message.dart';
import '../person.dart';

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
  final ColorService _colorService;

  List<Message> items = [];

  bool newMessageAdded = false;
  final _newMessage = StreamController<Null>();
  @Output()
  Stream<Null> get newMessage => _newMessage.stream;

  MessageListComponent(this.chatService, this._colorService);

  @override
  Future<Null> ngOnInit() async {
    chatService.newMessage.listen((t) {
      newMessageAdded = true;
    });
    items = await chatService.getMessageList();
  }

  ngAfterViewChecked() {
    // Notify that new messages have been rendered.
    if (newMessageAdded) {
      _newMessage.add(null);
      newMessageAdded = false;
    }
  }

  String renderTime(DateTime time) {
    var instant = Instant.dateTime(time);
    // Use DDC variant because of https://github.com/dart-lang/sdk/issues/33876.
    return instant.inLocalZone().toStringDDC('HH:mm');
  }

  String getColorClass(Person person) {
    return _colorService.getColorClass(person);
  }

  String getHeader(Person person) {
    return person.name[0];
  }
}
