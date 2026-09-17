import 'package:santo_ui/src/constants/santo_asset_constants.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/theme/configs/santo_card_title_config.dart';
import 'package:santo_ui/src/utils/santo_tools.dart';
import 'package:flutter/material.dart';

/// 右侧为箭头的卡片标题组件
///
/// 组件的展示规则：
///         1：标题不可以折行，当辅助widget和subwidget过多时，标题...截断
///         2: 展示出sub和ac
///         3: 标题字体为18
///         4: subTitle的宽度最大84
///
/// 布局间距：
///     标题文本和 subWidget的间距为8dp
///     subWidget和最右侧的widget的间距为8dp
///
/// 布局规则：
///    该组件的整体实现是Row，最右侧是固定的箭头，因此左侧文本部分过长会被截断
///
/// 整个组件是可以响应点击事件的[onTap],如果onTap是null，那么只是普通的展示组件，不会影响用户的其他点击事件
///
/// 标题为文本
/// SantoActionCardTitle(
///    title: '箭头标题',
///    onTap: () {
///        SantoToast.show('SantoActionCardTitle is clicked', context);
///    },
/// )
///
/// 相关按钮如下:
///  * [SantoCommonCardTitle], 普通卡片标题组件
///
class SantoActionCardTitle extends StatelessWidget {
  ///标题显示文案：必填参数
  final String title;

  ///箭头左边的文字
  final String? accessoryText;

  ///标题点击
  final VoidCallback? onTap;

  ///标题右侧的小文字
  final String? subTitle;

  ///标题右侧的显示widget
  final Widget? subTitleWidget;

  /// the theme config of themeData
  final SantoCardTitleConfig? themeData;

  /// create SantoActionCardTitle
  SantoActionCardTitle({
    Key? key,
    required this.title,
    this.accessoryText,
    this.onTap,
    this.subTitle,
    this.subTitleWidget,
    this.themeData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SantoCardTitleConfig defaultConfig = themeData ?? SantoCardTitleConfig();
    defaultConfig = SantoThemeConfigurator.instance
        .getConfig(configId: defaultConfig.configId)
        .cardTitleConfig
        .merge(defaultConfig);

    if (null == onTap) {
      return _rowWidget(context, defaultConfig);
    }
    return GestureDetector(
      child: _rowWidget(context, defaultConfig),
      onTap: onTap,
    );
  }

  Widget _rowWidget(BuildContext context, SantoCardTitleConfig defaultConfig) {
    var row = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          //左侧信息
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                //标题尽可能的展示
                child: _titleWidget(defaultConfig),
              ),
              //子widget的展示
              _sub(defaultConfig),
            ],
          ),
        ),
        _accessoryTextWidget(defaultConfig)
      ],
    );
    return Container(
      color: defaultConfig.cardBackgroundColor,
      child: row,
      padding: defaultConfig.cardTitlePadding,
    );
  }

  Widget _titleWidget(SantoCardTitleConfig defaultConfig) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return Container(
      padding: EdgeInsets.only(right: commonConfig.hSpacingSm),
      child: Text(
        this.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: defaultConfig.titleTextStyle.generateTextStyle(),
      ),
    );
  }

  // 如果传入了subTitleWidget 则以subTitleWidget为主
  Widget _sub(SantoCardTitleConfig defaultConfig) {
    if (subTitleWidget != null) {
      return subTitleWidget!;
    }

    if (subTitle != null) {
      return Container(
        constraints: BoxConstraints(maxWidth: 84),
        child: Text(this.subTitle!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _subTextStyle(defaultConfig)),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _arrowWidget() {
    return SantoTools.getAssetSizeImage(SantoAsset.iconRightArrow, 16, 16);
  }

  Widget _accessoryTextWidget(SantoCardTitleConfig defaultConfig) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return Padding(
      padding: EdgeInsets.only(left: commonConfig.hSpacingLg),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            constraints: BoxConstraints(maxWidth: 84),
            child: Text(
              accessoryText ?? "",
              overflow: TextOverflow.ellipsis,
              style: defaultConfig.accessoryTextStyle.generateTextStyle(),
            ),
          ),
          _arrowWidget()
        ],
      ),
    );
  }

  //标题右侧的小文字 样式
  TextStyle _subTextStyle(SantoCardTitleConfig defaultConfig) =>
      defaultConfig.subtitleTextStyle.generateTextStyle();
}
