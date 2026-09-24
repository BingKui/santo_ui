import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:santo_ui/src/theme/configs/santo_common_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';

/// 浮层面板
///
/// 贴底停靠的可拖拽面板:拖动把手/标头或内容区域改变高度,松手后吸附到最近的锚点。
/// 对标 Vant FloatingPanel。
///
/// 使用方式:作为 [Stack] 的整屏子节点(或 `Positioned.fill`),面板占满父级、
/// 自身贴底渲染,只有面板区域参与手势,其余区域的事件照常落到下层页面。
///
/// 面板背景铺到屏幕底部(包含底部安全区域);内容区底部固定预留底部安全区,
/// 最后一段内容展示在安全区之上,内容显式传入 `padding` 时同样生效
///
/// 示例:
/// ```dart
/// Stack(
///   children: [
///     ListView(children: [...]),
///     SantoFloatingPanel(
///       anchors: const [100, 320],
///       header: const Text('标题'),
///       child: ListView(children: [...]),
///     ),
///   ],
/// )
/// ```
class SantoFloatingPanel extends StatefulWidget {
  /// 面板区域 Key,供外部(含 widget 测试)定位面板实际尺寸
  static const Key panelKey = ValueKey<String>('santo_floating_panel');

  /// 面板内容
  ///
  /// 内容高于面板时请传入可滚动组件(如 ListView),面板自身不做滚动兜底
  final Widget child;

  /// 面板标头,展示在把手条下方,与把手条同属拖拽区域
  final Widget? header;

  /// 受控高度(px,不含底部安全区);不传则由内部维护
  final double? height;

  /// 锚点高度(px),内部按升序整理;首个锚点为初始高度,首尾锚点为拖拽上下边界
  ///
  /// 不传时默认 `[100, 可用高度 * 0.6]`
  final List<double>? anchors;

  /// 高度变化动画时长,传 [Duration.zero] 表示不做动画
  final Duration duration;

  /// 是否吸附:true 松手后吸附到最近的锚点,false 停在任意高度
  final bool magnetic;

  /// 是否允许拖拽(拖动把手/标头改变高度),false 时不渲染把手条
  final bool draggable;

  /// 是否允许拖拽内容区域改变高度
  ///
  /// 内容为可滚动组件时,内容滚动到顶部/底部后继续拖拽才会接管为高度变化
  final bool contentDraggable;

  /// 拖动结束后的高度回调,回调值为吸附后的最终高度
  final ValueChanged<double>? onHeightChange;

  /// 面板背景色,默认使用主题 fillBase
  final Color? backgroundColor;

  /// 面板顶部圆角,默认使用主题 radiusLg(12)
  final double? radius;

  const SantoFloatingPanel({
    Key? key,
    required this.child,
    this.header,
    this.height,
    this.anchors,
    this.duration = const Duration(milliseconds: 300),
    this.magnetic = true,
    this.draggable = true,
    this.contentDraggable = true,
    this.onHeightChange,
    this.backgroundColor,
    this.radius,
  }) : assert(anchors == null || anchors.length > 0, 'anchors 不能为空数组'),
       super(key: key);

  @override
  State<SantoFloatingPanel> createState() => _SantoFloatingPanelState();
}

