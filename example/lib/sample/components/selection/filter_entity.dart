

import 'package:santo_ui/santo_ui.dart';

class SantoFilterEntity {
  String? key;
  late String name;
  String? defaultValue;
  late List<ItemEntity> children;

  SantoFilterEntity.fromJson(Map<String, dynamic> map) {
    key = map['key'] ?? '';
    name = map['title'] ?? '';
    defaultValue = map['defaultValue'] ?? '';
    children = []..addAll(
        (map['children'] as List? ?? []).map((o) => ItemEntity.fromJson(o)));
  }
}
