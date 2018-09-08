import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'src/routes.dart';
import 'src/route_paths.dart';

import 'src/color_service.dart';
import 'src/chat_service.dart';
import 'src/http_chat_service.dart';

@Component(
  selector: 'my-app',
  template: '''
    <router-outlet [routes]="Routes.all"></router-outlet>
  ''',
  directives: [routerDirectives],
  providers: [
    // const ClassProvider(ChatService),
    const ClassProvider(ChatService, useClass: HttpChatService),
    const ClassProvider(ColorService)
  ],
  exports: [RoutePaths, Routes],
)
class AppComponent {
}
