import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import '../chat_service.dart';

@Component(
  selector: 'input-bar',
  styleUrls: ['input_bar_component.css'],
  templateUrl: 'input_bar_component.html',
  directives: [
    MaterialFabComponent,
    MaterialIconComponent,
    materialInputDirectives,
  ],
)

class InputBarComponent {
  final ChatService chatService;

  String message = '';

  final _sendMessage = StreamController<Null>();
  @Output()
  Stream<Null> get sendMessage => _sendMessage.stream;

  InputBarComponent(this.chatService);

  void add() {
    chatService.sendMessage(message);
    message = '';

    // Notify listeners.
    _sendMessage.add(null);
  }
}
