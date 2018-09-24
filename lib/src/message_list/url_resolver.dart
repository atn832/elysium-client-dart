import 'dart:async';

import '../chat_service.dart';
import '../firebase_chat_service.dart';

class UrlResolver {
  final ChatService _chatService;

  UrlResolver(this._chatService);

  Future<Uri> resolve(String url) async {
    if (getProtocol(url) == "gs") {
      if (!(_chatService is FirebaseChatService)) {
        return null;
      }
      FirebaseChatService firebaseChatService = _chatService as FirebaseChatService;
      try {
        return await firebaseChatService.getDownloadUrl(url);
      } catch(e) {
        return null;
      }
    }
    return Uri.parse(url);
  }

  String getProtocol(String url) {
    return url.split(":")[0];
  }
}
