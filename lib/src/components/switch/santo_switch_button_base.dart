import 'package:flutter/material.dart';

const double _borderWidth = 1.5;
const Duration _animationDuration = Duration(milliseconds: 180);

class SantoBaseSwitchButton extends StatelessWidget {
  final Size size;

  /// Whether this switch is on or off.
  ///
  /// This property must not be null.
  final bool value;

  /// can click
  final bool enabled;

  /// 是否处于加载状态：显示加载指示器并禁用交互（参考 TDesign）
  final bool loading;

  /// Called when the user toggles the switch on or off.
  final ValueChanged<bool>? onChanged;

  /// The color to use when this switch is off.
  final Color borderColor;

  /// The color to use on the track.
  final Color? trackColor;

  /// The color to use on the thumb.
  final Color thumbColor;

  const SantoBaseSwitchButton({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.size,
    this.thumbColor = Colors.white,
    this.trackColor,
    this.borderColor = const Color(0xffeeeeee),
    this.enabled = false,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool interactive = enabled && !loading;
    return GestureDetector(
      onTap: interactive
          ? () {
              onChanged?.call(!value);
            }
          : null,
      child: Opacity(
        // 参考 TDesign：禁用/加载态整体降低不透明度
        opacity: interactive ? 1.0 : 0.4,
        child: AnimatedContainer(
          duration: _animationDuration,
          curve: Curves.easeOut,
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
            color: trackColor,
            border: Border.all(
                color: value ? Colors.transparent : borderColor,
                width: _borderWidth),
            borderRadius:
                BorderRadius.all(Radius.circular(size.height / 2)),
          ),
          child: AnimatedAlign(
            duration: _animationDuration,
            curve: Curves.easeOutCubic,
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(_borderWidth),
              child: _buildThumb(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumb() {
    Widget? child;
    if (loading) {
      child = SizedBox(
        width: 12,
        height: 12,
        child: CircularProgressIndicator(
          strokeWidth: 1.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            thumbColor == Colors.white ? const Color(0xFF999999) : Colors.white,
          ),
        ),
      );
    }
    return Container(
      height: size.height - 2 * _borderWidth,
      width: size.height - 2 * _borderWidth,
      decoration: BoxDecoration(
        color: thumbColor,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}
