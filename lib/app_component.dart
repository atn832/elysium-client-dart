import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'src/routes.dart';
import 'src/route_paths.dart';

import 'src/chat_service.dart';
import 'src/http_chat_service.dart';

@Component(
  selector: 'my-app',
  template: '''
    <router-outlet [routes]="Routes.all"></router-outlet>
  ''',
  directives: [routerDirectives],
  providers: [const ClassProvider(ChatService, useClass: HttpChatService)],
  exports: [RoutePaths, Routes],
)
class AppComponent {
}
