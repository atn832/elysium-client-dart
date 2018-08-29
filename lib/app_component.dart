import 'package:angular/angular.dart';

import 'src/chat_service.dart';
import 'src/http_chat_service.dart';

import 'src/chat_component/chat_component.dart';

@Component(
  selector: 'my-app',
  template: '''
    <chat [username]="username"></chat>
  ''',
  directives: [ChatComponent],
  providers: [const ClassProvider(ChatService, useClass: HttpChatService)],
)
class AppComponent {
  var username = "atn";
}
