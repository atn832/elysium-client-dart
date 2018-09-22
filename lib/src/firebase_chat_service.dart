import 'dart:async';

import 'dart:async';
import 'dart:collection';
import 'dart:core';
import 'dart:math';

import 'package:angular/core.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart' as fs;
import 'package:http/http.dart';
import 'package:time_machine/time_machine.dart';

import 'bubble.dart';
import 'bubble_service.dart';
import 'chat_service.dart';
import 'geolocation_dartdevc_polyfill.dart';
import 'location.dart';
import 'message.dart';
import 'person.dart';
import 'reverse_geocoding_service.dart';

/// Interface for a chat service.
class FirebaseChatService implements ChatService {
  final fb.Auth auth;
  final ReverseGeocodingService _reverseGeocodingService;
  final Geolocation _geolocation;
  final bubbleService = BubbleService();
  Coordinates currentLocation;
  final _newMessage = StreamController<Null>();
  final _newUsers = StreamController<Null>();

 	final List<Person> userList = [];
  List<Bubble> bubbles;
  Bubble unsentBubble;

  FirebaseChatService(this._reverseGeocodingService) :
      _geolocation = Geolocation(),
      auth = fb.auth() {
    bubbles = bubbleService.bubbles;
  }

  Future<List<Bubble>> getBubbles() {
    return Future.value(bubbles);
  }

  Bubble getUnsentBubble() => unsentBubble;

  Future signIn(String username) async{
    await loginWithGoogle();
  }

  // Logins with the Google auth provider.
  loginWithGoogle() async {
    var provider = new fb.GoogleAuthProvider();
    try {
      if (auth.currentUser == null) {
        final credentials = await auth.signInWithPopup(provider);
      }

      // Initialize time zone info.
      await TimeMachine.initialize();

      // Track position.
      _geolocation.watchPosition(enableHighAccuracy: true, timeout: Duration(seconds: 1)).listen((p) {
        currentLocation = p.coordinates;
      });

      // Start listening to events
      _connectToFirestore();
    } catch (e) {
      print("Error in sign in with google: $e");
    }
  }

  // // Sets the auth event listener.
  // _setAuthListener() {
  //   // When the state of auth changes (user logs in/logs out).
  //   auth.onAuthStateChanged.listen((user) {
  //     if (user == null) return;

  //     _showProfile(user);
  //     _connectToFirestore();
  //   });
  // }

  // _showProfile(fb.User user) {
  //   if (user.photoURL != null) {
  //     print(user.photoURL);
  //   }
  //   print(user.displayName + " / " + user.email);
  // }

  _connectToFirestore() {
    fs.Firestore firestore = fb.firestore();
    fs.CollectionReference ref = firestore.collection("messages");

    ref.onSnapshot.listen((querySnapshot) {
      querySnapshot.docChanges().forEach((change) {
        final docSnapshot = change.doc;
        print(docSnapshot.data());
      });
    });
  }

  Future<List<Person>> getUserList() {
    return Future.value(userList);
  }
  
  Future sendMessage(String message) {
    fs.Firestore firestore = fb.firestore();
    fs.CollectionReference ref = firestore.collection("messages");

    final Map<String, dynamic> messageData = {
      "user": auth.currentUser.uid,
      "content": message,
      "timeZone": DateTimeZone.local.toString(),
      "time": DateTime.now().toUtc()
    };
    if (currentLocation!= null && currentLocation.latitude != null && currentLocation.longitude != null) {
      messageData["location"] = fs.GeoPoint(currentLocation.latitude, currentLocation.longitude);
    }

    ref.add(messageData);
  }

  Future<void> getOlderMessages() {

  }

  Stream<Null> get newMessage => _newMessage.stream;
  Stream<Null> get newUsers => _newUsers.stream;
}
