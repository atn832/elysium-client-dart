@TestOn('browser')

import 'package:angular_test/angular_test.dart';
import 'package:test/test.dart';

import 'package:elysium_client/src/date_range.dart';

void main() {
  tearDown(disposeAnyRunningTest);

  test('date range constructor', () {
    final start = DateTime.now();
    final end = start.add(Duration(minutes: 1));
    final dateRange = DateRange(start, end);
    expect(dateRange.startTime, start);
    expect(dateRange.endTime, end);
  });

  test('date range constructor with inverted times', () {
    final start = DateTime.now();
    final end = start.add(Duration(minutes: 1));
    // Make sure the assertion fails if start and end times are mixed up.
    expect(() => DateRange(end, start), throws);
  });

}
