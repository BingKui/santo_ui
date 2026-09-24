import 'package:santo_ui/src/components/icon/santo_icon.dart';
import 'package:santo_ui/src/components/icon/santo_icons.dart';
import 'package:santo_ui/src/components/notice/santo_marquee_text.dart';
import 'package:santo_ui/src/theme/configs/santo_common_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 通知栏默认最小高度
const double kSantoNoticeMinHeight = 36;

/// 带左侧标签或右侧按钮时的默认最小高度
const double kSantoNoticeTallMinHeight = 54;

/// 右侧按钮高度
const double kSantoNoticeButtonHeight = 30;

/// 右侧按钮最小宽度
const double kSantoNoticeButtonMinWidth = 56;

/// 内置样式背景的透明度:状态色 10% 透明
const double kSantoNoticeBackgroundOpacity = 0.1;

/// 内置状态样式左侧的图标
const Map<SantoNoticeStyleType, String> kSantoNoticeStyleIcons =
    <SantoNoticeStyleType, String>{
  SantoNoticeStyleType.fail: SantoIcons.xmarkCircle,
  SantoNoticeStyleType.running: SantoIcons.hourglass,
  SantoNoticeStyleType.succeed: SantoIcons.checkCircle,
  SantoNoticeStyleType.warning: SantoIcons.warningTriangle,
  SantoNoticeStyleType.notice: SantoIcons.megaphone,
};

/// 内置状态样式的取色,跟随主题的对应品牌色
Color santoNoticeStyleColor(
  SantoCommonConfig commonConfig,
  SantoNoticeStyleType type,
) {
  switch (type) {
    case SantoNoticeStyleType.fail:
      return commonConfig.brandError;
    case SantoNoticeStyleType.running:
      return commonConfig.brandPrimary;
    case SantoNoticeStyleType.succeed:
      return commonConfig.brandSuccess;
    case SantoNoticeStyleType.warning:
      return commonConfig.brandWarning;
    case SantoNoticeStyleType.notice:
      return commonConfig.brandPrimary;
  }
}

/// 描述: 通知/公告栏,默认最小高度 36
///
/// 单个入口:左侧可以是状态图标或标签,右侧可以是状态图标或按钮,
/// 中间内容支持跑马灯,整条支持点击回调。
///
/// 内置样式的取色跟随主题(见 [NoticeStyles]),换主题色后自动生效;
/// 需要固定配色时用 [textColor] / [backgroundColor] 直接覆盖。
///
/// @since v1.5.1 由 SantoNoticeBar 与 SantoNoticeBarWithButton 收敛而来
class SantoNotice extends StatelessWidget {
  /// 通知的内容
  final String content;

  /// 自定义左边的控件,优先级高于 [leftTagText] 与 [showLeftIcon]
  final Widget? leftWidget;

  /// 是否显示左边的状态图标
  final bool showLeftIcon;

  /// 左边的标签文案,非空时左侧渲染标签(而非状态图标)
  final String? leftTagText;

  /// 左边标签的文字颜色,默认取[textColor]或样式色
  final Color? leftTagTextColor;

  /// 左边标签的背景颜色,默认取[textColor]或样式色
  final Color? leftTagBackgroundColor;

  /// 通知的文字颜色
  final Color? textColor;

  /// 背景颜色,默认取样式色的 10% 透明
  final Color? backgroundColor;

  /// 自定义右边的控件,优先级高于 [rightButtonText] 与 [showRightIcon]
  final Widget? rightWidget;

  /// 是否显示右边的状态图标(给了 [rightButtonText] 时不渲染)
  final bool showRightIcon;

  /// 右边按钮的文案,非空时右侧渲染按钮(而非状态图标)
  final String? rightButtonText;

  /// 右边按钮的文字颜色,默认取样式色
  final Color? rightButtonTextColor;

  /// 右边按钮的边框颜色,默认取样式色
  final Color? rightButtonBorderColor;

