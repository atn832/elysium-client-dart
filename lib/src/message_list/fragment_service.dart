import 'dart:core';

import 'fragment.dart';
import 'link_fragment.dart';
import 'text_fragment.dart';

final linkRegex = RegExp(r"((?:gs|https?):\/\/[^ ,)]*)");

class FragmentService {
  List<Fragment> parse(String text) {
    final linkMatches = linkRegex.allMatches(text);
    if (linkMatches.isEmpty) {
      return [TextFragment(text)];
    }
    final List<Fragment> fragments = [];
    int latestMatchEndIndex = 0;
    linkMatches.forEach((linkMatch) {
      // Add the text before the link.
      if (latestMatchEndIndex != linkMatch.start) {
        fragments.add(TextFragment(text.substring(latestMatchEndIndex, linkMatch.start)));
      }
      // Add the link.
      fragments.add(LinkFragment(text.substring(linkMatch.start, linkMatch.end)));
      // Update latest match index.
      latestMatchEndIndex = linkMatch.end;
    });
    // Add the text after the last link.
    if (latestMatchEndIndex != text.length) {
      fragments.add(TextFragment(text.substring(latestMatchEndIndex, text.length)));
    }
    return fragments;
  }
}
