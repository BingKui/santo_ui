import 'package:flutter/material.dart';

/// 滑动方向:打开哪一侧的操作面板
enum SantoSwipeDirection {
  /// 左侧操作面板(内容右滑展开)
  left,

  /// 右侧操作面板(内容左滑展开)
  right,
}

/// 滑动单元格操作按钮
class SantoSwipeCellAction {
  /// 按钮文案
  final String label;

  /// 点击回调
  final VoidCallback? onPressed;

  /// 按钮背景色,默认主题灰
  final Color? backgroundColor;

  /// 文字颜色,默认白色
  final Color? textColor;

  /// 自定义按钮内容,设置后 [label] 失效
  final Widget? child;

  /// 单个按钮宽度
  final double width;

  const SantoSwipeCellAction({
    required this.label,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.child,
    this.width = 72,
  });
}

/// 操作面板
///
/// [extentRatio] 为操作区总宽占单元格宽度的比例,默认 0.25。
class SantoSwipeCellPanel {
  /// 操作按钮列表
  final List<SantoSwipeCellAction> actions;

  /// 操作区总宽占单元格宽度的比例
  final double extentRatio;

  const SantoSwipeCellPanel({
    required this.actions,
    this.extentRatio = 0.25,
  }) : assert(extentRatio > 0 && extentRatio <= 1,
            'extentRatio 需在 (0, 1] 范围内');
}

/// 滑动单元格组件(API 参考 TDesign Flutter 的 SwipeCell)
///
/// 列表项左滑/右滑出操作面板,支持:
/// * 左/右操作面板 [left] / [right]
/// * 禁用滑动 [disabled]
/// * 默认展开 [opened]
/// * 组内互斥 [groupTag]:同一组中一个打开时自动关闭其他,点击内容关闭全组
/// * 展开状态回调 [onChange]
///
/// 使用示例:
/// ```dart
/// SantoSwipeCell(
///   groupTag: 'demo',
///   right: SantoSwipeCellPanel(
///     actions: [
///       SantoSwipeCellAction(
///         label: '删除',
///         backgroundColor: Colors.red,
///         onPressed: () {},
///       ),
///     ],
///   ),
///   cell: ListTile(title: Text('列表项')),
/// )
/// ```
class SantoSwipeCell extends StatefulWidget {
  /// 单元格内容
  final Widget cell;

  /// 左侧操作面板
  final SantoSwipeCellPanel? left;

  /// 右侧操作面板
  final SantoSwipeCellPanel? right;

  /// 是否禁用滑动,默认 false
  final bool disabled;

  /// 默认展开状态,[左侧, 右侧],默认均收起
  final List<bool> opened;

  /// 展开/收起状态变化回调
  final void Function(SantoSwipeDirection direction, bool open)? onChange;

  /// 组标签:配置后同组单元格互斥展开,点击时关闭全组
  final Object? groupTag;

  /// 点击内容时是否关闭全组已打开的单元格,默认 true
  final bool closeWhenTapped;

  /// 打开/收起动画时长,默认 200ms
  final Duration duration;

  /// 控制器,用于外部关闭当前单元格
  final SantoSwipeCellController? controller;

  const SantoSwipeCell({
    Key? key,
    required this.cell,
    this.left,
    this.right,
    this.disabled = false,
    this.opened = const [false, false],
    this.onChange,
    this.groupTag,
    this.closeWhenTapped = true,
    this.duration = const Duration(milliseconds: 200),
    this.controller,
  })  : assert(left != null || right != null,
            '至少需要提供左侧或右侧操作面板'),
        super(key: key);

  @override
  State<SantoSwipeCell> createState() => _SantoSwipeCellState();
}

