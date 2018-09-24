import 'package:angular/angular.dart';

import 'image_link_component.dart';
import '../chat_service.dart';
import 'link_fragment.dart';
import 'regular_link_component.dart';
import 'url_resolver.dart';

@Component(
  selector: 'link-fragment',
  styleUrls: ['link_fragment_component.css'],
  templateUrl: 'link_fragment_component.html',
  directives: [
    ImageLinkComponent,
    NgSwitch,
    NgSwitchWhen,
    NgSwitchDefault,
    RegularLinkComponent,
  ]
)

class LinkFragmentComponent implements OnChanges {
  ChatService _chatService;
  UrlResolver urlResolver;

  @Input()
  LinkFragment fragment;

  Uri resolvedUri;

  LinkFragmentComponent(this._chatService) : urlResolver = new UrlResolver(_chatService);

  bool isImage(String url) {
    return url.endsWith(".png") || url.endsWith(".jpg") || url.endsWith(".jpeg");
  }

  getMediaType(String url) {
    if (isImage(url)) return "image";
    return "unknown";
  }

  ngOnChanges(Map<String, SimpleChange> changes) {
    changes.forEach((prop, changes) {
      if (prop != "fragment") return;
      
      LinkFragment linkFragment = changes.currentValue;
      urlResolver.resolve(linkFragment.url).then((uri) => resolvedUri = uri);
    });
  }
}
