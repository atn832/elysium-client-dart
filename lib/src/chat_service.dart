import 'dart:async';

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

  Stream<Null> get newMessage;
  Stream<Null> get newUsers;
}
