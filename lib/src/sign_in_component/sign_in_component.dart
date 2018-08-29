import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';

import '../route_paths.dart';

@Component(
  selector: 'sign-in',
  styleUrls: ['sign_in_component.css'],
  templateUrl: 'sign_in_component.html',
  directives: [
    materialInputDirectives,
    routerDirectives,
  ],
)

class SignInComponent implements OnInit {
  final Router _router;

  Storage localStorage;
  String username = '';
  
  SignInComponent(this._router) {
    localStorage = window.localStorage;
  }

  @override
  Future<Null> ngOnInit() async {
    username = localStorage['username'];
  }

  void signin() {
    localStorage['username'] = username;
    _router.navigate(chatUrl(username));
  }

  String chatUrl(String username) =>
    RoutePaths.chat.toUrl(parameters: {usernameParam: '$username'});
}
