import 'package:santo_ui/src/components/selection/bean/santo_selection_common_entity.dart';
import 'package:santo_ui/src/components/selection/santo_selection_util.dart';
import 'package:santo_ui/src/constants/santo_asset_constants.dart';
import 'package:santo_ui/src/theme/configs/santo_selection_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/utils/santo_tools.dart';
import 'package:santo_ui/src/utils/css/santo_css_2_text.dart';
import 'package:flutter/material.dart';

/// [SantoSelectionSingleListWidget] 子组件中的单项
class SantoSelectionCommonItemWidget extends StatelessWidget {

  /// 单项数据
  final SantoSelectionEntity item;

  /// 背景色
  final Color? backgroundColor;

  /// 选中项背景色
  final Color? selectedBackgroundColor;

  /// 是否当前焦点
  final bool isCurrentFocused;

  /// 是否是第一级
  final bool isFirstLevel;

  /// 是否是多选列表类型
  final bool isMoreSelectionListType;

  /// 单选回调
  final ValueChanged<SantoSelectionEntity>? itemSelectFunction;

  /// 主题配置
  final SantoSelectionConfig? themeData;

  SantoSelectionCommonItemWidget({
    Key? key,
    required this.item,
    this.backgroundColor,
    this.isFirstLevel = false,
    this.isMoreSelectionListType = false,
    this.itemSelectFunction,
    this.selectedBackgroundColor,
    this.isCurrentFocused = false,
    this.themeData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    Container checkbox;
    if (!item.isUnLimit() && (item.children.isEmpty)) {
      if (item.isInLastLevel() && item.hasCheckBoxBrother()) {
        checkbox = Container(
          padding: EdgeInsets.only(left: commonConfig.hSpacingXs),
          width: 21,
          child: (item.isSelected)
              ? SantoTools.getAssetImageWithBandColor(
                  SantoAsset.iconMultiSelected)
              : SantoTools.getAssetImage(SantoAsset.iconUnSelect),
        );
      } else {
        checkbox = Container();
      }
    } else {
      checkbox = Container();
    }

    return GestureDetector(
      onTap: () {
        if (itemSelectFunction != null) {
          itemSelectFunction!(item);
        }
      },
      child: Container(
        padding: EdgeInsets.only(
            left: commonConfig.hSpacingLg,
            right: commonConfig.hSpacingLg,
            top: commonConfig.vSpacingSm,
            bottom: commonConfig.vSpacingSm),
        color: getItemBGColor(),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    child: Expanded(
                      child: Text(
                        item.title + getSelectedItemCount(item),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: getItemTextStyle(),
                      ),
                    ),
                  ),
                  checkbox
                ],
              ),
              Visibility(
                visible: !SantoTools.isEmpty(item.subTitle),
                child: Padding(
                  padding:
                      EdgeInsets.only(right: item.isInLastLevel() ? 21 : 0),
                  child: SantoCSS2Text.toTextView(item.subTitle ?? '',
                      defaultStyle: TextStyle(
                          fontSize: commonConfig.fontSizeCaption,
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none,
                          color: themeData?.commonConfig.colorTextSecondary),
                      maxLines: 1,
                      textOverflow: TextOverflow.ellipsis),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// 获取当前节点的背景色
  Color? getItemBGColor() {
    if (isCurrentFocused) {
      return this.selectedBackgroundColor;
    } else {
      return this.backgroundColor;
    }
  }

  /// 是否高亮
  bool isHighLight(SantoSelectionEntity item) {
    if (item.isInLastLevel()) {
      if (item.isUnLimit()) {
        return isCurrentFocused;
      } else {
        return item.isSelected;
      }
    } else {
      return isCurrentFocused;
    }
  }

  /// 是否加粗
  bool isBold(SantoSelectionEntity item) {
    if (isHighLight(item)) {
      return true;
    } else {
      return item.hasCheckBoxBrother() && item.selectedList().isNotEmpty;
    }
  }

  /// 获取当前节点的文本样式
  TextStyle? getItemTextStyle() {
    if (isHighLight(item)) {
      return themeData?.itemSelectedTextStyle.generateTextStyle();
    } else if (isBold(item)) {
      return themeData?.itemBoldTextStyle.generateTextStyle();
    }
    return themeData?.itemNormalTextStyle.generateTextStyle();
  }

  /// 获取当前节点的子节点中，选中的数量
  String getSelectedItemCount(SantoSelectionEntity item) {
    String itemCount = "";
    if ((SantoSelectionUtil.getTotalLevel(item) < 3 || !isFirstLevel) &&
        item.children.isNotEmpty) {
      int count =
          item.children.where((f) => f.isSelected && !f.isUnLimit()).length;
      if (count > 1) {
        return '($count)';
      } else if (count == 1 && item.hasCheckBoxBrother()) {
        return '($count)';
      } else {
        var unLimited =
            item.children.where((f) => f.isSelected && f.isUnLimit()).toList();
        if (unLimited.isNotEmpty) {
          return '(全部)';
        }
      }
    }
    return itemCount;
  }
}
