import 'package:angular/angular.dart';
import 'package:quickstart/app_component.template.dart' as ng;

import 'package:http/browser_client.dart';
import 'package:http/http.dart';

import 'main.template.dart' as self;

@GenerateInjector([
  ClassProvider(Client, useClass: BrowserClient),
  // Using a real back end?
  // Import 'package:http/browser_client.dart' and change the above to:
  //   ClassProvider(Client, useClass: BrowserClient),
])

final InjectorFactory injector = self.injector$Injector;

void main() {
  runApp(ng.AppComponentNgFactory, createInjector: injector);
}