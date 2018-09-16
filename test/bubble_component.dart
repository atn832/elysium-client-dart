@TestOn('browser')

import 'package:angular_test/angular_test.dart';
import 'package:test/test.dart';

import 'package:elysium_client/src/message_list/bubble_component.dart';

void main() {
  BubbleComponent component;

  setUp(() {
    component = BubbleComponent(null);
  });

  tearDown(disposeAnyRunningTest);

  test('show just the time for today', () {
    final time = DateTime.now();
    expect(component.renderTime(time).length, 5);
  });

  test('show the time and date if more than a day old', () {
    final time = DateTime.now().subtract(Duration(days: 1));
    expect(component.renderTime(time).length > 5, true);
  });
}
