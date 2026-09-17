

import 'package:santo_ui/src/components/line/santo_line.dart';
import 'package:santo_ui/src/components/picker/base/santo_picker_constants.dart';
import 'package:santo_ui/src/components/picker/base/santo_picker_title.dart';
import 'package:santo_ui/src/components/picker/base/santo_picker_title_config.dart';
import 'package:santo_ui/src/components/picker/santo_picker_cliprrect.dart';
import 'package:santo_ui/src/components/picker/multi_select_bottom_picker/santo_multi_select_data.dart';
import 'package:santo_ui/src/constants/santo_asset_constants.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/utils/santo_tools.dart';
import 'package:flutter/material.dart';

/// 点击确定时的回调
/// [checkedItems] 被选中的 item 集合
typedef SantoMultiSelectListPickerSubmit<T> = void Function(
    List<T> checkedItems);

/// item 被点击时的回调
/// [index] item 的索引
typedef SantoMultiSelectListPickerItemClick = void Function(
    BuildContext context, int index);

/// 多选列表 Picker

class SantoMultiSelectListPicker<T extends SantoMultiSelectBottomPickerItem> extends StatefulWidget {
  final String? title;
  final List<T> items;
  final SantoMultiSelectListPickerSubmit<T>? onSubmit;
  final VoidCallback? onCancel;
  final SantoMultiSelectListPickerItemClick? onItemClick;
  final SantoPickerTitleConfig pickerTitleConfig;

  static void show<T extends SantoMultiSelectBottomPickerItem>(
    BuildContext context, {
    required List<T> items,
    SantoMultiSelectListPickerSubmit<T>? onSubmit,
    VoidCallback? onCancel,
    SantoMultiSelectListPickerItemClick? onItemClick,
    SantoPickerTitleConfig pickerTitleConfig = SantoPickerTitleConfig.Default,
    bool isDismissible = true,
  }) {
    showModalBottomSheet(
      context: context,
      isDismissible: isDismissible,
      backgroundColor: Colors.transparent,
      builder: (BuildContext dialogContext) {
        return SantoMultiSelectListPicker<T>(
          items: items,
          onSubmit: onSubmit,
          onCancel: onCancel,
          onItemClick: onItemClick,
          pickerTitleConfig: pickerTitleConfig,
        );
      },
    );
  }

  SantoMultiSelectListPicker({
    Key? key,
    this.title,
    required this.items,
    this.pickerTitleConfig = SantoPickerTitleConfig.Default,
    this.onSubmit,
    this.onCancel,
    this.onItemClick,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MultiSelectDialogWidgetState<T>();
  }
}

class MultiSelectDialogWidgetState<T extends SantoMultiSelectBottomPickerItem> extends State<SantoMultiSelectListPicker<T>> {
  @override
  Widget build(BuildContext context) {
    return SantoPickerClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(SantoThemeConfigurator.instance
            .getConfig()
            .pickerConfig
            .cornerRadius),
        topRight: Radius.circular(SantoThemeConfigurator.instance
            .getConfig()
            .pickerConfig
            .cornerRadius),
      ),
      child: Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Offstage(
                  offstage: !widget.pickerTitleConfig.showTitle,
                  child: SantoPickerTitle(
                    pickerTitleConfig: widget.pickerTitleConfig,
                    onConfirm: () {
                      List<T> selectedItems = [];
                      if (widget.onSubmit != null) {
                        for (int i = 0; i < widget.items.length; i++) {
                          if (widget.items[i].isChecked) {
                            selectedItems.add(widget.items[i]);
                          }
                        }
                        if (widget.onSubmit != null) {
                          widget.onSubmit!(selectedItems);
                        }
                      }
                    },
                    onCancel: widget.onCancel ??
                        () {
                          Navigator.of(context).pop();
                        },
                  ),
                ),
                LimitedBox(
                    maxWidth: double.infinity,
                    maxHeight: pickerHeight,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) =>
                            _buildItem(context, index),
                        itemCount: widget.items.length)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            widget.items[index].isChecked = !widget.items[index].isChecked;
          });
          if (widget.onItemClick != null) {
            widget.onItemClick!(context, index);
          }
        },
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(
                  commonConfig.hSpacingLg, 0, commonConfig.hSpacingLg, 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Text(widget.items[index].content,
                          style: TextStyle(
                              fontSize: commonConfig.fontSizeSubHead,
                              fontWeight: widget.items[index].isChecked
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                              color: widget.items[index].isChecked
                                  ? SantoThemeConfigurator.instance
                                      .getConfig()
                                      .commonConfig
                                      .brandPrimary
                                  : SantoThemeConfigurator.instance
                                      .getConfig()
                                      .commonConfig
                                      .colorTextBase))),
                  Container(
                      alignment: Alignment.center,
                      height: 50,
                      child: widget.items[index].isChecked
                          ? SantoTools.getAssetImageWithBandColor(
                              SantoAsset.iconMultiSelected)
                          : SantoTools.getAssetImage(SantoAsset.iconUnSelect)),
                ],
              ),
            ),
            index != widget.items.length - 1
                ? Padding(
                    padding: EdgeInsets.fromLTRB(
                        commonConfig.hSpacingLg, 0, commonConfig.hSpacingLg, 0),
                    child: SantoLine())
                : const SizedBox.shrink()
          ],
        ));
  }
}
