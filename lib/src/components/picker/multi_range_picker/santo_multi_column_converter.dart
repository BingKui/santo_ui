

import 'package:santo_ui/src/components/picker/multi_range_picker/bean/santo_multi_column_picker_entity.dart';
import 'package:santo_ui/src/components/picker/multi_range_picker/santo_multi_column_picker_util.dart';
import 'package:santo_ui/src/utils/santo_tools.dart';

class SantoMultiRangeSelConverter {
  const SantoMultiRangeSelConverter();

  Map<String, List<SantoPickerEntity>> convertPickedData(
      List<SantoPickerEntity> selectedResults,
      {bool includeUnlimitSelection = false}) {
    return getSelectionParams(selectedResults,
        includeUnlimitSelection: includeUnlimitSelection);
  }

  Map<String, List<SantoPickerEntity>> getSelectionParams(
      List<SantoPickerEntity>? selectedResults,
      {bool includeUnlimitSelection = false}) {
    Map<String, List<SantoPickerEntity>> params = Map();
    if (selectedResults == null) return params;
    for (SantoPickerEntity menuItemEntity in selectedResults) {
      int levelCount =
          SantoMultiColumnPickerUtil.getTotalColumnCount(menuItemEntity);
      if (levelCount == 1) {
        params.addAll(getCurrentSelectionEntityParams(menuItemEntity,
            includeUnlimitSelection: includeUnlimitSelection));
      } else if (levelCount == 2) {
        params.addAll(getCurrentSelectionEntityParams(menuItemEntity,
            includeUnlimitSelection: includeUnlimitSelection));
        menuItemEntity.children.forEach((firstLevelItem) => mergeParams(
            params,
            getCurrentSelectionEntityParams(firstLevelItem,
                includeUnlimitSelection: includeUnlimitSelection)));
      } else if (levelCount == 3) {
        params.addAll(getCurrentSelectionEntityParams(menuItemEntity,
            includeUnlimitSelection: includeUnlimitSelection));
        menuItemEntity.children.forEach((firstLevelItem) {
          mergeParams(
              params,
              getCurrentSelectionEntityParams(firstLevelItem,
                  includeUnlimitSelection: includeUnlimitSelection));
          firstLevelItem.children.forEach((secondLevelItem) {
            mergeParams(
                params,
                getCurrentSelectionEntityParams(secondLevelItem,
                    includeUnlimitSelection: includeUnlimitSelection));
          });
        });
      }
    }
    return params;
  }

  Map<String?, List<SantoPickerEntity>> mergeParams(
      Map<String?, List<SantoPickerEntity>> params,
      Map<String?, List<SantoPickerEntity>> selectedParams) {
    selectedParams.forEach((String? key, List<SantoPickerEntity> value) {
      if (params.containsKey(key)) {
        params[key]?.addAll(value);
      } else {
        params.addAll(selectedParams);
      }
    });
    return params;
  }

  Map<String, List<SantoPickerEntity>> getCurrentSelectionEntityParams(
      SantoPickerEntity selectionEntity,
      {bool includeUnlimitSelection = false}) {
    Map<String, List<SantoPickerEntity>> params = Map();
    String parentKey = selectionEntity.key ?? '';
    var selectedEntity = selectionEntity.children
        .where((SantoPickerEntity f) => f.isSelected)
        .where((SantoPickerEntity f) {
          if (includeUnlimitSelection) {
            return true;
          } else {
            return !SantoTools.isEmpty(f.value);
          }
        })
        .map((SantoPickerEntity f) => f)
        .toList();
    List<SantoPickerEntity> selectedParams = selectedEntity;
    if (!SantoTools.isEmpty(selectedParams) && !SantoTools.isEmpty(parentKey)) {
      params[parentKey] = selectedParams;
    }
    return params;
  }
}
