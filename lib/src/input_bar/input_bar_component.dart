import "dart:html";

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
    NgIf,
    materialInputDirectives,
  ],
)

class InputBarComponent {
  final ChatService chatService;

  String message = '';

  InputBarComponent(this.chatService);

  void add() {
    final m = message;
    message = '';
    chatService.sendMessage(m);
  }

  void filesChanged(event) {
    print("files changed");
    final files = event.target.files;
    chatService.sendFiles(files);
  }
}