  /// 右边按钮点击的回调
  final VoidCallback? onRightButtonTap;

  /// 状态样式,取[NoticeStyles]里面的值,默认进行中
  final NoticeStyle? noticeStyle;

  /// 是否跑马灯
  /// 默认值false
  final bool marquee;

  /// 通知栏点击的回调
  final VoidCallback? onNoticeTap;

  /// 右侧状态图标点击的回调
  final VoidCallback? onRightIconTap;

  /// 最小高度。不传时:带左侧标签或右侧按钮取 54,否则取 36。
  /// 可以通过该属性控制组件高度,内容会自动垂直居中。
  final double? minHeight;

  /// 内容的内边距
  final EdgeInsets? padding;

  const SantoNotice({
    Key? key,
    required this.content,
    this.leftWidget,
    this.showLeftIcon = true,
    this.leftTagText,
    this.leftTagTextColor,
    this.leftTagBackgroundColor,
    this.textColor,
    this.backgroundColor,
    this.rightWidget,
    this.showRightIcon = true,
    this.rightButtonText,
    this.rightButtonTextColor,
    this.rightButtonBorderColor,
    this.onRightButtonTap,
    this.noticeStyle,
    this.marquee = false,
    this.onNoticeTap,
    this.onRightIconTap,
    this.minHeight,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SantoCommonConfig commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final NoticeStyle style = noticeStyle ?? NoticeStyles.runningWithArrow;
    final SantoNoticeStyleType? type = style.type;
    final Color accentColor = type == null
        ? style.textColor
        : santoNoticeStyleColor(commonConfig, type);

    final bool hasTag = leftTagText?.isNotEmpty ?? false;
    final bool hasButton = rightButtonText?.isNotEmpty ?? false;
    final double minHeight = this.minHeight ??
        (hasTag || hasButton
            ? kSantoNoticeTallMinHeight
            : kSantoNoticeMinHeight);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ??
            (type == null
                ? style.backgroundColor
                : accentColor.withOpacity(kSantoNoticeBackgroundOpacity)),
        borderRadius: BorderRadius.circular(commonConfig.radiusXs),
      ),
      padding: this.padding ??
          EdgeInsets.symmetric(horizontal: commonConfig.hSpacingLg),
      constraints: BoxConstraints(minHeight: minHeight),
      child: GestureDetector(
        onTap: onNoticeTap,
        child: Row(
          children: <Widget>[
            _buildLeftSlot(commonConfig, style, accentColor),
            Expanded(
              child: _buildContent(commonConfig, accentColor, minHeight),
            ),
            _buildRightSlot(commonConfig, style, accentColor),
          ],
        ),
      ),
    );
  }

  /// 左侧插槽:自定义控件 > 标签 > 状态图标,都没有时收成空
  Widget _buildLeftSlot(
    SantoCommonConfig commonConfig,
    NoticeStyle style,
    Color accentColor,
  ) {
    if (leftWidget != null) return leftWidget!;
    if (leftTagText?.isNotEmpty ?? false) {
      return Padding(
        padding: EdgeInsets.only(right: commonConfig.hSpacingSm, top: 2),
        child: Container(
          padding: EdgeInsets.all(commonConfig.vSpacingXs),
          decoration: BoxDecoration(
            color: leftTagBackgroundColor ?? accentColor,
            borderRadius: BorderRadius.circular(commonConfig.radiusXs),
          ),
          child: Text(
            leftTagText!,
            style: TextStyle(
              color: leftTagTextColor ?? commonConfig.colorTextBaseInverse,
              fontSize: commonConfig.fontSizeCaptionSm,
              fontWeight: FontWeight.w500,
              height: 1,
            ),
          ),
        ),
      );
    }
    if (!showLeftIcon) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(right: commonConfig.hSpacingSm),
      child: _buildLeftIcon(commonConfig, style, accentColor),
    );
  }

  /// 右侧插槽:自定义控件 > 按钮 > 状态图标,都没有时收成空
  Widget _buildRightSlot(
    SantoCommonConfig commonConfig,
    NoticeStyle style,
    Color accentColor,
  ) {
    if (rightWidget != null) return rightWidget!;
    if (rightButtonText?.isNotEmpty ?? false) {
      return GestureDetector(
        onTap: onRightButtonTap,
        child: Padding(
          padding: EdgeInsets.only(left: commonConfig.hSpacingSm),
          child: Container(
            height: kSantoNoticeButtonHeight,
            alignment: Alignment.center,
            constraints: const BoxConstraints(
              minWidth: kSantoNoticeButtonMinWidth,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: rightButtonBorderColor ?? accentColor,
                width: commonConfig.borderWidthMd,
              ),
              borderRadius: BorderRadius.circular(commonConfig.radiusXs),
            ),
            child: Text(
              rightButtonText!,
              style: TextStyle(
                color: rightButtonTextColor ?? accentColor,
                fontSize: commonConfig.fontSizeCaption,
                fontWeight: FontWeight.w500,
                height: 1,
              ),
            ),
          ),
        ),
      );
    }
    if (!showRightIcon) return const SizedBox.shrink();
    Widget icon = _buildRightIcon(commonConfig, style, accentColor);
    if (onRightIconTap != null) {
      icon = GestureDetector(onTap: onRightIconTap, child: icon);
    }
    return Padding(
      padding: EdgeInsets.only(left: commonConfig.hSpacingSm),
      child: icon,
    );
  }

  Widget _buildContent(
    SantoCommonConfig commonConfig,
    Color accentColor,
    double height,
  ) {
    final TextStyle textStyle = TextStyle(
      color: textColor ?? accentColor,
      fontSize: commonConfig.fontSizeBase,
    );
    if (marquee) {
      return SantoMarqueeText(
        height: height,
        text: content,
        textStyle: textStyle,
      );
    }
    return Text(content, overflow: TextOverflow.ellipsis, style: textStyle);
  }

  /// 内置样式按当前主题色重建图标,自定义样式沿用传入的图标
  Widget _buildLeftIcon(
    SantoCommonConfig commonConfig,
    NoticeStyle style,
    Color accentColor,
  ) {
    if (style.type == null) return style.leftIcon;
    return SantoIcon(
      kSantoNoticeStyleIcons[style.type]!,
      size: commonConfig.iconSizeSm,
      color: accentColor,
    );
  }

  /// 内置样式按当前主题色重建图标,自定义样式沿用传入的图标
  Widget _buildRightIcon(
    SantoCommonConfig commonConfig,
    NoticeStyle style,
    Color accentColor,
  ) {
    if (style.type == null) return style.rightIcon;
    return SantoIcon(
      style.rightIconKind == SantoNoticeRightIconKind.close
          ? SantoIcons.xmark
          : SantoIcons.navArrowRight,
      size: commonConfig.iconSizeMd,
      color: accentColor,
    );
  }
}

