@TestOn('browser')

import 'package:angular_test/angular_test.dart';
import 'package:test/test.dart';

import 'package:elysium_client/src/message_list/fragment_service.dart';
import 'package:elysium_client/src/message_list/link_fragment.dart';
import 'package:elysium_client/src/message_list/text_fragment.dart';

void main() {
  FragmentService fragmentService;

  setUp(() {
    fragmentService = FragmentService();
  });

  tearDown(disposeAnyRunningTest);

  test('parse simple text', () {
    final fragments = fragmentService.parse("hello");
    expect(fragments.length, 1);
    expect(fragments[0].type, "text");
    expect((fragments[0] as TextFragment).text, "hello");
  });

  test('parse text with link at the end', () {
    final fragments = fragmentService.parse("check this out: http://coolurl");
    expect(fragments.length, 2);
    expect(fragments[0].type, "text");
    expect(fragments[1].type, "link");
    final text = fragments[0] as TextFragment;
    expect(text.text, "check this out: ");
    final link = fragments[1] as LinkFragment;
    expect(link.url, "http://coolurl");
  });

  test('parse text with https link at the start', () {
    final fragments = fragmentService.parse("https://coolurl => love it haha");
    expect(fragments.length, 2);
    expect(fragments[0].type, "link");
    expect(fragments[1].type, "text");
    final link = fragments[0] as LinkFragment;
    expect(link.url, "https://coolurl");
    final text = fragments[1] as TextFragment;
    expect(text.text, " => love it haha");
  });

  test('parse text with 2 link', () {
    final fragments = fragmentService.parse("https://coolurl and http://www.gmail.com");
    expect(fragments.length, 3);
    expect(fragments[0].type, "link");
    expect(fragments[1].type, "text");
    expect(fragments[2].type, "link");
    final link = fragments[0] as LinkFragment;
    expect(link.url, "https://coolurl");
    final text = fragments[1] as TextFragment;
    expect(text.text, " and ");
    final link2 = fragments[2] as LinkFragment;
    expect(link2.url, "http://www.gmail.com");
  });

  test('parse Google Storage links', () {
    final fragments = fragmentService.parse("gs://elysium-216115.appspot.com/logo.png");
    expect(fragments.length, 1);
    expect(fragments[0].type, "link");
    expect((fragments[0] as LinkFragment).url, "gs://elysium-216115.appspot.com/logo.png");
  });
}
