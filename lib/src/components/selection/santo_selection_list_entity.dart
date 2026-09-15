import 'package:santo_ui/src/components/selection/bean/santo_selection_common_entity.dart';

class SantoSelectionEntityListBean {
  List<SantoSelectionEntity>? list;

  SantoSelectionEntityListBean(this.list);

  static SantoSelectionEntityListBean? fromJson(Map<String, dynamic>? map) {
    if (map == null || map['list'] == null) return null;
    SantoSelectionEntityListBean bean = SantoSelectionEntityListBean(null);
    bean.list = (map['list'] as List)
        .map((o) => SantoSelectionEntity.fromMap(o))
        .toList();
    return bean;
  }
}
