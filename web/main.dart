import 'package:angular/angular.dart';

import 'package:angular_router/angular_router.dart';

import 'package:elysium_client/src/in_memory_data_service.dart';
import 'package:elysium_client/app_component.template.dart' as ng;

import 'package:http/browser_client.dart';
import 'package:http/http.dart';

import 'main.template.dart' as self;

@GenerateInjector([
  routerProvidersHash, // You can use routerProviders in production
  ClassProvider(Client, useClass: InMemoryDataService),
  // Using a real back end? Use BrowserClient.
  // ClassProvider(Client, useClass: BrowserClient),
])

final InjectorFactory injector = self.injector$Injector;

void main() {
  runApp(ng.AppComponentNgFactory, createInjector: injector);
}
