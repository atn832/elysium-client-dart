@TestOn('browser')

import 'package:angular_test/angular_test.dart';
import 'package:test/test.dart';

import 'package:elysium_client/src/message_list/fragment_service.dart';
import 'package:elysium_client/src/message_list/text_fragment.dart';

void main() {
  FragmentService fragmentService;

  setUp(() {
    fragmentService = FragmentService();
  });

  tearDown(disposeAnyRunningTest);

  test('empty initial state', () {
    final fragments = fragmentService.parse("hello");
    expect(fragments.length, 1);
    expect(fragments[0].type, "text");
    expect((fragments[0] as TextFragment).text, "hello");
  });

}
