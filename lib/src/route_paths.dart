import 'package:angular_router/angular_router.dart';

const usernameParam = 'username';

class RoutePaths {
  static final chat = RoutePath(path: 'chat/:$usernameParam');
}
