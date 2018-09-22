import 'dart:async';

import 'dart:async';
import 'dart:collection';
import 'dart:core';
import 'dart:math';

import 'package:angular/core.dart';
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
      _geolocation = Geolocation() {
    bubbles = bubbleService.bubbles;
  }

  Future<List<Bubble>> getBubbles() {
    return Future.value(bubbles);
  }

  Bubble getUnsentBubble() => unsentBubble;

  Future signIn(String username) {

  }
  
  Future<List<Person>> getUserList() {
    return Future.value(userList);
  }
  
  Future sendMessage(String message) {

  }

  Future<void> getOlderMessages() {

  }

  Stream<Null> get newMessage => _newMessage.stream;
  Stream<Null> get newUsers => _newUsers.stream;
}
