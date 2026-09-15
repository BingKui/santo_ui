import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/cupertino.dart';

class ChangeLocalEvent extends Notification{
  static Locale locale = Locale('zh', 'CN');
}

class ResourceDe extends SantoResourceEn {

  static Locale locale = Locale('de', 'DE');

  @override
  String get cancel => 'Abbrechen';

  @override
  String get confirm => 'bestätigen';

  @override
  String get loading => 'Wird geladen';

  @override
  String get ok => 'Ok';

}