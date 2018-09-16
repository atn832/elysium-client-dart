import 'dart:async';

import 'package:pageloader/pageloader.dart';

part 'app_po.g.dart';

@PageObject()
abstract class AppPO {
  AppPO();
  factory AppPO.create(PageLoaderElement context) = $AppPO.create;

  @ByTagName('h1')
  PageLoaderElement get _h1;

  @ByCss('material-input input')
  PageLoaderElement get _input;

  @ByTagName('material-button')
  PageLoaderElement get _button;

  Future<void> clear() => _input.clear();

  Future<void> type(String s) => _input.type(s);

  Future<void> signIn() => _button.click();

  String get pageTitle => _h1.visibleText;
  
  String get inputText => _input.visibleText;
}
