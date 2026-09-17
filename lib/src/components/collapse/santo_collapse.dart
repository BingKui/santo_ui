import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 折叠面板展开模式
enum SantoCollapseMode {
  /// 多个面板可同时展开
  multiple,

  /// 最多展开一个面板
  accordion,
}

/// 折叠面板视觉形态
enum SantoCollapseVariant {
  /// 通栏形态
  block,

  /// 卡片形态
  card,
}

/// 折叠内容相对标题的展开方向
enum SantoCollapsePlacement {
  /// 内容在标题下方展开
  bottom,

  /// 内容在标题上方展开
  top,
}

/// 根据折叠状态构建面板区域内容的回调
typedef SantoCollapsePanelBuilder = Widget Function(
    BuildContext context, bool isExpanded);

Widget _defaultExpandIconBuilder(BuildContext context, bool isExpanded) {
  return Icon(isExpanded ? Icons.expand_less : Icons.expand_more);
}

/// 折叠面板列表组件，需配合 [SantoCollapsePanel] 使用
///
/// API 参考 TDesign Flutter TCollapse
///
/// 使用示例：
/// ```dart
/// SantoCollapse<String>(
///   value: _value,
///   onChanged: (value) => setState(() => _value = value),
///   children: [
///     SantoCollapsePanel(
///       value: 'panel-1',
///       headerBuilder: (context, isExpanded) => Text('面板1'),
///       body: Text('内容1'),
///     ),
///   ],
/// )
/// ```
class SantoCollapse<T extends Object> extends StatefulWidget {
  /// 折叠面板列表的子组件
  final List<SantoCollapsePanel<T>> children;

  /// 折叠面板模式，默认 [SantoCollapseMode.multiple]
  final SantoCollapseMode mode;

  /// 折叠面板视觉形态，默认 [SantoCollapseVariant.block]
  final SantoCollapseVariant? variant;

  /// 折叠面板列表的动画时长
  final Duration? animationDuration;

  /// 折叠面板列表的阴影
  final double? elevation;

  /// 当前展开面板的值列表，是所有模式唯一的展开状态源
  ///
  /// 列表中的值必须唯一，并与唯一的 [SantoCollapsePanel.value] 匹配
  /// [SantoCollapseMode.accordion] 模式最多允许一个值
  final List<T> value;

  /// 展开值列表变更回调
  ///
  /// 回调返回点击后的完整列表。为 null 时整组不可交互并使用禁用视觉；
  /// 单项仍可通过 [SantoCollapsePanel.disabled] 禁用
  final ValueChanged<List<T>>? onChanged;

  const SantoCollapse({
    Key? key,
    required this.children,
    required this.value,
    this.mode = SantoCollapseMode.multiple,
    this.variant,
    this.animationDuration,
    this.elevation,
    this.onChanged,
  }) : super(key: key);

  @override
  State<SantoCollapse<T>> createState() => _SantoCollapseState<T>();
}

class _SantoCollapseState<T extends Object> extends State<SantoCollapse<T>> {
  bool get _isAccordion => widget.mode == SantoCollapseMode.accordion;

  bool _isCardStyle() =>
      (widget.variant ?? SantoCollapseVariant.block) ==
      SantoCollapseVariant.card;

  @override
  void initState() {
    super.initState();
    _debugAssertValidContract();
  }

  @override
  void didUpdateWidget(SantoCollapse<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _debugAssertValidContract();
  }

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final animationDuration =
        widget.animationDuration ?? kThemeAnimationDuration;
    final elevation = widget.elevation ?? 0;
    final cardBorderRadius = BorderRadius.circular(commonConfig.radiusXs);
    final panels = <Widget>[];

