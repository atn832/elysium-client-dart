import 'package:angular_router/angular_router.dart';

import 'route_paths.dart';
import 'chat_component/chat_component.template.dart' as chat_template;
import 'sign_in_component/sign_in_component.template.dart' as sign_in_template;

export 'route_paths.dart';

class Routes {
  static final signin = RouteDefinition(
    routePath: RoutePaths.signin,
    component: sign_in_template.SignInComponentNgFactory,
  );
  static final chat = RouteDefinition(
    routePath: RoutePaths.chat,
    component: chat_template.ChatComponentNgFactory,
  );

  static final all = <RouteDefinition>[
    chat,
    signin,
    // Redirect empty path to chat.
    RouteDefinition.redirect(
      path: '',
      redirectTo: RoutePaths.signin.toUrl(),
    ),
  ];
}
