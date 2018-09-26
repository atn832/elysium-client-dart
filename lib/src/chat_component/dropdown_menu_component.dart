import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';


import 'package:angular_components/material_menu/material_menu.dart';
import 'package:angular_components/model/menu/menu.dart';

import '../chat_service.dart';

@Component(
  selector: 'chat-dropdown-menu',
  styleUrls: ['dropdown_menu_component.css'],
  templateUrl: 'dropdown_menu_component.html',
  directives: [
    DropdownMenuComponent,
    MaterialIconComponent,
    MaterialMenuComponent,
  ],
  providers: const <dynamic>[
    materialProviders,
  ],
)
class ChatDropdownMenuComponent {
  final ChatService chatService;

  MenuModel<MenuItem> menuModelWithIcon;

  ChatDropdownMenuComponent(this.chatService) {
    var menuModel = MenuModel<MenuItem>([
      MenuItemGroup<MenuItem>([
        MenuItem("Déconnecter",
          action: () {
            signOut();
          },
        )
      ])
    ]);

    menuModelWithIcon =
        MenuModel<MenuItem>(menuModel.itemGroups, icon: Icon('menu'));
  }

  void signOut() {
    chatService.signOut();
  }

}
