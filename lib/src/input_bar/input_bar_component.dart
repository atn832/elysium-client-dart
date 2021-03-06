import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';

import '../chat_service.dart';

@Component(
  selector: 'input-bar',
  styleUrls: ['input_bar_component.css'],
  templateUrl: 'input_bar_component.html',
  directives: [
    MaterialFabComponent,
    MaterialIconComponent,
    MaterialSpinnerComponent,
    NgIf,
    materialInputDirectives,
    formDirectives,
  ],
)

class InputBarComponent {
  final ChatService chatService;

  String message = '';
  bool sending = false;

  InputBarComponent(this.chatService);

  void send() {
    final m = message;
    message = '';
    if (m.trim() == "/clear") {
      chatService.clear();
    } else {
      chatService.sendMessage(m);
    }
  }

  void filesChanged(event) async {
    sending = true;
    final files = event.target.files;
    await chatService.sendFiles(files);
    sending = false;
  }
}