    for (var index = 0; index < widget.children.length; index += 1) {
      final isLastChild = index == widget.children.length - 1;
      final child = widget.children[index];
      final isExpanded = widget.value.contains(child.value);
      final isDisabled = widget.onChanged == null || child.disabled;
      final borderRadius = _isCardStyle()
          ? _createRadius(index, cardBorderRadius)
          : BorderRadius.zero;
      final bgColor = child.backgroundColor ?? commonConfig.fillBase;

      panels.add(
        Material(
          key: child.key ?? ValueKey<T>(child.value),
          color: bgColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (child.placement == SantoCollapsePlacement.top)
                _buildBody(context, child, isExpanded, animationDuration),
              _buildHeader(context, child, isExpanded, !isDisabled,
                  animationDuration, borderRadius),
              if (child.placement == SantoCollapsePlacement.bottom)
                _buildBody(context, child, isExpanded, animationDuration),
              if (!isLastChild)
                Container(
                  margin: EdgeInsets.only(left: commonConfig.hSpacingMd),
                  height: 0.5,
                  color: commonConfig.dividerColorBase,
                ),
            ],
          ),
        ),
      );
    }

    Widget collapse = Material(
      elevation: elevation,
      color: commonConfig.fillBase,
      borderRadius: _isCardStyle() ? cardBorderRadius : null,
      clipBehavior: _isCardStyle() ? Clip.antiAlias : Clip.none,
      child: Column(mainAxisSize: MainAxisSize.min, children: panels),
    );

    if (_isCardStyle()) {
      collapse = Padding(
        padding: EdgeInsets.symmetric(horizontal: commonConfig.hSpacingMd),
        child: collapse,
      );
    }

    return collapse;
  }

  BorderRadius _createRadius(int index, BorderRadius radius) {
    final isFirst = index == 0;
    final isLast = index == widget.children.length - 1;
    if (isFirst && isLast) {
      return radius;
    }
    if (isFirst) {
      return BorderRadius.only(
        topLeft: radius.topLeft,
        topRight: radius.topRight,
      );
    }
    if (isLast) {
      return BorderRadius.only(
        bottomLeft: radius.bottomLeft,
        bottomRight: radius.bottomRight,
      );
    }
    return BorderRadius.zero;
  }

  void _handlePressed(SantoCollapsePanel<T> child, bool isExpanded) {
    final nextValue = isExpanded
        ? widget.value.where((value) => value != child.value).toList()
        : _isAccordion
            ? <T>[child.value]
            : <T>[...widget.value, child.value];
    widget.onChanged?.call(List<T>.unmodifiable(nextValue));
  }

  Widget _buildHeader(
    BuildContext context,
    SantoCollapsePanel<T> child,
    bool isExpanded,
    bool isInteractive,
    Duration animationDuration,
    BorderRadius borderRadius,
  ) {
    final titleWidget = _buildTitleWidget(context, child, isExpanded);
    final trailingWidget = _buildTrailingWidget(context, child, isExpanded);
    final expandIconWidget = _buildExpandIconWidget(
        context, child, isExpanded,
        hasTrailing: trailingWidget != null);
    final onTap = isInteractive
        ? () => _handlePressed(child, isExpanded)
        : null;

    return MergeSemantics(
      child: Semantics(
        label: child.semanticsLabel,
        button: true,
        enabled: isInteractive,
        expanded: isExpanded,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: Row(
            children: [
              Expanded(
                child: AnimatedContainer(
                  duration: animationDuration,
                  curve: Curves.fastOutSlowIn,
                  constraints:
                      const BoxConstraints(minHeight: kMinInteractiveDimension),
                  child: titleWidget,
                ),
              ),
              ?trailingWidget,
              ?expandIconWidget,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    SantoCollapsePanel<T> child,
    bool isExpanded,
    Duration animationDuration,
  ) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    Widget content = DefaultTextStyle(
      style: TextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeBase,
        height: 1.5,
        fontWeight: FontWeight.w400,
      ),
      child: Padding(
        padding: EdgeInsets.all(commonConfig.hSpacingMd),
        child: child.body,
      ),
    );
    if (child.bodyHeight != null) {
      content = SizedBox(height: child.bodyHeight, child: content);
    }
    final divider = Container(
      margin: EdgeInsets.only(left: commonConfig.hSpacingMd),
      height: 0.5,
      color: commonConfig.dividerColorBase,
    );
    return _CollapseBody(
      isExpanded: isExpanded,
      duration: animationDuration,
      placement: child.placement,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: child.placement == SantoCollapsePlacement.top
            ? [content, divider]
            : [divider, content],
      ),
    );
  }

  Widget _buildTitleWidget(
      BuildContext context, SantoCollapsePanel<T> child, bool isExpanded) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final iconColor =
        child.disabled ? commonConfig.colorTextDisabled : commonConfig.colorTextHint;
    return ListTile(
      leading: child.leadingBuilder == null
          ? null
          : IconTheme(
              data: IconThemeData(color: iconColor),
              child: child.leadingBuilder!(context, isExpanded),
            ),
      title: DefaultTextStyle(
        style: TextStyle(
          color: child.disabled
              ? commonConfig.colorTextDisabled
              : commonConfig.colorTextBase,
          fontSize: commonConfig.fontSizeSubHead,
          height: 1.5,
          fontWeight: FontWeight.w400,
        ),
        child: child.headerBuilder(context, isExpanded),
      ),
    );
  }

  Widget? _buildTrailingWidget(
      BuildContext context, SantoCollapsePanel<T> child, bool isExpanded) {
    final builder = child.trailingBuilder;
    if (builder == null) {
      return null;
    }
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final color =
        child.disabled ? commonConfig.colorTextDisabled : commonConfig.colorTextHint;
    return DefaultTextStyle(
      style: TextStyle(
        color: color,
        fontSize: commonConfig.fontSizeBase,
        height: 1.5,
      ),
      child: IconTheme(
        data: IconThemeData(color: color),
        child: builder(context, isExpanded),
      ),
    );
  }

  Widget? _buildExpandIconWidget(
    BuildContext context,
    SantoCollapsePanel<T> child,
    bool isExpanded, {
    required bool hasTrailing,
  }) {
    final builder = child.expandIconBuilder;
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    if (builder == null) {
      if (!hasTrailing) {
        return null;
      }
      return SizedBox(width: commonConfig.hSpacingMd);
    }
    final iconColor =
        child.disabled ? commonConfig.colorTextDisabled : commonConfig.colorTextHint;
    return Padding(
      padding: EdgeInsets.all(commonConfig.hSpacingMd),
      child: IconTheme(
        data: IconThemeData(color: iconColor, size: 24),
        child: builder(context, isExpanded),
      ),
    );
  }

  void _debugAssertValidContract() {
    assert(
      widget.children.map((child) => child.value).toSet().length ==
          widget.children.length,
      'Every SantoCollapsePanel must have a distinct value.',
    );
    assert(
      widget.value.toSet().length == widget.value.length,
      'SantoCollapse.value must not contain duplicate values.',
    );
    assert(
      widget.value
          .every((value) => widget.children.any((child) => child.value == value)),
      'Every value in SantoCollapse.value must match a SantoCollapsePanel.value.',
    );
    assert(
      !_isAccordion || widget.value.length <= 1,
      'SantoCollapseMode.accordion allows at most one expanded value.',
    );
  }
}