/// 内置状态样式的类型,取色由主题决定
enum SantoNoticeStyleType {
  /// 失败:错误色
  fail,

  /// 进行中:主题色
  running,

  /// 完成:成功色
  succeed,

  /// 警告:警告色
  warning,

  /// 通知/公告:主题色
  notice,
}

/// 内置样式右侧图标的形态
enum SantoNoticeRightIconKind {
  /// 箭头(可点击进入)
  arrow,

  /// 关闭
  close,
}

/// 默认通知样式集合,共十种
///
/// 预设里的颜色只是兜底值(与主题默认色一致),组件构建时会按当前主题色
/// 重新解析,所以换主题色后所有内置样式都会跟着变。
class NoticeStyles {
  /// 红色+失败+箭头
  static NoticeStyle failWithArrow =
      _preset(SantoNoticeStyleType.fail, SantoNoticeRightIconKind.arrow);

  /// 红色+失败+关闭
  static NoticeStyle failWithClose =
      _preset(SantoNoticeStyleType.fail, SantoNoticeRightIconKind.close);

  /// 蓝色+进行中+箭头
  static NoticeStyle runningWithArrow =
      _preset(SantoNoticeStyleType.running, SantoNoticeRightIconKind.arrow);

  /// 蓝色+进行中+关闭
  static NoticeStyle runningWithClose =
      _preset(SantoNoticeStyleType.running, SantoNoticeRightIconKind.close);

