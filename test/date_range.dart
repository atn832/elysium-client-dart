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

  test('isBefore', () {
    final start = DateTime.now();
    final end = start.add(Duration(minutes: 1));
    final dateRange = DateRange(start, end);

    // DateRange is before something that happens after the date range ends.
    final wayAfter = end.add(Duration(minutes: 1));
    expect(dateRange.isBefore(wayAfter), true);

    // DateRange is not before something that happened before the date range starts.
    final wayBefore = start.subtract(Duration(minutes: 1));
    expect(dateRange.isBefore(wayBefore), false);
  });

  test('isAfter', () {
    final start = DateTime.now();
    final end = start.add(Duration(minutes: 1));
    final dateRange = DateRange(start, end);

    // DateRange is after something that happens before the date range starts.
    final wayBefore = start.subtract(Duration(minutes: 1));
    expect(dateRange.isAfter(wayBefore), true);

    // DateRange is not after something that happened after the date range starts.
    final wayAfter = end.add(Duration(minutes: 1));
    expect(dateRange.isAfter(wayAfter), false);
  });

  test('expand', () {
    final start = DateTime.now();
    final end = start.add(Duration(minutes: 1));
    final dateRange = DateRange(start, end);

    // Expanding by a time in the middle does not modify the range.
    final middle = start.add(Duration(seconds: 30));
    dateRange.expand(middle);
    expect(dateRange.startTime, start);
    expect(dateRange.endTime, end);

    // Expanding by a time before the range changes startTime.
    final wayBefore = start.subtract(Duration(minutes: 1));
    dateRange.expand(wayBefore);
    expect(dateRange.startTime, wayBefore);
    expect(dateRange.endTime, end);

    // Expanding by a time after the range changes endTime.
    final wayAfter = end.add(Duration(minutes: 1));
    dateRange.expand(wayAfter);
    expect(dateRange.startTime, wayBefore);
    expect(dateRange.endTime, wayAfter);
  });

}