/// 内容区域的折叠动画
///
/// 用 [ClipRect] + [Align] 的 heightFactor 做高度裁剪：内容全程保持不透明，
/// 展开时从标题一侧逐渐显露，收起时逐渐裁掉，不产生交叉淡化
class _CollapseBody extends StatefulWidget {
  const _CollapseBody({
    required this.isExpanded,
    required this.duration,
    required this.placement,
    required this.child,
  });

  final bool isExpanded;
  final Duration duration;
  final SantoCollapsePlacement placement;
  final Widget child;

  @override
  State<_CollapseBody> createState() => _CollapseBodyState();
}

class _CollapseBodyState extends State<_CollapseBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _sizeCurve;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: widget.isExpanded ? 1.0 : 0.0,
    );
    _sizeCurve =
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
  }

  @override
  void didUpdateWidget(_CollapseBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
    if (widget.isExpanded != oldWidget.isExpanded) {
      widget.isExpanded ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  void dispose() {
    _sizeCurve.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final closed = !widget.isExpanded && _controller.isDismissed;
    return Offstage(
      offstage: closed,
      child: TickerMode(
        enabled: !closed,
        child: AnimatedBuilder(
          animation: _controller.view,
          builder: (BuildContext context, Widget? child) {
            return ClipRect(
              child: Align(
                alignment: widget.placement == SantoCollapsePlacement.bottom
                    ? Alignment.topCenter
                    : Alignment.bottomCenter,
                heightFactor: _sizeCurve.value,
                child: child,
              ),
            );
          },
          child: widget.child,
        ),
      ),
    );
  }
}

/// 折叠面板单个面板配置，需配合 [SantoCollapse] 使用
///
/// API 参考 TDesign Flutter TCollapsePanel
class SantoCollapsePanel<T extends Object> {
  /// 面板标识，用于列表插入、删除和重排时保留内容状态
  final Key? key;

  /// 面板唯一标识，用于匹配父级 [SantoCollapse.value] 中的展开值
  final T value;

  /// 折叠面板的头部组件构造函数
  final SantoCollapsePanelBuilder headerBuilder;

  /// 折叠面板的内容组件
  final Widget body;

  /// 展开内容区域的固定高度（包含内容内边距）
  ///
  /// 适用于 [ListView] 等需要有界高度的内容；为空时由内容自然决定高度
  final double? bodyHeight;

  /// 是否禁用面板交互
  final bool disabled;

  /// 内容相对标题的展开方向
  final SantoCollapsePlacement placement;

  /// 面板标题的无障碍标签；复杂自定义标题无法自动提取文本时使用
  final String? semanticsLabel;

  /// 折叠面板的背景色
  final Color? backgroundColor;

  /// 构建标题左侧区域
  final SantoCollapsePanelBuilder? leadingBuilder;

  /// 构建标题右侧、展开图标之前的操作区域
  ///
  /// 可根据 builder 收到的 isExpanded 显示"展开/收起"等文案或任意 Widget
  final SantoCollapsePanelBuilder? trailingBuilder;

  /// 构建展开图标
  ///
  /// 省略时使用默认箭头；显式传入 null 时隐藏箭头；传入 builder
  /// 时以其返回的 Widget 替换默认箭头
  final SantoCollapsePanelBuilder? expandIconBuilder;

  const SantoCollapsePanel({
    this.key,
    required this.value,
    required this.headerBuilder,
    required this.body,
    this.bodyHeight,
    this.disabled = false,
    this.placement = SantoCollapsePlacement.bottom,
    this.semanticsLabel,
    this.backgroundColor,
    this.leadingBuilder,
    this.trailingBuilder,
    this.expandIconBuilder = _defaultExpandIconBuilder,
  }) : assert(
          bodyHeight == null || (bodyHeight > 0 && bodyHeight < double.infinity),
          'bodyHeight must be a finite value greater than zero',
        );
}
