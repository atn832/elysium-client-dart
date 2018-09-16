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

  test('empty initial state', () {
    final time = DateTime.now();
    expect(component.renderTime(time).length, 5);
  });
}
