@TestOn('browser')
library elysium_test;

import 'package:test/test.dart';

import 'app.dart' as app;
import 'bubble_service.dart' as bubbleService;

void main() {
  group('bubble service:', bubbleService.main);
  group('app:', app.main);
}