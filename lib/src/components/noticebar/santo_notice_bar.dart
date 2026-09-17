import 'package:santo_ui/src/components/noticebar/santo_marquee_text.dart';
import 'package:santo_ui/src/constants/santo_asset_constants.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/utils/santo_tools.dart';
import 'package:flutter/material.dart';

/// 描述: 通知，默认最小高度36
/// 1. 支持十种默认样式
/// 2. 支持设置或者隐藏左右图标
/// 3. 支持跑马灯

class SantoNoticeBar extends StatelessWidget {
  /// 自定义左边的图标
  final Widget? leftWidget;

  /// 是否显示左边的图标
  final bool showLeftIcon;

  /// 通知的内容
  final String content;

  /// 通知的文字颜色
  final Color? textColor;

  /// 背景颜色
  final Color? backgroundColor;

  /// 右边的图标
  final Widget? rightWidget;

  /// 是否显示右边的图标
  /// 默认值true
  final bool showRightIcon;

  /// 默认样式，取[NoticeStyles]里面的值
  final NoticeStyle? noticeStyle;

  /// 是否跑马灯
  /// 默认值false
  final bool marquee;

  /// 通知钮点击的回调
  final VoidCallback? onNoticeTap;

  /// 右侧图标点击的回调
  final VoidCallback? onRightIconTap;

  /// 最小高度。leftWidget、rightWidget 都为空时，限制的最小高度。
  /// 可以通过该属性控制组件高度，内容会自动垂直居中。
  /// 默认值 36。
  final double minHeight;

  /// 内容的内边距
  final EdgeInsets? padding;

  const SantoNoticeBar(
      {Key? key,
      this.leftWidget,
      this.showLeftIcon = true,
      required this.content,
      this.textColor,
      this.backgroundColor,
      this.rightWidget,
      this.showRightIcon = true,
      this.noticeStyle,
      this.onNoticeTap,
      this.onRightIconTap,
      this.marquee = false,
      this.padding,
      this.minHeight = 36})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    NoticeStyle defaultStyle = NoticeStyles.runningWithArrow;

    Widget tempRightWidget =
        rightWidget ?? (noticeStyle?.rightIcon ?? defaultStyle.rightIcon);
    if (onRightIconTap != null) {
      tempRightWidget = GestureDetector(
        child: tempRightWidget,
        onTap: () {
          onRightIconTap!();
        },
      );
    }

