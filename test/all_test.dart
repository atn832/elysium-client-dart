@TestOn('browser')
library elysium_test;

import 'package:test/test.dart';

import 'app.dart' as app;
import 'bubble_component.dart' as bubbleComponent;
import 'bubble_service.dart' as bubbleService;
import 'color_service.dart' as colorService;
import 'date_range.dart' as dateRange;
import 'fragment_service.dart' as fragmentService;

void main() {
  group('date range', dateRange.main);
  group('color service:', colorService.main);
  group('bubble service:', bubbleService.main);
  group('fragment service:', fragmentService.main);
  group('bubble component:', bubbleComponent.main);
  group('app:', app.main);
}