import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import '../route_paths.dart';

@Component(
  selector: 'sign-in',
  styleUrls: ['sign_in_component.css'],
  templateUrl: 'sign_in_component.html',
  directives: [
    routerDirectives,
  ],
)

class SignInComponent {
  SignInComponent();

  String chatUrl(String username) =>
    RoutePaths.chat.toUrl(parameters: {usernameParam: '$username'});
}
