import 'package:angular/angular.dart';

import 'link_fragment.dart';
import 'regular_link_component.dart';
import '../chat_service.dart';
import '../firebase_chat_service.dart';

@Component(
  selector: 'gs-link-fragment',
  styleUrls: ['gs_link_fragment_component.css'],
  templateUrl: 'gs_link_fragment_component.html',
  directives: [
    NgIf,
    NgSwitch,
    NgSwitchWhen,
    NgSwitchDefault,
    RegularLinkComponent,
  ]
)

class GsLinkFragmentComponent implements OnChanges {
  final ChatService _chatService;

  @Input()
  LinkFragment fragment;

  Uri downloadUri;

  GsLinkFragmentComponent(this._chatService);

  ngOnChanges(Map<String, SimpleChange> changes) {
    changes.forEach((prop, changes) {
      if (prop != "fragment") return;
      
      LinkFragment linkFragment = changes.currentValue;
      if (_chatService is FirebaseChatService) {
        FirebaseChatService firebaseChatService = _chatService as FirebaseChatService;
        firebaseChatService.getDownloadUrl(linkFragment.url).then((uri) {
          if (uri == null) return;
          downloadUri = uri;
        });
      } 
    });
  }
}
