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

  /// 区块外边距,默认使用主题配置
  final EdgeInsets? margin;

  /// 展示区内边距,默认使用主题配置
  final EdgeInsets? contentPadding;

  /// 标题/描述区域内边距,默认使用主题配置
  final EdgeInsets? footerPadding;

  /// 背景色,默认使用主题配置
  final Color? backgroundColor;

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
    this.margin,
    this.contentPadding,
    this.footerPadding,
    this.backgroundColor,
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
    final hasTitle = titleWidget != null || title != null;

    return Container(
      margin: margin ?? config.margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? config.backgroundColor,
        // 圆角固定 12
        borderRadius: BorderRadius.all(Radius.circular(kSantoSectionRadius)),
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
          // 有标题时分割线由标题行两侧延伸线承担,避免重复画线
          if (child != null && hasFooter && !hasTitle)
            Container(height: config.borderWidth, color: config.dividerColor),
          if (hasFooter) footer,
        ],
      ),
    );
  }

  /// 下方标题 + 描述区域
  ///
  /// 标题行参照分割线样式:标题居左,右侧延伸一条分割线
  Widget? _buildFooter(SantoSectionConfig config) {
    Widget? titleWidget = this.titleWidget ?? (title == null ? null : Text(title!));
    titleWidget = titleWidget == null
        ? null
        : DefaultTextStyle(
            style: config.titleTextStyle.generateTextStyle(),
            child: titleWidget,
          );

    Widget? descriptionWidget =
        this.descriptionWidget ?? (description == null ? null : Text(description!));
    descriptionWidget = descriptionWidget == null
        ? null
        : DefaultTextStyle(
            style: config.descriptionTextStyle.generateTextStyle(),
            child: descriptionWidget,
          );

    if (titleWidget == null && descriptionWidget == null) return null;

    final EdgeInsets padding = footerPadding ?? config.footerPadding;
    final bool hasTitle = titleWidget != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 标题两侧延伸分割线:左侧约 5% 贴着卡片边框,右侧撑满到卡片边缘
        if (hasTitle)
          Padding(
            padding: EdgeInsets.only(top: padding.top),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: constraints.maxWidth * 0.05,
                      child: Container(
                        height: config.borderWidth,
                        color: config.dividerColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ?titleWidget,
                    if (titleSuffix != null) ...[
                      const SizedBox(width: 6),
                      titleSuffix!,
                    ],
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: config.borderWidth,
                        color: config.dividerColor,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        if (descriptionWidget != null)
          Padding(
            padding: EdgeInsets.fromLTRB(
              padding.left,
              hasTitle ? 8 : padding.top,
              padding.right,
              padding.bottom,
            ),
            child: descriptionWidget,
          ),
      ],
    );
  }
}
