import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import '../todo_list/chat_service.dart';
import '../todo_list/http_chat_service.dart';

@Component(
  selector: 'input-bar',
  styleUrls: ['input_bar_component.css'],
  templateUrl: 'input_bar_component.html',
  directives: [
    MaterialFabComponent,
    MaterialIconComponent,
    materialInputDirectives,
  ],
)

class InputBarComponent implements OnInit {
  final ChatService chatService;

  String newTodo = '';

  InputBarComponent(this.chatService);

  @override
  Future<Null> ngOnInit() async {
  }
  
  void add() {
    chatService.sendMessage(newTodo);
    newTodo = '';
  }
}
