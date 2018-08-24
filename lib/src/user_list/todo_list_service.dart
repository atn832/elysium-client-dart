import 'dart:async';

import 'package:angular/core.dart';

/// Mock service emulating access to a to-do list stored on a server.
@Injectable()
class UserListService {
  List<String> mockTodoList = <String>["atn", "frun"];

  Future<List<String>> getTodoList() async => mockTodoList;
}
