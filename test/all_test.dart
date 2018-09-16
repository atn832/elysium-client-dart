@TestOn('browser')
library elysium_test;

import 'package:test/test.dart';

import 'app.dart' as app;

void main() {
  group('app:', app.main);
}