  /// 绿色+完成+箭头
  static NoticeStyle succeedWithArrow =
      _preset(SantoNoticeStyleType.succeed, SantoNoticeRightIconKind.arrow);

  /// 绿色+完成+关闭
  static NoticeStyle succeedWithClose =
      _preset(SantoNoticeStyleType.succeed, SantoNoticeRightIconKind.close);

  /// 橘色+警告+箭头
  static NoticeStyle warningWithArrow =
      _preset(SantoNoticeStyleType.warning, SantoNoticeRightIconKind.arrow);

  /// 橘色+警告+关闭
  static NoticeStyle warningWithClose =
      _preset(SantoNoticeStyleType.warning, SantoNoticeRightIconKind.close);

  /// 蓝色+通知+箭头
  static NoticeStyle normalNoticeWithArrow =
      _preset(SantoNoticeStyleType.notice, SantoNoticeRightIconKind.arrow);

  /// 蓝色+通知+关闭
  static NoticeStyle normalNoticeWithClose =
      _preset(SantoNoticeStyleType.notice, SantoNoticeRightIconKind.close);

  static NoticeStyle _preset(
    SantoNoticeStyleType type,
    SantoNoticeRightIconKind rightIconKind,
  ) {
    final Color color = _fallbackColor(type);
    return NoticeStyle(
      SantoIcon(kSantoNoticeStyleIcons[type]!, size: 14, color: color),
      color,
      _fallbackBackground(type),
      SantoIcon(
        rightIconKind == SantoNoticeRightIconKind.close
            ? SantoIcons.xmark
            : SantoIcons.navArrowRight,
        size: 16,
        color: color,
      ),
      type: type,
      rightIconKind: rightIconKind,
    );
  }

  /// 与主题默认品牌色一致的兜底色
  static Color _fallbackColor(SantoNoticeStyleType type) {
    switch (type) {
      case SantoNoticeStyleType.fail:
        return const Color(0xFFFF4D4F);
      case SantoNoticeStyleType.running:
        return const Color(0xFF1677FF);
      case SantoNoticeStyleType.succeed:
        return const Color(0xFF52C41A);
      case SantoNoticeStyleType.warning:
        return const Color(0xFFFAAD14);
      case SantoNoticeStyleType.notice:
        return const Color(0xFF1677FF);
    }
  }

  /// 与主题默认品牌色一致的兜底浅底色
  static Color _fallbackBackground(SantoNoticeStyleType type) {
    switch (type) {
      case SantoNoticeStyleType.fail:
        return const Color(0xFFFFF2F0);
      case SantoNoticeStyleType.running:
        return const Color(0xFFE6F4FF);
      case SantoNoticeStyleType.succeed:
        return const Color(0xFFF6FFED);
      case SantoNoticeStyleType.warning:
        return const Color(0xFFFFFBE6);
      case SantoNoticeStyleType.notice:
        return const Color(0xFFE6F4FF);
    }
  }
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

  /// 内置样式类型,非空时图标与取色在构建时按主题解析
  final SantoNoticeStyleType? type;

  /// 内置样式右侧图标的形态
  final SantoNoticeRightIconKind? rightIconKind;

  NoticeStyle(
    this.leftIcon,
    this.textColor,
    this.backgroundColor,
    this.rightIcon, {
    this.type,
    this.rightIconKind,
  });
}
