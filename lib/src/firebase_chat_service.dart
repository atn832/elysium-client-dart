import 'dart:async';
import 'dart:core';

import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart' as fs;
import 'package:time_machine/time_machine.dart';

import 'bubble.dart';
import 'bubble_service.dart';
import 'chat_service.dart';
import 'geolocation_dartdevc_polyfill.dart';
import 'list_util.dart';
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

  Map<String, String> uidToName = Map();
 	final List<Person> userList = [];
  List<Bubble> bubbles;
  Bubble unsentBubble;
  String username;

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
    this.username = username;
    await loginWithGoogle();
  }

  // Logins with the Google auth provider.
  loginWithGoogle() async {
    var provider = new fb.GoogleAuthProvider();
    try {
      final credentials = await auth.signInWithPopup(provider);

      // Initialize time zone info.
      await TimeMachine.initialize();

      // Track position.
      _geolocation.watchPosition(enableHighAccuracy: true, timeout: Duration(seconds: 1)).listen((p) {
        currentLocation = p.coordinates;
      });

      // Update user list
      fs.Firestore firestore = fb.firestore();
      fs.CollectionReference ref = firestore.collection("users");
      final user = credentials.user;
      ref.doc(user.uid).set({
        "name": username,
        "timezone": DateTimeZone.local.toString(),
        "lastSeen": DateTime.now().toUtc(),
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

  _connectToFirestore() {
    fs.Firestore firestore = fb.firestore();

    // Listen to user changes.
    firestore.collection("users").onSnapshot.listen((querySnapshot) {
      final allDocs = querySnapshot.docChanges().map((change) => change.doc);
      updateUserList(allDocs);
    });

    // Listen to message changes.
    fs.CollectionReference ref = firestore.collection("messages");
    ref.onSnapshot.listen((querySnapshot) {
      final allData = querySnapshot.docChanges().map((change) => change.doc.data());
      updateMessageList(allData);
    });
  }

  updateMessageList(changes) {
    if (changes == null) return;

    // Add new messages to the list.
    final newMessages = changes
      .map((e) {
        // Remove from unsent bubble.
        String content = e["content"] as String;
        // Reverse geocode.
        final fs.GeoPoint location = e["location"];
        final loc = location != null ? Location(location.latitude, location.longitude) : null;
        if (loc != null) {
          _reverseGeocodingService.reverseGeocode(loc.lat, loc.lng)
              .then((s) => loc.name = s);
        }
        // Parse the rest of the message.
        final name = uidToName[e["uid"]];
        return Message(
            Person(name),
            content,
            e["timestamp"],
            loc,
        );
      });
    if (newMessages.isNotEmpty) {
      newMessages.forEach((m) {
        final message = m as Message;
        // Add to bubbles.
        bubbleService.addMessage(message);
      });
      // Notify listeners.
      _newMessage.add(null);
    }
  }

  updateUserList(docs) {
    List<Person> newUserList = List();
    docs
      .map((doc) {
        // Update map of id to username
        final u = doc.data();
        final name = u["name"];
        uidToName[doc.id] = name;

        // Instantiate user.
        final p = Person(name);
        try {
          p.timezone = u["timezone"];
        } catch(e) {
          // fail silently.
        }
        return p;
      })
      .forEach((p) => newUserList.add(p));
    if (!areListsEqual(userList, newUserList)) {
      print("Updating user list");
      userList.removeRange(0, userList.length);
      userList.addAll(newUserList);
      // Notify of a change.
      _newUsers.add(null);
    }
  }

  Future<List<Person>> getUserList() {
    return Future.value(userList);
  }
  
  Future sendMessage(String message) async {
    fs.Firestore firestore = fb.firestore();
    fs.CollectionReference ref = firestore.collection("messages");

    final Map<String, dynamic> messageData = {
      "uid": auth.currentUser.uid,
      "content": message,
      "timezone": DateTimeZone.local.toString(),
      "timestamp": DateTime.now().toUtc()
    };
    if (currentLocation!= null && currentLocation.latitude != null && currentLocation.longitude != null) {
      messageData["location"] = fs.GeoPoint(currentLocation.latitude, currentLocation.longitude);
    }

    await ref.add(messageData);
  }

  Future<void> getOlderMessages() {

  }

  Stream<Null> get newMessage => _newMessage.stream;
  Stream<Null> get newUsers => _newUsers.stream;
}