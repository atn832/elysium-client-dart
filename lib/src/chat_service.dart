import 'dart:async';
import 'dart:html';

import 'bubble.dart';
import 'person.dart';

/// Interface for a chat service.
abstract class ChatService {
  ChatService();
 
  Future<List<Bubble>> getBubbles();
  Bubble getUnsentBubble();

  Future signIn(String username);
  
  Future<List<Person>> getUserList();
  
  Future sendMessage(String message);

  Future<void> getOlderMessages();

  Stream<Null> get newMessage;
  Stream<Null> get newUsers;

  bool get supportsUpload;
  Future sendFiles(List<File> files);
}
