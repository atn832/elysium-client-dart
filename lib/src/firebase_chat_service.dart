import 'dart:async';
import 'dart:core';
import 'dart:html';

import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart' as fs;
import 'package:time_machine/time_machine.dart';

import 'bubble.dart';
import 'bubble_service.dart';
import 'chat_service.dart';
import 'firebase_info.dart';
import 'geolocation_dartdevc_polyfill.dart';
import 'list_util.dart';
import 'location.dart';
import 'message.dart';
import 'person.dart';
import 'reverse_geocoding_service.dart';

/// Interface for a chat service.
class FirebaseChatService implements ChatService {
  final BubbleCountTrimThreshold = 200;

  fb.Auth auth;
  final ReverseGeocodingService _reverseGeocodingService;
  final Geolocation _geolocation;
  final bubbleService = BubbleService();
  Coordinates currentLocation;
  final _newMessage = StreamController<bool>();
  Stream _newMessageBroadcastStream;
  final _newUsers = StreamController<Null>();
  final _signInStateStreamController = StreamController<bool>();
  bool _listeningToUpdates = false;

  Map<String, String> uidToName = Map();
 	final List<Person> userList = [];
  List<Bubble> bubbles;
  Bubble unsentBubble;
  String _username;

  // Used to get past messages on sign-in.
  // And as the threshold when getting older messages.
  DateTime threshold = DateTime.now().toUtc().subtract(Duration(hours: 12));
  static Duration initialGetMoreDuration = const Duration(hours: 12);
  Duration getMoreDuration = initialGetMoreDuration;

  FirebaseChatService(this._reverseGeocodingService) :
      _geolocation = Geolocation() {
    _newMessageBroadcastStream = _newMessage.stream.asBroadcastStream();
    bubbles = bubbleService.bubbles;
    fb.initializeApp(
      apiKey: apiKey,
      authDomain: authDomain,
      databaseURL: databaseURL,
      projectId: projectId,
      storageBucket: storageBucket,
      messagingSenderId: messagingSenderId
    );
    auth = fb.auth();
    _setAuthListener();
  }

  Future<List<Bubble>> getBubbles() {
    return Future.value(bubbles);
  }

  Bubble getUnsentBubble() => unsentBubble;

  Future signIn(String username) async {
    print("signing in as " + username);
    this._username = username;

    // Wait to fetch current sign-in info. If it times out, sign in.
    await loginWithGoogle();
  }

  String get username => _username;

  // Logins with the Google auth provider.
  loginWithGoogle() async {
    try {
      final provider = new fb.GoogleAuthProvider();
      final user = auth.currentUser ?? (await auth.signInWithPopup(provider)).user;

      // Initialize time zone info.
      try {
        await TimeMachine.initialize();
      } catch(e) {
        print("time machine error: " + e);
      }

      // Update user list
      fs.Firestore firestore = fb.firestore();
      fs.CollectionReference ref = firestore.collection("users");
      String timezone;
      try {
        timezone = DateTimeZone.local?.toString();
      } catch(e) {
        print("problem getting local timezone: " + e);
      }
      ref.doc(user.uid).set({
        "name": username,
        "timezone": timezone,
        "lastSeen": DateTime.now().toUtc(),
      });

      // Start listening to events
      listenToUpdates();
    } catch (e) {
      throw "Error in sign in with google: $e";
    }
  }

  // Sets the auth event listener.
  _setAuthListener() {
    // When the state of auth changes (user logs in/logs out).
    auth.onAuthStateChanged.listen((user) {
      print("auth state changed: " + user.toString());
      final bool isSignedIn = user != null;
      _signInStateStreamController.add(isSignedIn);
    });
  }

