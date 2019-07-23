@TestOn('browser')

import 'package:angular_test/angular_test.dart';
import 'package:test/test.dart';

import 'package:elysium_client/src/color_service.dart';
import 'package:elysium_client/src/person.dart';

void main() {
  ColorService colorService = ColorService();

  Person tuan = Person("퇀");
  Person yuanyuan = Person("元元");
  Person chris = Person("Chris");

  tearDown(disposeAnyRunningTest);

  test('Green for frun', () {
    expect(colorService.getColor(yuanyuan), Color.green);
  });

  test('Blue for atn', () {
    expect(colorService.getColor(tuan), Color.light_blue);
  });

  test('Orange for Chris', () {
    expect(colorService.getColor(chris), Color.orange);
  });

}
