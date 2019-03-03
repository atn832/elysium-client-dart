import 'package:angular/angular.dart';

import '../chat_service.dart';
import 'link_fragment.dart';
import 'url_resolver.dart';

/*
 * Resolves a linkFragment to an Uri.
 */
@Pipe('resolve')
class ResolvePipe extends PipeTransform {
  UrlResolver urlResolver;

  ResolvePipe(ChatService _chatService) : urlResolver = new UrlResolver(_chatService);

  Future<Uri> transform(LinkFragment linkFragment) {
    return urlResolver.resolve(linkFragment.url);
  }
}
