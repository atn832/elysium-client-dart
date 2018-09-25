@TestOn('browser')

import 'package:angular_test/angular_test.dart';
import 'package:test/test.dart';

import 'package:elysium_client/src/color_service.dart';
import 'package:elysium_client/src/person.dart';

void main() {
  ColorService colorService = ColorService();

  Person atn = Person("atn");
  Person tuan = Person("퇀");
  Person frun = Person("frun");
  Person yuanyuan = Person("元元");

  tearDown(disposeAnyRunningTest);

  test('Green for frun', () {
    expect(colorService.getColor(frun), Color.green);
    expect(colorService.getColor(yuanyuan), Color.green);
  });

  test('Blue for atn', () {
    expect(colorService.getColor(atn), Color.light_blue);
    expect(colorService.getColor(tuan), Color.light_blue);
  });

}