    Widget contentWidget;
    if (marquee) {
      contentWidget = SantoMarqueeText(
        height: 36,
        text: content,
        textStyle: TextStyle(
          color:
              textColor ?? (noticeStyle?.textColor ?? defaultStyle.textColor),
          fontSize: commonConfig.fontSizeBase,
        ),
      );
    } else {
      contentWidget = Text(
        content,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color:
              textColor ?? (noticeStyle?.textColor ?? defaultStyle.textColor),
          fontSize: commonConfig.fontSizeBase,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ??
            (noticeStyle != null
                ? noticeStyle!.backgroundColor
                : defaultStyle.backgroundColor),
        borderRadius: BorderRadius.circular(commonConfig.radiusXs),
      ),
      padding: this.padding ??
          EdgeInsets.symmetric(horizontal: commonConfig.hSpacingLg),
      constraints: BoxConstraints(minHeight: this.minHeight),
      child: GestureDetector(
        onTap: () {
          if (onNoticeTap != null) {
            onNoticeTap!();
          }
        },
        child: Row(
          children: <Widget>[
            Offstage(
              offstage: !showLeftIcon,
              child: Padding(
                padding: EdgeInsets.only(right: commonConfig.hSpacingSm),
                child: leftWidget ??
                    (noticeStyle?.leftIcon ?? defaultStyle.leftIcon),
              ),
            ),
            Expanded(
              child: contentWidget,
            ),
            Offstage(
              offstage: !showRightIcon,
              child: Padding(
                padding: EdgeInsets.only(left: commonConfig.hSpacingSm),
                child: tempRightWidget,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 默认通知样式集合，共十种
class NoticeStyles {
  ///红色+失败+箭头
  static NoticeStyle failWithArrow = NoticeStyle(
      SantoTools.getAssetImage(SantoAsset.iconNoticeFail),
      Color(0xFFFF4D4F),
      Color(0xFFFFF2F0),
      SantoTools.getAssetImage(SantoAsset.iconNoticeArrowRed));

  ///红色+失败+关闭
  static NoticeStyle failWithClose = NoticeStyle(
      SantoTools.getAssetImage(SantoAsset.iconNoticeFail),
      Color(0xFFFF4D4F),
      Color(0xFFFFF2F0),
      SantoTools.getAssetImage(SantoAsset.iconNoticeCloseRed));

  ///蓝色+进行中+箭头
  static NoticeStyle runningWithArrow = NoticeStyle(
      SantoTools.getAssetImage(SantoAsset.iconNoticeRunning),
      Color(0xFF1677FF),
      Color(0xFFE6F4FF),
      SantoTools.getAssetImage(SantoAsset.iconNoticeArrowBlue));

  ///蓝色+进行中+关闭
  static NoticeStyle runningWithClose = NoticeStyle(
      SantoTools.getAssetImage(SantoAsset.iconNoticeRunning),
      Color(0xFF1677FF),
      Color(0xFFE6F4FF),
      SantoTools.getAssetImage(SantoAsset.iconNoticeCloseBlue));

  ///绿色+完成+箭头
  static NoticeStyle succeedWithArrow = NoticeStyle(
      SantoTools.getAssetImage(SantoAsset.iconNoticeSucceed),
      Color(0xFF52C41A),
      Color(0xFFF6FFED),
      SantoTools.getAssetImage(SantoAsset.iconNoticeArrowGreen));

  ///绿色+完成+关闭
  static NoticeStyle succeedWithClose = NoticeStyle(
      SantoTools.getAssetImage(SantoAsset.iconNoticeSucceed),
      Color(0xFF52C41A),
      Color(0xFFF6FFED),
      SantoTools.getAssetImage(SantoAsset.iconNoticeCloseGreen));

  ///橘色+警告+箭头
  static NoticeStyle warningWithArrow = NoticeStyle(
      SantoTools.getAssetImage(SantoAsset.iconNoticeWarning),
      Color(0xFFFAAD14),
      Color(0xFFFFFBE6),
      SantoTools.getAssetImage(SantoAsset.iconNoticeArrowOrange));

  ///橘色+警告+关闭
  static NoticeStyle warningWithClose = NoticeStyle(
      SantoTools.getAssetImage(SantoAsset.iconNoticeWarning),
      Color(0xFFFAAD14),
      Color(0xFFFFFBE6),
      SantoTools.getAssetImage(SantoAsset.iconNoticeCloseOrange));

  ///橘色+通知+箭头
  static NoticeStyle normalNoticeWithArrow = NoticeStyle(
      SantoTools.getAssetImage(SantoAsset.iconNotice),
      Color(0xFFFAAD14),
      Color(0xFFFFFBE6),
      SantoTools.getAssetImage(SantoAsset.iconNoticeArrowOrange));

  ///橘色+通知+关闭
  static NoticeStyle normalNoticeWithClose = NoticeStyle(
      SantoTools.getAssetImage(SantoAsset.iconNotice),
      Color(0xFFFAAD14),
      Color(0xFFFFFBE6),
      SantoTools.getAssetImage(SantoAsset.iconNoticeCloseOrange));
}

/// 通知样式
class NoticeStyle {
  ///左边的图标
  final Widget leftIcon;

  ///通知的文字颜色
  final Color textColor;

  ///背景颜色
  final Color backgroundColor;

  ///右边的图标
  final Widget rightIcon;

  NoticeStyle(
      this.leftIcon, this.textColor, this.backgroundColor, this.rightIcon);
}
