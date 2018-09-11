import 'package:angular/angular.dart';

import 'package:angular_router/angular_router.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:http/http.dart';

import 'package:elysium_client/src/in_memory_data_service.dart';
import 'package:elysium_client/app_component.template.dart' as ng;

import 'main.template.dart' as self;
import 'firebase_info.dart';

@GenerateInjector([
  routerProvidersHash, // You can use routerProviders in production
  ClassProvider(Client, useClass: InMemoryDataService),
])

final InjectorFactory injector = self.injector$Injector;

void main() {
  fb.initializeApp(
    apiKey: apiKey,
    authDomain: authDomain,
    databaseURL: databaseURL,
    projectId: projectId,
    storageBucket: storageBucket,
    messagingSenderId: messagingSenderId
  );
  runApp(ng.AppComponentNgFactory, createInjector: injector);
}
