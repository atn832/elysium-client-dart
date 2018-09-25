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

  void listenToUpdates();
  
  Future<List<Person>> getUserList();
  
  Future<void> sendMessage(String message);

  Future<void> getOlderMessages();

  Stream<Null> get newMessage;
  Stream<Null> get newUsers;

  bool get supportsUpload;
  Future<void> sendFiles(List<File> files);

  bool get requireExplicitSignIn;

  Future<void> signOut();

  Stream<bool> get signInState;
}
