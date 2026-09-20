import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 标签状态,决定预设配色:底色为状态色 10% 透明度,文字为状态色
///
/// @since v1.1.0 由 TagState 更名而来
enum SantoTagState {
  /// 等待,黄色
  waiting,

  /// 失效,灰色
  invalidate,

  /// 运行,蓝色
  running,

  /// 失败,红色
  failed,

  /// 成功,绿色
  succeed,
}

/// 标签组件,库内唯一的标签入口
///
/// 不同形态全部通过参数实现,参考 antd Tag:
/// * 普通标签:默认主题色底 + 反白文字
/// * 描边标签:[bordered] 为 true,透明底 + 主题色文字与边框
/// * 状态标签:[state] 传 [SantoTagState] 五态之一,按状态取预设配色
/// * 多彩标签:[backgroundColor] / [textColor] / [borderColor] 自定义配色
///
/// 标签自适应内容宽度(勿在外部包 alignment),[maxWidth] 限制最大宽度,
/// 超出省略。
///
/// @since v1.1.0 由 SantoTagCustom 与 SantoStateTag 收敛而来
///
/// 示例:
/// ```dart
/// SantoTag(text: '标签')
/// SantoTag(text: '已盘点', bordered: true)
/// SantoTag(text: '进行中', state: SantoTagState.running)
/// SantoTag(text: '红色标签', backgroundColor: Color(0xFFFF4D4F))
/// ```
class SantoTag extends StatelessWidget {
  /// 标签文字
  final String text;

  /// 标签状态,非 null 时按状态取预设配色;
  /// 显式传入 [backgroundColor] / [textColor] 可覆盖预设配色
  final SantoTagState? state;

  /// 背景色,优先级高于 [state] 预设配色;
  /// 描边标签([bordered] 为 true)不传时为透明
  final Color? backgroundColor;

  /// 文字颜色,优先级高于 [state] 预设配色与默认反白文字
  final Color? textColor;

  /// 是否为描边标签,描边标签透明底、文字与边框同色
  final bool bordered;

  /// 边框颜色,默认取状态色([state] 非 null)或主题品牌色
  final Color? borderColor;

  /// 边框宽度,默认 1
  final double borderWidth;

  /// 标签圆角,默认 12
  final BorderRadius borderRadius;

  /// 内边距,默认横向 4、纵向 2
  final EdgeInsetsGeometry padding;

  /// 文字大小,默认 11
  final double fontSize;

  /// 文字粗细,默认正常
  final FontWeight fontWeight;

  /// 最大宽度,超出省略
  final double? maxWidth;

  const SantoTag({
    Key? key,
    required this.text,
    this.state,
    this.backgroundColor,
    this.textColor,
    this.bordered = false,
    this.borderColor,
    this.borderWidth = 1,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.padding = const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    this.fontSize = 11,
    this.fontWeight = FontWeight.normal,
    this.maxWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final Color? stateColor = _stateColor(state);

    Color background;
    Color foreground;
    if (bordered) {
      background = Colors.transparent;
      foreground = textColor ??
          borderColor ??
          stateColor ??
          commonConfig.brandPrimary;
    } else if (stateColor != null) {
      background = backgroundColor ?? stateColor.withOpacity(0.1);
      foreground = textColor ?? stateColor;
    } else {
      background = backgroundColor ?? commonConfig.brandPrimary;
      foreground = textColor ?? commonConfig.colorTextBaseInverse;
    }

    // 不设置 alignment:标签默认按内容自适应宽度;
    // 设置 alignment 会让 Container 在有界约束下撑满可用宽度
    return Container(
      constraints: maxWidth != null ? BoxConstraints(maxWidth: maxWidth!) : null,
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.rectangle,
        borderRadius: borderRadius,
        border: bordered
            ? Border.all(
                color: borderColor ?? foreground,
                width: borderWidth,
              )
            : null,
      ),
      padding: padding,
      child: Text(
        text,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: fontSize,
          color: foreground,
          fontWeight: fontWeight,
        ),
      ),
    );
  }

  static Color? _stateColor(SantoTagState? state) {
    switch (state) {
      case SantoTagState.invalidate:
        return const Color(0xFF808695);
      case SantoTagState.running:
        return const Color(0xFF1677FF);
      case SantoTagState.failed:
        return const Color(0xFFFF4D4F);
      case SantoTagState.succeed:
        return const Color(0xFF52C41A);
      case SantoTagState.waiting:
        return const Color(0xFFFAAD14);
      case null:
        return null;
    }
  }
}
