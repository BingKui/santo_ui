import 'package:santo_ui/src/components/selection/bean/santo_selection_common_entity.dart';
import 'package:santo_ui/src/components/selection/santo_selection_util.dart';
import 'package:santo_ui/src/utils/santo_tools.dart';

/// 筛选项数据转换器，用于将统一的数据结构转换为用户需要的数据结构
abstract class SantoSelectionConverterDelegate {
  /// 统一的数据结构 转换为 用户需要的数据结构，并通过 [SantoSelectionOnSelectionChanged] 回传给用户使用。
  Map<String, String> convertSelectedData(
      List<SantoSelectionEntity> selectedResults);
}

/// 默认的筛选项数据转换器
class DefaultSelectionConverter implements SantoSelectionConverterDelegate {
  const DefaultSelectionConverter();

  @override
  Map<String, String> convertSelectedData(
      List<SantoSelectionEntity> selectedResults) {
    return getSelectionParams(selectedResults);
  }
}

/// 默认的【更多】筛选项数据转换器
class DefaultMoreSelectionConverter implements SantoSelectionConverterDelegate {
  const DefaultMoreSelectionConverter();

  @override
  Map<String, String> convertSelectedData(
      List<SantoSelectionEntity> selectedResults) {
    return getSelectionParams(selectedResults);
  }
}

/// 默认的【快捷筛选】筛选项数据转换器
class DefaultSelectionQuickFilterConverter
    implements SantoSelectionConverterDelegate {
  const DefaultSelectionQuickFilterConverter();

  @override
  Map<String, String> convertSelectedData(
      List<SantoSelectionEntity> selectedResults) {
    return getSelectionParams(selectedResults);
  }
}

/// 注意，此方法仅在初始化筛选项之前调用。如果再筛选之后使用会影响筛选View 的展示以及筛选结果。
Map<String, String> getSelectionParamsWithConfigChild(
    List<SantoSelectionEntity>? selectedResults) {
  Map<String, String> params = Map();
  if (selectedResults == null) return params;
  selectedResults.forEach((f) => f.configRelationshipAndDefaultValue());
  return getSelectionParams(selectedResults);
}

/// 根据传入的原始数据，返回用户选中的筛选数据
Map<String, String> getSelectionParams(
    List<SantoSelectionEntity>? selectedResults) {
  Map<String, String> params = Map();
  if (selectedResults == null) return params;
  for (SantoSelectionEntity menuItemEntity in selectedResults) {
    if (menuItemEntity.filterType == SantoSelectionFilterType.more) {
      params.addAll(getSelectionParams(menuItemEntity.children));
    } else {
      /// 1、首先找出 自定义范围的筛选项参数。
      SantoSelectionEntity? selectedCustomInputItem =
          SantoSelectionUtil.getFilledCustomInputItem(menuItemEntity.children);
      if (selectedCustomInputItem != null &&
          !SantoTools.isEmpty(selectedCustomInputItem.customMap)) {
        String? key = selectedCustomInputItem.parent?.key;
        if (!SantoTools.isEmpty(key)) {
          params[key!] = (selectedCustomInputItem.customMap!["min"] ?? '') +
              ':' +
              (selectedCustomInputItem.customMap!["max"] ?? '');
        }
      }

      /// 2、一次找出层级为 1、2、3 的选中项的参数，递归不好阅读，直接写成 for 嵌套遍历。
      int levelCount = SantoSelectionUtil.getTotalLevel(menuItemEntity);
      if (levelCount == 1) {
        params.addAll(getCurrentSelectionEntityParams(menuItemEntity));
      } else if (levelCount == 2) {
        params.addAll(getCurrentSelectionEntityParams(menuItemEntity));
        menuItemEntity.children.forEach((firstLevelItem) =>
            params.addAll(getCurrentSelectionEntityParams(firstLevelItem)));
      } else if (levelCount == 3) {
        params.addAll(getCurrentSelectionEntityParams(menuItemEntity));
        menuItemEntity.children.forEach((firstLevelItem) {
          params.addAll(getCurrentSelectionEntityParams(firstLevelItem));
          firstLevelItem.children.forEach((secondLevelItem) {
            params.addAll(getCurrentSelectionEntityParams(secondLevelItem));
          });
        });
      }
    }
  }
  return params;
}

/// 获取当前选中项中用户选择的筛选数据
Map<String, String> getCurrentSelectionEntityParams(
    SantoSelectionEntity selectionEntity) {
  Map<String, String> params = Map();
  String? parentKey = selectionEntity.key;
  List<String?> selectedEntity = selectionEntity.children
      .where((SantoSelectionEntity f) => f.isSelected)
      .where((SantoSelectionEntity f) => !SantoTools.isEmpty(f.value))
      .map((SantoSelectionEntity f) => f.value)
      .toList();
  String selectedParams =
      selectedEntity.isEmpty ? '' : selectedEntity.join(',');
  if (!SantoTools.isEmpty(selectedParams) && !SantoTools.isEmpty(parentKey)) {
    params[parentKey!] = selectedParams;
  }
  return params;
}
