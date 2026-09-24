

import 'package:santo_ui/src/components/text/santo_expandable_text.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 气泡贴齐方向
///
/// 参考 ant-design-x Bubble 的 placement：
///  * [start] 气泡在左侧，左上角为小圆角
///  * [end] 气泡在右侧，右上角为小圆角
enum SantoBubblePlacement {
  start,
  end,
}

/// 具备展开收起功能的气泡背景文字面板
///
/// 参考 ant-design-x Bubble：气泡整体为圆角矩形，贴齐侧的上角收为小圆角。
///
/// 布局规则：
///     组件的背景是气泡背景
///     包装了[SantoExpandableText]组件，具备了展开收起的能力
///
/// ```dart
///   SantoBubbleText(
///      text: '在文本的右下角有更多或者收起按钮',
///   )
///
///   SantoBubbleText(
///      text: '具备展开收起功能的文字面板，在文本的右下角有更多或者收起按钮',
///      maxLines: 2,
///   )
///
///   SantoBubbleText(
///      text: '自定义背景色和文字颜色',
///      placement: SantoBubblePlacement.end,
///      backgroundColor: Color(0xFF1677FF),
///      textColor: Colors.white,
///   )
/// ```
///
/// 相关文本组件如下:
///  * [SantoExpandableText], 气泡背景的展开收起文本组件
///
class SantoBubbleText extends StatelessWidget {
  /// 显示的文本
  final String text;

  ///最多显示的行数
  final int? maxLines;

  ///展开收起回调
  final TextExpandedCallback? onExpanded;

  /// 气泡的圆角 默认取主题 `radiusMd`
  final double? radius;

  /// 气泡贴齐侧上角的小圆角 默认是2
  ///
  /// 参考 ant-design-x Bubble：start 气泡缩小左上角，end 气泡缩小右上角
  final double cornerRadius;

  /// 气泡贴齐方向 默认[SantoBubblePlacement.start]
  final SantoBubblePlacement placement;

  /// 气泡背景色  默认取主题 `fillBody`
  final Color? backgroundColor;

  /// 内容文字颜色，优先级低于[textStyle]
  final Color? textColor;

  /// 内容文本样式
  final TextStyle? textStyle;

  /// create SantoBubbleText
  const SantoBubbleText(
      {Key? key,
      this.text = '',
      this.maxLines,
      this.onExpanded,
      this.radius,
      this.cornerRadius = 2,
      this.placement = SantoBubblePlacement.start,
      this.backgroundColor,
      this.textColor,
      this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildExpandedWidget();
  }

  Widget _buildExpandedWidget() {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final isStart = placement == SantoBubblePlacement.start;
    final double radius = this.radius ?? commonConfig.radiusMd;
    final Color backgroundColor =
        this.backgroundColor ?? commonConfig.fillBody;
    return Align(
      alignment: isStart ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isStart ? cornerRadius : radius),
                topRight: Radius.circular(isStart ? radius : cornerRadius),
                bottomLeft: Radius.circular(radius),
                bottomRight: Radius.circular(radius))),
        padding: EdgeInsets.only(
            left: commonConfig.hSpacingLg,
            right: commonConfig.hSpacingLg,
            top: 12,
            bottom: 12),
        child: SantoExpandableText(
          text: text,
          maxLines: maxLines,
          color: backgroundColor,
          onExpanded: onExpanded,
          textStyle: textStyle ??
              TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: commonConfig.fontSizeBase,
                color: textColor ?? commonConfig.colorTextBase,
              ),
        ),
      ),
    );
  }
}