class _SantoSwipeCellState extends State<SantoSwipeCell>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Animation<double> _offset = const AlwaysStoppedAnimation(0);
  double _dragOffset = 0.0;
  SantoSwipeDirection? _openDirection;

  /// 组注册表:groupTag -> 同组状态集合
  static final Map<Object, Set<_SantoSwipeCellState>> _groups = {};

  double get _leftExtent =>
      widget.left != null ? widget.left!.extentRatio * _cellWidth : 0.0;

  double get _rightExtent =>
      widget.right != null ? widget.right!.extentRatio * _cellWidth : 0.0;

  double _cellWidth = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _offset = Tween<double>(begin: 0, end: 0).animate(_controller)
      ..addListener(() {
        setState(() => _dragOffset = _offset.value);
      });
    widget.controller?._attach(this);

    final group = widget.groupTag;
    if (group != null) {
      _groups.putIfAbsent(group, () => {}).add(this);
    }

    if (widget.opened.first && widget.left != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _openLeft());
    } else if (widget.opened.last && widget.right != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _openRight());
    }
  }

  @override
  void didUpdateWidget(covariant SantoSwipeCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
  }

  @override
  void dispose() {
    widget.controller?._detach(this);
    final group = widget.groupTag;
    if (group != null) {
      _groups[group]?.remove(this);
      if (_groups[group]?.isEmpty ?? false) _groups.remove(group);
    }
    _controller.dispose();
    super.dispose();
  }

  void _animateTo(double target) {
    _offset = Tween<double>(begin: _dragOffset, end: target)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward(from: 0);
  }

  void _close({bool notify = true}) {
    if (_openDirection == null && _dragOffset == 0) return;
    _animateTo(0);
    if (notify && _openDirection != null) {
      widget.onChange?.call(_openDirection!, false);
    }
    _openDirection = null;
  }

  void _openLeft() {
    if (_leftExtent <= 0) return;
    _closeGroup();
    _animateTo(_leftExtent);
    _openDirection = SantoSwipeDirection.left;
    widget.onChange?.call(SantoSwipeDirection.left, true);
  }

  void _openRight() {
    if (_rightExtent <= 0) return;
    _closeGroup();
    _animateTo(-_rightExtent);
    _openDirection = SantoSwipeDirection.right;
    widget.onChange?.call(SantoSwipeDirection.right, true);
  }

  /// 关闭同组其他已展开的单元格
  void _closeGroup() {
    final group = widget.groupTag;
    if (group == null) return;
    for (final state in (_groups[group] ?? const {})) {
      if (state != this) state._close(notify: false);
    }
  }

  void _onDragStart(DragStartDetails details) {
    _controller.stop();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    final delta = details.primaryDelta ?? 0;
    setState(() {
      _dragOffset += delta;
      // 越界阻尼
      if (_dragOffset > _leftExtent) {
        _dragOffset = _leftExtent + (_dragOffset - _leftExtent) * 0.3;
      } else if (_dragOffset < -_rightExtent) {
        _dragOffset = -_rightExtent + (_dragOffset + _rightExtent) * 0.3;
      }
    });
  }

  void _onDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    final offset = _dragOffset;

    if (velocity > 500 && _leftExtent > 0) {
      _openLeft();
    } else if (velocity < -500 && _rightExtent > 0) {
      _openRight();
    } else if (offset > _leftExtent / 2) {
      _openLeft();
    } else if (offset < -_rightExtent / 2) {
      _openRight();
    } else if (_openDirection != null) {
      _close();
    } else {
      _animateTo(0);
    }
  }

  Widget _buildAction(
      SantoSwipeCellAction action, SantoSwipeDirection direction) {
    return SizedBox(
      width: action.width,
      child: Material(
        color: action.backgroundColor ?? const Color(0xFFCCCCCC),
        child: InkWell(
          onTap: () {
            action.onPressed?.call();
          },
          child: Center(
            child: action.child ??
                Text(
                  action.label,
                  style: TextStyle(
                      color: action.textColor ?? Colors.white, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      _cellWidth = constraints.maxWidth;
      final leftPanel = widget.left;
      final rightPanel = widget.right;

      final leftActions = leftPanel == null
          ? null
          : Row(
              children: leftPanel.actions
                  .map((a) => _buildAction(a, SantoSwipeDirection.left))
                  .toList(),
            );

      final rightActions = rightPanel == null
          ? null
          : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: rightPanel.actions
                  .map((a) => _buildAction(a, SantoSwipeDirection.right))
                  .toList(),
            );

      return GestureDetector(
        onHorizontalDragStart: widget.disabled ? null : _onDragStart,
        onHorizontalDragUpdate: widget.disabled ? null : _onDragUpdate,
        onHorizontalDragEnd: widget.disabled ? null : _onDragEnd,
        child: ClipRect(
          child: Stack(
            children: [
              // 操作面板背景
              Positioned.fill(
                child: Stack(
                  children: [
                    if (leftActions != null)
                      Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        child: leftActions,
                      ),
                    if (rightActions != null)
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: rightActions,
                      ),
                  ],
                ),
              ),
              // 前景内容
              Transform.translate(
                offset: Offset(_dragOffset, 0),
                child: GestureDetector(
                  onTap: () {
                    if (_openDirection != null) {
                      _close();
                    } else if (widget.closeWhenTapped && widget.groupTag != null) {
                      _closeGroup();
                    }
                  },
                  child: widget.cell,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

/// 滑动单元格控制器,用于外部关闭当前单元格
class SantoSwipeCellController {
  final Set<_SantoSwipeCellState> _states = {};

  void _attach(_SantoSwipeCellState state) {
    _states.add(state);
  }

  void _detach(_SantoSwipeCellState state) {
    _states.remove(state);
  }

  /// 关闭已打开的单元格
  void close() {
    for (final state in _states) {
      state._close(notify: false);
    }
  }
}
