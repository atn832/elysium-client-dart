import 'dart:async';
import 'dart:html';

import 'bubble.dart';
import 'person.dart';

/// Interface for a chat service.
abstract class ChatService {
  ChatService();
 
  Future<List<Bubble>> getBubbles();
  Bubble getUnsentBubble();

  Future<void> signIn(String username);
  String get username;

  void listenToUpdates();
  
  Future<List<Person>> getUserList();
  
  Future<void> sendMessage(String message);

  clear();

  Future<void> getOlderMessages();

  // true if for newer messages, false for past messages or when existing message metadata changes.
  Stream<bool> get newMessage;
  Stream<Null> get newUsers;

  bool get supportsUpload;
  Future<void> sendFiles(List<File> files);

  bool get requireExplicitSignIn;

  Future<void> signOut();

  Stream<bool> get signInState;
}
