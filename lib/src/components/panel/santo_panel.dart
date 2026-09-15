import 'package:santo_ui/src/theme/santo_theme.dart';
import 'package:flutter/material.dart';

/// 面板组件:圆角容器 + Header(标题/操作区) + Content(内容区)
///
/// 内容区默认自适应高度;设置 [maxHeight] 后内容可滚动并显示滚动条。
///
/// 示例:
/// ```dart
/// SantoPanel(
///   title: '面板标题',
///   actions: [SantoNormalButton.outline(text: '更多', onTap: () {})],
///   child: Text('面板内容'),
/// )
/// ```
class SantoPanel extends StatelessWidget {
  /// Header 左侧标题文案,优先级低于 [titleWidget]
  final String? title;

  /// Header 左侧自定义标题控件,设置后 [title] 失效
  final Widget? titleWidget;

  /// Header 右侧操作区控件列表
  final List<Widget>? actions;

  /// 内容区控件
  final Widget? child;

  /// 内容区是否显示内边距,默认 true;为 false 时内容紧贴面板边缘
  final bool contentPadding;

  /// 内容区最大高度,默认 null 自适应内容;设置后超出可滚动
  final double? maxHeight;

  /// 面板外边距,默认使用主题配置
  final EdgeInsets? margin;

  /// 面板背景色,默认使用主题配置
  final Color? backgroundColor;

  /// 面板圆角,默认 12
  final double? radius;

  /// 面板主题配置
  final SantoPanelConfig? themeData;

  SantoPanel({
    Key? key,
    this.title,
    this.titleWidget,
    this.actions,
    required this.child,
    this.contentPadding = true,
    this.maxHeight,
    this.margin,
    this.backgroundColor,
    this.radius,
    this.themeData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SantoPanelConfig config = themeData ?? SantoPanelConfig();
    config = SantoThemeConfigurator.instance
        .getConfig(configId: config.configId)
        .panelConfig
        .merge(config);

    return Container(
      margin: margin ?? config.margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? config.backgroundColor,
        borderRadius: BorderRadius.all(
            Radius.circular(radius ?? config.radius)),
        border: Border.all(
          color: config.borderColor,
          width: config.borderWidth,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(config),
          _buildContent(config),
        ],
      ),
    );
  }

  /// Header:左侧标题 + 右侧操作区,底部带分割线
  Widget _buildHeader(SantoPanelConfig config) {
    Widget? titleWidget = this.titleWidget;
    titleWidget ??= title == null
        ? null
        : DefaultTextStyle(
            style: config.titleTextStyle.generateTextStyle(),
            child: Text(title!),
          );

    if (titleWidget == null && (actions == null || actions!.isEmpty)) {
      return const SizedBox.shrink();
    }

    return Container(
      height: config.headerHeight,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: config.showHeaderDivider
            ? Border(
                bottom: BorderSide(
                  color: config.borderColor,
                  width: config.borderWidth,
                ),
              )
            : null,
      ),
      child: Row(
        children: [
          Expanded(child: titleWidget ?? const SizedBox.shrink()),
          if (actions != null && actions!.isNotEmpty)
            Row(mainAxisSize: MainAxisSize.min, children: actions!),
        ],
      ),
    );
  }

  /// Content:支持关闭内边距;设置 maxHeight 后可滚动并显示滚动条
  Widget _buildContent(SantoPanelConfig config) {
    Widget content = child ?? const SizedBox.shrink();
    if (contentPadding) {
      content = Padding(padding: config.contentPadding, child: content);
    }

    if (maxHeight != null) {
      content = ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight!),
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(child: content),
        ),
      );
    }
    return content;
  }
}
