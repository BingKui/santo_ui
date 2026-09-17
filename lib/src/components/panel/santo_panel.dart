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
///   description: '面板描述信息',
///   actions: [SantoSmallOutlineButton(title: '更多', onTap: () {})],
///   child: Text('面板内容'),
/// )
/// ```
class SantoPanel extends StatelessWidget {
  /// Header 左侧标题文案,优先级低于 [titleWidget]
  final String? title;

  /// Header 左侧自定义标题控件,设置后 [title] 失效
  final Widget? titleWidget;

  /// Header 标题后方的自定义控件(如 Segmented),位于标题与右侧 [actions] 之间;
  /// 会优先保证其完整展示,标题空间不足时由标题收缩让位
  final Widget? titleExtra;

  /// 标题下方的描述信息,字号较小、灰色
  final String? description;

  /// Header 右侧操作区控件列表
  final List<Widget>? actions;

  /// 内容区控件
  final Widget? child;

  /// 内容区是否显示内边距,默认 true;为 false 时内容紧贴面板边缘
  final bool contentPadding;

  /// 内容区最大高度,默认 null 自适应内容;设置后超出可滚动
  final double? maxHeight;

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
    this.titleExtra,
    this.description,
    this.actions,
    required this.child,
    this.contentPadding = true,
    this.maxHeight,
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

    final double panelRadius = radius ?? config.radius;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? config.backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(panelRadius)),
        border: Border.all(
          color: config.borderColor,
          width: config.borderWidth,
        ),
      ),
      // 内容按内圈圆角裁切(比外框少一个描边宽度),
      // 否则 contentPadding:false 的整块内容会盖住四角描边
      child: ClipRRect(
        borderRadius: BorderRadius.all(
            Radius.circular(panelRadius - config.borderWidth)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(config),
            _buildContent(config),
          ],
        ),
      ),
    );
  }

  /// Header:左侧标题(含可选描述) + 右侧操作区,底部带分割线
  Widget _buildHeader(SantoPanelConfig config) {
    Widget? headerTitle = titleWidget;
    headerTitle ??= title == null
        ? null
        : DefaultTextStyle(
            style: config.titleTextStyle.generateTextStyle(),
            child: Text(title!),
          );

    if (headerTitle == null &&
        titleExtra == null &&
        (actions == null || actions!.isEmpty)) {
      return const SizedBox.shrink();
    }

    final hasDescription = description != null && description!.isNotEmpty;

    Widget? leftWidget = headerTitle;
    if (hasDescription) {
      leftWidget = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerTitle!,
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: DefaultTextStyle(
              style: config.descriptionTextStyle.generateTextStyle(),
              child: Text(description!),
            ),
          ),
        ],
      );
    }

    return Container(
      constraints: BoxConstraints(minHeight: config.headerHeight),
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: hasDescription ? 10 : 0,
      ),
      alignment: hasDescription ? null : Alignment.centerLeft,
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
          if (titleExtra == null)
            Expanded(child: leftWidget ?? const SizedBox.shrink())
          else
            // 标题与后置控件同处左侧区域:标题按内容宽度收缩,后置控件优先保留完整宽度
            Expanded(
              child: Row(
                children: [
                  Flexible(child: leftWidget ?? const SizedBox.shrink()),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: titleExtra!,
                  ),
                ],
              ),
            ),
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
      content = _PanelScrollContent(
        maxHeight: maxHeight!,
        child: content,
      );
    }
    return content;
  }
}

/// 面板可滚动内容:独立 ScrollController,供 Scrollbar thumbVisibility 使用
class _PanelScrollContent extends StatefulWidget {
  final double maxHeight;
  final Widget child;

  const _PanelScrollContent({
    required this.maxHeight,
    required this.child,
  });

  @override
  State<_PanelScrollContent> createState() => _PanelScrollContentState();
}

class _PanelScrollContentState extends State<_PanelScrollContent> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: widget.maxHeight),
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: widget.child,
        ),
      ),
    );
  }
}