class _SantoFloatingPanelState extends State<SantoFloatingPanel>
    with SingleTickerProviderStateMixin {
  /// 把手条区域高度
  static const double _dragBarHeight = 28;

  late final AnimationController _controller;
  Animation<double>? _heightAnimation;

  /// 内部维护的当前高度(px,不含底部安全区)
  double? _height;

  /// 把手/标头拖拽:起点高度与累计位移(向下为正)
  double _gestureStartHeight = 0;
  double _gestureDelta = 0;

  /// 本次拖拽是否真正改变过高度,未改变则结束后不触发回调
  bool _heightChanged = false;

  /// 内容滚动到边界后继续拖拽:是否接管、起点高度与累计溢出量
  bool _overscrollDragging = false;
  double _overscrollStartHeight = 0;
  double _overscrollDelta = 0;

  SantoCommonConfig get _commonConfig =>
      SantoThemeConfigurator.instance.getConfig().commonConfig;

  @override
  void initState() {
    super.initState();
    _height = widget.height;
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..addListener(_onAnimationTick);
  }

  @override
  void didUpdateWidget(covariant SantoFloatingPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
    // 受控高度:外部传入新高度时跟随动画
    if (widget.height != null &&
        widget.height != oldWidget.height &&
        widget.height != _height) {
      _animateTo(widget.height!);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onAnimationTick() {
    final animation = _heightAnimation;
    if (animation == null) return;
    setState(() => _height = animation.value);
  }

  /// 锚点解析:限制在可用高度内并升序排列
  List<double> _resolveAnchors(double availableHeight) {
    final double fallbackHeight = availableHeight * 0.6;
    final List<double> raw = widget.anchors ?? <double>[100, fallbackHeight];
    final anchors =
        raw.map((e) => e.clamp(0.0, availableHeight).toDouble()).toList()
          ..sort();
    return anchors.isEmpty ? <double>[fallbackHeight] : anchors;
  }

  /// 拖动结束:吸附到最近锚点(开启磁力吸附时)并回调最终高度
  void _settle(List<double> anchors) {
    _overscrollDragging = false;
    final current = _height;
    if (current == null || !_heightChanged) return;
    _heightChanged = false;
    final target = widget.magnetic ? _nearestAnchor(current, anchors) : current;
    _animateTo(target);
    widget.onHeightChange?.call(target);
  }

  double _nearestAnchor(double value, List<double> anchors) {
    double nearest = anchors.first;
    for (final anchor in anchors) {
      if ((anchor - value).abs() < (nearest - value).abs()) {
        nearest = anchor;
      }
    }
    return nearest;
  }

  void _animateTo(double target) {
    _controller.stop();
    final from = _height ?? target;
    if (from == target || widget.duration == Duration.zero) {
      if (_height != target) setState(() => _height = target);
      return;
    }
    _heightAnimation = Tween<double>(
      begin: from,
      end: target,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller
      ..reset()
      ..forward();
  }

  void _startGestureDrag(double currentHeight) {
    _controller.stop();
    _overscrollDragging = false;
    _heightChanged = false;
    _gestureStartHeight = currentHeight;
    _gestureDelta = 0;
  }

  void _updateGestureDrag(double deltaY, double minHeight, double maxHeight) {
    _gestureDelta += deltaY;
    final target = (_gestureStartHeight - _gestureDelta)
        .clamp(minHeight, maxHeight)
        .toDouble();
    if (target != _height) {
      _heightChanged = true;
      setState(() => _height = target);
    }
  }

  /// 内容区滚动到边界后继续拖拽:边界溢出量转为高度变化
  ///
  /// 顶部继续下拉(overscroll 为负)面板收小,底部继续上拉(overscroll 为正)面板变高
  bool _handleScrollNotification(
    ScrollNotification notification,
    List<double> anchors,
    double minHeight,
    double maxHeight,
    double currentHeight,
  ) {
    if (!widget.contentDraggable) return false;
    if (notification is OverscrollNotification &&
        notification.dragDetails != null) {
      if (!_overscrollDragging) {
        _controller.stop();
        _overscrollDragging = true;
        _overscrollStartHeight = currentHeight;
        _overscrollDelta = 0;
      }
      _overscrollDelta += notification.overscroll;
      final target = (_overscrollStartHeight + _overscrollDelta)
          .clamp(minHeight, maxHeight)
          .toDouble();
      if (target != _height) {
        _heightChanged = true;
        setState(() => _height = target);
      }
      return false;
    }
    if (notification is ScrollEndNotification && _overscrollDragging) {
      _settle(anchors);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final config = _commonConfig;
    final double panelRadius = widget.radius ?? config.radiusLg;
    // 底部安全区:固定预留,不可配置
    final double safeAreaBottom = MediaQuery.of(context).padding.bottom;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableHeight = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : MediaQuery.of(context).size.height;
        final anchors = _resolveAnchors(availableHeight);
        final minHeight = anchors.first;
        final maxHeight = anchors.last;
        final currentHeight = (_height ?? widget.height ?? minHeight)
            .clamp(minHeight, maxHeight)
            .toDouble();

        return Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            key: SantoFloatingPanel.panelKey,
            height: currentHeight,
            // 面板本体:外层只画顶部阴影,内层用 Material 承载背景色与圆角,
            // 这样面板内的 ListTile 等控件能拿到 Material ancestor
            // 面板背景包含底部安全区域,内容区在其上方避让
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(panelRadius),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: config.shadowColor,
                    blurRadius: 12,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Material(
                color: widget.backgroundColor ?? config.fillBase,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(panelRadius),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ?_buildDragArea(
                        anchors, minHeight, maxHeight, currentHeight),
                    Expanded(
                      child: _buildContentArea(
                        anchors,
                        minHeight,
                        maxHeight,
                        currentHeight,
                        safeAreaBottom,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 拖拽区:把手条 + 标头,draggable 为 false 且无标头时不渲染
  Widget? _buildDragArea(
    List<double> anchors,
    double minHeight,
    double maxHeight,
    double currentHeight,
  ) {
    if (!widget.draggable && widget.header == null) return null;

    Widget area = Column(
      mainAxisSize: MainAxisSize.min,
      children: [if (widget.draggable) _buildDragBar(), ?widget.header],
    );

    if (!widget.draggable) return area;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      dragStartBehavior: DragStartBehavior.down,
      onVerticalDragStart: (_) => _startGestureDrag(currentHeight),
      onVerticalDragUpdate: (details) =>
          _updateGestureDrag(details.delta.dy, minHeight, maxHeight),
      onVerticalDragEnd: (_) => _settle(anchors),
      child: area,
    );
  }

  /// 顶部把手条:居中短横条
  Widget _buildDragBar() {
    return SizedBox(
      height: _dragBarHeight,
      child: Center(
        child: Container(
          width: 20,
          height: 3,
          decoration: BoxDecoration(
            color: _commonConfig.borderColorBase,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildContentArea(
    List<double> anchors,
    double minHeight,
    double maxHeight,
    double currentHeight,
    double safeAreaBottom,
  ) {
    // 内容区撑满面板(内容一直展示到面板底部);
    // 面板内只保留底部安全区:把内容的 MediaQuery padding 置为"仅底部安全区",
    // 由内容自身的滚动避让——滚到底时最后一段内容展示在安全区之上
    Widget content = widget.child;
    if (safeAreaBottom > 0) {
      content = MediaQuery(
        data: MediaQuery.of(context).copyWith(
          padding: EdgeInsets.only(bottom: safeAreaBottom),
        ),
        child: content,
      );
    }

    if (widget.contentDraggable) {
      // 内容自身可滚动时,内层滚动手势优先,由边界溢出接管高度变化
      content = GestureDetector(
        behavior: HitTestBehavior.opaque,
        dragStartBehavior: DragStartBehavior.down,
        onVerticalDragStart: (_) => _startGestureDrag(currentHeight),
        onVerticalDragUpdate: (details) =>
            _updateGestureDrag(details.delta.dy, minHeight, maxHeight),
        onVerticalDragEnd: (_) => _settle(anchors),
        child: content,
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) => _handleScrollNotification(
        notification,
        anchors,
        minHeight,
        maxHeight,
        currentHeight,
      ),
      child: content,
    );
  }
}
