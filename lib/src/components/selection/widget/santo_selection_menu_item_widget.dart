import 'package:santo_ui/src/theme/configs/santo_selection_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/components/icon/santo_icon.dart';
import 'package:santo_ui/src/components/icon/santo_icons.dart';
import 'package:flutter/material.dart';

/// 筛选菜单项
// ignore: must_be_immutable
class SantoSelectionMenuItemWidget extends StatelessWidget {

  /// 菜单项标题
  final String title;

  /// 是否高亮
  final bool isHighLight;

  /// 是否选中
  final bool active;

  /// 点击事件
  final VoidCallback? itemClickFunction;

  /// 主题配置
  SantoSelectionConfig themeData;

  SantoSelectionMenuItemWidget(
      {Key? key,
      required this.title,
      this.isHighLight = false,
      this.active = false,
      this.itemClickFunction,
      required this.themeData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _menuItemTapped();
        },
        child: Container(
          color: Colors.transparent,
          constraints: BoxConstraints.expand(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  child: Flexible(
                child: Text(
                  this.title,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: true,
                  style: isHighLight
                      ? themeData.menuSelectedTextStyle.generateTextStyle()
                      : themeData.menuNormalTextStyle.generateTextStyle(),
                ),
              )),
              Padding(
                  padding: EdgeInsets.only(left: commonConfig.hSpacingXs),
                  child: isHighLight
                      ? SantoIcon(
                          active
                              ? SantoIcons.navArrowUp
                              : SantoIcons.navArrowDown,
                          size: commonConfig.iconSizeXs,
                          color: commonConfig.brandPrimary)
                      : SantoIcon(
                          active
                              ? SantoIcons.navArrowUp
                              : SantoIcons.navArrowDown,
                          size: commonConfig.iconSizeXs,
                          color: (isHighLight || active)
                              ? commonConfig.brandPrimary
                              : commonConfig.colorTextDisabled))
            ],
          ),
        ),
      ),
      flex: 1,
    );
  }

  void _menuItemTapped() {
    if (this.itemClickFunction != null) {
      this.itemClickFunction!();
    }
  }
}
