@TestOn('browser')

import 'package:angular_test/angular_test.dart';
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:http/http.dart';
import 'package:pageloader/html.dart';
import 'package:test/test.dart';

import 'package:elysium_client/app_component.dart';
import 'package:elysium_client/app_component.template.dart' as ng;
import 'package:elysium_client/src/in_memory_data_service.dart';

import 'app_po.dart';
import 'app.template.dart' as self;
import 'utils.dart';

NgTestFixture<AppComponent> fixture;
AppPO po;
Router router;

@GenerateInjector([
  routerProvidersForTesting,
  ClassProvider(Client, useClass: InMemoryDataService),
])
final InjectorFactory rootInjector = self.rootInjector$Injector;

void main() {
  final injector = InjectorProbe(rootInjector);
  final testBed = NgTestBed.forComponent<AppComponent>(ng.AppComponentNgFactory,
      rootInjector: injector.factory);

  List<RouterState> navHistory;

  setUp(() async {
    fixture = await testBed.create();
    router = injector.get<Router>(Router);
    navHistory = [];
    router.onRouteActivated.listen((newState) => navHistory.add(newState));

    await router?.navigate('/');
    await fixture.update();
    
    final context =
        HtmlPageLoaderElement.createFromElement(fixture.rootElement);
    po = AppPO.create(context);
  });

  tearDown(disposeAnyRunningTest);

  test('heading', () {
    expect(fixture.text, contains('Suivant'));
  });

  test('choose username and sign in + navHistory', () async {
    await po.clear();
    await po.type('atn');
    await po.signIn();
    await fixture.update();

    expect(navHistory.length, 1);
    expect(navHistory[0].path, '/chat/atn');
  });

  // Testing info: https://webdev.dartlang.org/angular/guide/testing
}
