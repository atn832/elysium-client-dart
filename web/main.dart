import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:http/http.dart';
import 'package:http/browser_client.dart';

import 'package:elysium_client/src/badge_service.dart';
import 'package:elysium_client/src/chat_service.dart';
import 'package:elysium_client/src/firebase_chat_service.dart';
import 'package:elysium_client/src/hardcoded_chat_service.dart';
import 'package:elysium_client/src/http_chat_service.dart';
import 'package:elysium_client/src/in_memory_data_service.dart';
import 'package:elysium_client/src/reverse_geocoding_service.dart';
import 'package:elysium_client/app_component.template.dart' as ng;

import 'main.template.dart' as self;

@GenerateInjector([
  routerProvidersHash, // You can use routerProviders in production
  const ClassProvider(BadgeService),
  const ClassProvider(ReverseGeocodingService),
  const ClassProvider(ChatService, useClass: FirebaseChatService),
  // const ClassProvider(ChatService, useClass: HardcodedChatService),
  // const ClassProvider(ChatService, useClass: HttpChatService),
  const ClassProvider(Client, useClass: BrowserClient),
  // const ClassProvider(Client, useClass: InMemoryDataService),
])
final InjectorFactory injector = self.injector$Injector;

void main() {
  runApp(ng.AppComponentNgFactory, createInjector: injector);
}
