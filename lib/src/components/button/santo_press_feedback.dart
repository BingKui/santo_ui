import 'package:flutter/material.dart';

/// 按压反馈容器：按下时透明度降低、松开后恢复，用于给可点击区域提供点击反馈
///
/// [onTap] 为 null 或 [enabled] 为 false 时不响应点击、也无按压反馈
class SantoPressFeedback extends StatefulWidget {
  final Widget child;

  ///点击回调
  final VoidCallback? onTap;

  ///是否可点击,false 时点击事件不响应且无按压反馈
  final bool enabled;

  ///按压时的透明度 默认 0.7
  final double pressedOpacity;

  final HitTestBehavior behavior;

  const SantoPressFeedback({
    Key? key,
    required this.child,
    this.onTap,
    this.enabled = true,
    this.pressedOpacity = 0.7,
    this.behavior = HitTestBehavior.opaque,
  }) : super(key: key);

  @override
  State<SantoPressFeedback> createState() => _SantoPressFeedbackState();
}

class _SantoPressFeedbackState extends State<SantoPressFeedback> {
  bool _pressed = false;

  bool get _active => widget.enabled && widget.onTap != null;

  void _setPressed(bool pressed) {
    if (_pressed != pressed) {
      setState(() {
        _pressed = pressed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: widget.behavior,
      onTapDown: _active ? (_) => _setPressed(true) : null,
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: _active ? widget.onTap : null,
      child: AnimatedOpacity(
        opacity: _pressed ? widget.pressedOpacity : 1.0,
        duration: const Duration(milliseconds: 100),
        child: widget.child,
      ),
    );
  }
}
