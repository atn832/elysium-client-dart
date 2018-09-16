@TestOn('browser')
library elysium_test;

import 'package:test/test.dart';

import 'app.dart' as app;
import 'bubble_component.dart' as bubbleComponent;
import 'bubble_service.dart' as bubbleService;
import 'date_range.dart' as dateRange;

void main() {
  group('date range', dateRange.main);
  group('bubble service:', bubbleService.main);
  group('bubble component:', bubbleComponent.main);
  group('app:', app.main);
}