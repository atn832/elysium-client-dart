@TestOn('browser')
import 'package:angular_test/angular_test.dart';
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:test/test.dart';

import 'app_test.template.dart' as self;

import 'package:elysium_client/app_component.dart';
import 'package:elysium_client/app_component.template.dart' as ng;

import 'utils.dart';

NgTestFixture<AppComponent> fixture;
Router router;

@GenerateInjector(routerProvidersForTesting)
final InjectorFactory rootInjector = self.rootInjector$Injector;

void main() {
  final injector = InjectorProbe(rootInjector);
  final testBed = NgTestBed.forComponent<AppComponent>(ng.AppComponentNgFactory,
      rootInjector: injector.factory);

  setUp(() async {
    fixture = await testBed.create();
    router = injector.get<Router>(Router);
    await router?.navigate('/');
    await fixture.update();
  });

  tearDown(disposeAnyRunningTest);

  test('heading', () {
    expect(fixture.text, contains('Sign in'));
  });

  // Testing info: https://webdev.dartlang.org/angular/guide/testing
}
