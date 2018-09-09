import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'src/routes.dart';
import 'src/route_paths.dart';

import 'src/color_service.dart';
import 'src/chat_service.dart';
import 'src/http_chat_service.dart';
import 'src/hardcoded_chat_service.dart';
import 'src/reverse_geocoding_service.dart';

@Component(
  selector: 'my-app',
  template: '''
    <router-outlet [routes]="Routes.all"></router-outlet>
  ''',
  directives: [routerDirectives],
  providers: [
    const ClassProvider(ChatService, useClass: HardcodedChatService),
    // const ClassProvider(ChatService, useClass: HttpChatService),
    const ClassProvider(ColorService),
    const ClassProvider(ReverseGeocodingService)
  ],
  exports: [RoutePaths, Routes],
)
class AppComponent {
}
