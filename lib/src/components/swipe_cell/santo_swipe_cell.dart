import 'package:flutter/material.dart';

/// 滑动单元格组件
///
/// 列表项左滑/右滑出操作按钮，支持左侧和右侧操作区，支持自动关闭。
///
/// 使用示例：
/// ```dart
/// SantoSwipeCell(
///   rightActions: [
///     Container(width: 80, color: Colors.red, child: Center(child: Text('删除'))),
///   ],
///   child: ListTile(title: Text('列表项')),
/// )
/// ```
class SantoSwipeCell extends StatefulWidget {
  /// 左侧操作按钮列表
  final List<Widget>? leftActions;

  /// 右侧操作按钮列表
  final List<Widget>? rightActions;

  /// 子组件（列表项内容）
  final Widget child;

  /// 打开回调
  final VoidCallback? onOpen;

  /// 关闭回调
  final VoidCallback? onClose;

  /// 关闭其他已打开的滑动单元格（由外部管理）
  final SantoSwipeCellController? controller;

  const SantoSwipeCell({
    Key? key,
    this.leftActions,
    this.rightActions,
    required this.child,
    this.onOpen,
    this.onClose,
    this.controller,
  })  : assert(leftActions != null || rightActions != null,
            '至少需要提供左侧或右侧操作按钮'),
        super(key: key);

  @override
  State<SantoSwipeCell> createState() => _SantoSwipeCellState();
}

class _SantoSwipeCellState extends State<SantoSwipeCell>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  double _dragOffset = 0.0;
  bool _isOpen = false;

  /// 每个操作按钮的默认宽度
  static const double _actionButtonWidth = 80.0;

  double get _leftActionsWidth =>
      widget.leftActions != null
          ? widget.leftActions!.length * _actionButtonWidth
          : 0.0;

  double get _rightActionsWidth =>
      widget.rightActions != null
          ? widget.rightActions!.length * _actionButtonWidth
          : 0.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _animationController.addListener(_handleAnimationTick);

    // 注册控制器回调，用于外部关闭
    widget.controller?._register(this);
  }

  void _handleAnimationTick() {
    setState(() {
      _dragOffset = _animationController.value;
    });
  }

  @override
  void dispose() {
    widget.controller?._unregister(this);
    _animationController.dispose();
    super.dispose();
  }

  void _close() {
    if (!_isOpen && _dragOffset == 0) return;
    _animateTo(0.0);
    _isOpen = false;
    widget.onClose?.call();
  }

  void _openLeft() {
    final width = _leftActionsWidth;
    if (width <= 0) return;
    _animateTo(width);
    _isOpen = true;
    widget.onOpen?.call();
  }

  void _openRight() {
    final width = _rightActionsWidth;
    if (width <= 0) return;
    _animateTo(-width);
    _isOpen = true;
    widget.onOpen?.call();
  }

  void _animateTo(double target) {
    // 将当前偏移量和目标偏移量映射到动画控制器的 0.0 ~ 1.0 范围
    final double startValue = _dragOffset;
    final double endValue = target;

    // 使用 Tween 来驱动动画
    _animationController.value = 0.0;
    final Tween<double> tween = Tween<double>(begin: startValue, end: endValue);

    // 监听动画并更新偏移量
    void listener() {
      setState(() {
        _dragOffset = tween.transform(_animationController.value);
      });
    }

    // 移除旧监听器，添加新的
    _animationController.removeListener(_handleAnimationTick);
    _animationController.addListener(listener);
    _animationController.forward(from: 0.0).then((_) {
      _animationController.removeListener(listener);
      _animationController.addListener(_handleAnimationTick);
    });
  }

  void _onDragStart(DragStartDetails details) {
    _animationController.stop();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    final double delta = details.primaryDelta ?? 0;
    setState(() {
      _dragOffset += delta;

      final double maxLeft = _leftActionsWidth;
      final double maxRight = _rightActionsWidth;

      // 限制拖动范围，添加阻尼效果
      if (_dragOffset > maxLeft) {
        _dragOffset = maxLeft + (_dragOffset - maxLeft) * 0.3;
      } else if (_dragOffset < -maxRight) {
        _dragOffset = -maxRight + (_dragOffset + maxRight) * 0.3;
      }
    });
  }

  void _onDragEnd(DragEndDetails details) {
    final double velocity = details.primaryVelocity ?? 0;
    final double offset = _dragOffset;

    // 根据速度和位置判断是否打开
    if (velocity > 500) {
      // 快速右滑 → 打开左侧
      if (_leftActionsWidth > 0) {
        _openLeft();
      } else {
        _animateTo(0.0);
      }
    } else if (velocity < -500) {
      // 快速左滑 → 打开右侧
      if (_rightActionsWidth > 0) {
        _openRight();
      } else {
        _animateTo(0.0);
      }
    } else if (offset > _leftActionsWidth / 2) {
      _openLeft();
    } else if (offset < -_rightActionsWidth / 2) {
      _openRight();
    } else {
      _animateTo(0.0);
      if (_isOpen) {
        _isOpen = false;
        widget.onClose?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      child: Stack(
        children: [
          // 背景操作按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 左侧操作按钮
              if (widget.leftActions != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.leftActions!,
                )
              else
                const SizedBox.shrink(),
              // 右侧操作按钮
              if (widget.rightActions != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.rightActions!,
                )
              else
                const SizedBox.shrink(),
            ],
          ),
          // 前景内容
          Transform.translate(
            offset: Offset(_dragOffset, 0),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}

/// 滑动单元格控制器，用于外部管理关闭已打开的单元格
class SantoSwipeCellController {
  _SantoSwipeCellState? _currentState;

  void _register(_SantoSwipeCellState state) {
    _currentState = state;
  }

  void _unregister(_SantoSwipeCellState state) {
    if (_currentState == state) {
      _currentState = null;
    }
  }

  /// 关闭当前打开的滑动单元格
  void close() {
    _currentState?._close();
  }
}
