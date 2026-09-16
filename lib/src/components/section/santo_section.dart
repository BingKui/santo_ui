import 'package:santo_ui/src/theme/configs/santo_section_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 区块组件:上方为演示内容,下方为标题 + 描述信息,整体圆角卡片
///
/// 参考 antd 官网示例卡片的排版:演示区域在上,标题与描述在下,中间以分割线隔开。
///
/// 示例:
/// ```dart
/// SantoSection(
///   title: '基础用法',
///   description: '通过 type 语法糖使用预设的按钮样式',
///   child: Text('演示内容'),
/// )
/// ```
class SantoSection extends StatelessWidget {
  /// 上方演示内容
  final Widget? child;

  /// 下方标题文案,优先级低于 [titleWidget]
  final String? title;

  /// 自定义标题控件,设置后 [title] 失效
  final Widget? titleWidget;

  /// 标题右侧的附加控件,如编辑图标
  final Widget? titleSuffix;

  /// 标题下方的描述文案,优先级低于 [descriptionWidget]
  final String? description;

  /// 自定义描述控件,用于富文本/内联代码等场景
  final Widget? descriptionWidget;

  /// 展示区内边距,默认使用主题配置
  final EdgeInsets? contentPadding;

  /// 标题/描述区域内边距,默认使用主题配置
  final EdgeInsets? footerPadding;

  /// 是否显示展示区与标题之间的分割线,默认使用主题配置
  final bool? showDivider;

  /// 背景色,默认使用主题配置
  final Color? backgroundColor;

  /// 圆角,默认 12
  final double? radius;

  /// 区块主题配置
  final SantoSectionConfig? themeData;

  const SantoSection({
    Key? key,
    this.child,
    this.title,
    this.titleWidget,
    this.titleSuffix,
    this.description,
    this.descriptionWidget,
    this.contentPadding,
    this.footerPadding,
    this.showDivider,
    this.backgroundColor,
    this.radius,
    this.themeData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SantoSectionConfig config = themeData ?? SantoSectionConfig();
    config = SantoThemeConfigurator.instance
        .getConfig(configId: config.configId)
        .sectionConfig
        .merge(config);

    final footer = _buildFooter(config);
    final hasFooter = footer != null;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? config.backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(radius ?? config.radius)),
        border: Border.all(
          color: config.borderColor,
          width: config.borderWidth,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (child != null)
            Padding(
              padding: contentPadding ?? config.contentPadding,
              child: child,
            ),
          if (child != null && hasFooter && (showDivider ?? config.showDivider))
            Container(height: config.borderWidth, color: config.dividerColor),
          if (hasFooter) footer,
        ],
      ),
    );
  }

  /// 下方标题 + 描述区域
  Widget? _buildFooter(SantoSectionConfig config) {
    Widget? titleWidget = this.titleWidget;
    titleWidget ??= title == null
        ? null
        : DefaultTextStyle(
            style: config.titleTextStyle.generateTextStyle(),
            child: Text(title!),
          );

    Widget? descriptionWidget = this.descriptionWidget;
    descriptionWidget ??= description == null
        ? null
        : DefaultTextStyle(
            style: config.descriptionTextStyle.generateTextStyle(),
            child: Text(description!),
          );

    if (titleWidget == null && descriptionWidget == null) return null;

    return Padding(
      padding: footerPadding ?? config.footerPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (titleWidget != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(child: titleWidget),
                if (titleSuffix != null) ...[
                  const SizedBox(width: 6),
                  titleSuffix!,
                ],
              ],
            ),
          if (titleWidget != null && descriptionWidget != null)
            const SizedBox(height: 6),
          if (descriptionWidget != null) descriptionWidget,
        ],
      ),
    );
  }
}
