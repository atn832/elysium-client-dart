import 'package:angular/angular.dart';

import 'package:angular_router/angular_router.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart';

import 'package:elysium_client/app_component.template.dart' as ng;
import 'package:elysium_client/src/chat_service.dart';
import 'package:elysium_client/src/firebase_chat_service.dart';
import 'package:elysium_client/src/reverse_geocoding_service.dart';

import 'main.template.dart' as self;

@GenerateInjector([
  routerProvidersHash, // You can use routerProviders in production
  const ClassProvider(ReverseGeocodingService),
  const ClassProvider(ChatService, useClass: FirebaseChatService),
  // Required by ReverseGeocodingService.
  const ClassProvider(Client, useClass: BrowserClient),
])

final InjectorFactory injector = self.injector$Injector;

void main() {
  runApp(ng.AppComponentNgFactory, createInjector: injector);
}
