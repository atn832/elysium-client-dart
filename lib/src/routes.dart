import 'package:angular_router/angular_router.dart';

import 'route_paths.dart';
import 'chat_component/chat_component.template.dart' as chat_template;

export 'route_paths.dart';

class Routes {
  static final chat = RouteDefinition(
    routePath: RoutePaths.chat,
    component: chat_template.ChatComponentNgFactory,
  );

  static final all = <RouteDefinition>[
    chat,
    // Redirect empty path to chat.
    RouteDefinition.redirect(
      path: '',
      redirectTo: RoutePaths.chat.toUrl(parameters: {usernameParam: 'atn'}),
    ),
  ];
}