  listenToUpdates() {
    if (_listeningToUpdates) return;

    _listeningToUpdates = true;

    // Track position.
    try {
      final watch = _geolocation.watchPosition(enableHighAccuracy: true, timeout: Duration(seconds: 1));
      if (watch != null) {
        watch.listen((p) {
          currentLocation = p?.coordinates;
        });
      } else {
        print("Cannot get geolocation.");
      }
    } catch(e) {
      print("cannot watch position: " + e);
    }

    fs.Firestore firestore = fb.firestore();

    // Listen to user changes.
    firestore.collection("users").onSnapshot.listen((querySnapshot) {
      final allDocs = querySnapshot.docs;
      updateUserList(allDocs);
    });

    // Listen to message changes.
    fs.CollectionReference ref = firestore.collection("messages");
    ref.where("timestamp", ">", threshold).onSnapshot.listen((querySnapshot) {
      final allData = querySnapshot.docChanges()
        .where((change) => change.type == "added")
        .map((change) => change.doc.data());
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
              .then((s) {
                loc.name = s;
                print("Notify of new message false");
                _newMessage.add(false);
              });
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
      bool hasNewerMessages = false;
      newMessages.forEach((m) {
        final message = m as Message;
        // Add to bubbles.
        final isNewerMessage = bubbleService.addMessage(message);
        hasNewerMessages = isNewerMessage || hasNewerMessages;
      });
      // Notify listeners.
      _newMessage.add(hasNewerMessages);
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

    // Only show latest bubbles to keep a smooth experience.
    trimBubbles();
  }

  void trimBubbles() {
    bubbleService.keepLatestBubbles(BubbleCountTrimThreshold);
    threshold = bubbles.isNotEmpty ? bubbles[0].dateRange.startTime : DateTime.now().toUtc();
  }

  Future<void> getOlderMessages() async {
    fs.Firestore firestore = fb.firestore();
    fs.CollectionReference ref = firestore.collection("messages");
    final newThreshold = threshold.subtract(getMoreDuration);
    print("Getting messages from " + newThreshold.toString() + " to " + threshold.toString());
    var querySnapshot = await ref
      .where("timestamp", ">", newThreshold)
      .where("timestamp", "<", threshold)
      .get();
    final allData = querySnapshot.docChanges().map((change) => change.doc.data());
    updateMessageList(allData);

    // Update threshold.
    threshold = newThreshold;
    // Double duration.
    getMoreDuration = getMoreDuration * 2;
  }

  Stream<bool> get newMessage => _newMessageBroadcastStream;
  Stream<Null> get newUsers => _newUsers.stream;

  get supportsUpload => true;

  Future sendFiles(List<File> files) async {
    // Create a root reference
    var ref = fb.storage().ref("/");
    files.forEach((f) async {
      final task = ref.child(f.name).put(f);
      final snapshot = await task.future;
      print(snapshot.ref.bucket);
      print(snapshot.ref.fullPath);

      await sendMessage(getStorageUrl(snapshot.ref));
    });
    print("done uploading files");
  }

  String getStorageUrl(fb.StorageReference ref) {
    return "gs://${ref.bucket}/${ref.fullPath}";
  }

  Map<String, Future<Uri>> downloadUrlPromises = Map();

  Future<Uri> getDownloadUrl(String gsUrl) {
    if (downloadUrlPromises.containsKey(gsUrl)) {
      return downloadUrlPromises[gsUrl];
    }
    downloadUrlPromises[gsUrl] = Future<Uri>(() async {
      try {
        final ref = fb.storage().refFromURL(gsUrl);
        final uri = await ref.getDownloadURL();
        return uri;
      } catch(e) {
        return null;
      }
    });
    return downloadUrlPromises[gsUrl];
  }

  bool get requireExplicitSignIn => true;
  Stream<bool> get signInState => _signInStateStreamController.stream;

  Future<void> signOut() {
    return auth.signOut();
  }

  clear() {
    bubbleService.clear();

    // Reset threshold and getMoreDuration.
    // TODO: is toUtc() needed?
    threshold = DateTime.now().toUtc();
    getMoreDuration = initialGetMoreDuration;

    // Notify listeners of a change.
    _newMessage.add(false);
  }
}
