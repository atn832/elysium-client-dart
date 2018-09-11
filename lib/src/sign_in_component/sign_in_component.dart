import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:firebase/firebase.dart' as fb;

import '../route_paths.dart';

@Component(
  selector: 'sign-in',
  styleUrls: ['sign_in_component.css'],
  templateUrl: 'sign_in_component.html',
  directives: [
    MaterialButtonComponent,
    materialInputDirectives,
    routerDirectives,
  ],
)

class SignInComponent implements OnInit {
  final Router _router;
  final fb.Auth auth;

  Storage localStorage;
  String username = '';
  
  SignInComponent(this._router) : auth = fb.auth() {
    localStorage = window.localStorage;
    _setAuthListener();
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

  
  // Logins with the Google auth provider.
  loginWithGoogle() async {
    var provider = new fb.GoogleAuthProvider();
    try {
      await auth.signInWithPopup(provider);
    } catch (e) {
      print("Error in sign in with google: $e");
    }
  }

  // Sets the auth event listener.
  _setAuthListener() {
    // When the state of auth changes (user logs in/logs out).
    auth.onAuthStateChanged.listen((user) {
      if (user == null) return;

      _showProfile(user);
    });
  }

  _showProfile(fb.User user) {
    if (user.photoURL != null) {
      print(user.photoURL);
    }
    print(user.displayName + " / " + user.email);
  }
}
