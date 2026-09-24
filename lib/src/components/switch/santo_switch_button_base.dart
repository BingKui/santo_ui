import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:santo_ui/src/theme/santo_theme.dart';

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

  /// 未选中时的轨道颜色,不传取主题 fillBody
  final Color? trackOffColor;

  /// 选中时的轨道颜色,不传取主题 brandPrimary
  final Color? trackOnColor;

  /// 未选中时边框的颜色
  /// 未选中时边框颜色,不传取主题 dividerColorBase
  final Color? borderColor;

  /// The color to use on the thumb,不传取主题 fillBase
  final Color? thumbColor;

  /// 开启文案，不传则不展示文案
  final String? openText;

  /// 关闭文案，不传则不展示文案
  final String? closeText;

  /// 开启文案颜色,不传取主题反色文字
  final Color? openTextColor;

  /// 关闭文案颜色,不传取主题次要文字色
  final Color? closeTextColor;

  const SantoBaseSwitchButton({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.size,
    this.thumbColor,
    this.trackOnColor,
    this.trackOffColor,
    this.borderColor,
    this.enabled = false,
    this.loading = false,
    this.openText,
    this.closeText,
    this.openTextColor,
    this.closeTextColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final Color resolvedTrackOnColor =
        trackOnColor ?? commonConfig.brandPrimary;
    final Color resolvedTrackOffColor = trackOffColor ?? commonConfig.fillBody;
    final Color resolvedThumbColor = thumbColor ?? commonConfig.fillBase;
    final Color resolvedOpenTextColor =
        openTextColor ?? commonConfig.colorTextBaseInverse;
    final Color resolvedCloseTextColor =
        closeTextColor ?? commonConfig.colorTextSecondary;
    // 加载指示器取与滑块相反的颜色,保证在滑块上有对比度
    final Color spinnerColor = resolvedThumbColor == commonConfig.fillBase
        ? commonConfig.colorTextSecondary
        : commonConfig.fillBase;
    final bool interactive = enabled && !loading;
    final double thumbDiameter = size.height - 2 * _borderWidth;
    final bool hasText = openText != null || closeText != null;
    // 带文案时轨道加宽,给文案留出与滑块等比的槽位,开关文案不会挤掉滑块
    final double trackWidth = hasText
        ? math.max(size.width, 2 * _borderWidth + thumbDiameter * 2 + 6)
        : size.width;

    // UnconstrainedBox 让开关在撑满宽度的父级(如 SantoSection 的内容列)下仍保持自身尺寸
    return UnconstrainedBox(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
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
            width: trackWidth,
            decoration: BoxDecoration(
              color: value ? resolvedTrackOnColor : resolvedTrackOffColor,
              border: Border.all(
                color: value
                    ? Colors.transparent
                    : (borderColor ??
                        SantoThemeConfigurator.instance
                            .getConfig()
                            .commonConfig
                            .dividerColorBase),
                width: _borderWidth,
              ),
              borderRadius: BorderRadius.all(Radius.circular(size.height / 2)),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (hasText)
                  // 文案始终在滑块对侧,与滑块反向滑动
                  AnimatedAlign(
                    duration: _animationDuration,
                    curve: Curves.easeOutCubic,
                    alignment: value
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: _buildTextSlot(
                      thumbDiameter,
                      resolvedOpenTextColor,
                      resolvedCloseTextColor,
                    ),
                  ),
                AnimatedAlign(
                  duration: _animationDuration,
                  curve: Curves.easeOutCubic,
                  alignment: value
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(_borderWidth),
                    child: _buildThumb(
                      thumbDiameter,
                      resolvedThumbColor,
                      spinnerColor,
                      commonConfig.shadowSm,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 文案槽：宽度固定，开关状态切换时轨道宽度不变
  Widget _buildTextSlot(
    double thumbDiameter,
    Color openColor,
    Color closeColor,
  ) {
    return SizedBox(
      width: thumbDiameter + 6,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (openText != null)
            _buildText(openText!, openColor, thumbDiameter, value ? 1 : 0),
          if (closeText != null)
            _buildText(
              closeText!,
              closeColor,
              thumbDiameter,
              value ? 0 : 1,
            ),
        ],
      ),
    );
  }

  Widget _buildText(
    String text,
    Color color,
    double thumbDiameter,
    double opacity,
  ) {
    return AnimatedOpacity(
      duration: _animationDuration,
      opacity: opacity,
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: thumbDiameter * 0.5,
          height: 1,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildThumb(
    double thumbDiameter,
    Color resolvedThumbColor,
    Color spinnerColor,
    List<BoxShadow> shadow,
  ) {
    Widget? child;
    if (loading) {
      child = SizedBox(
        width: 12,
        height: 12,
        child: CircularProgressIndicator(
          strokeWidth: 1.5,
          valueColor: AlwaysStoppedAnimation<Color>(spinnerColor),
        ),
      );
    }
    return Container(
      height: thumbDiameter,
      width: thumbDiameter,
      decoration: BoxDecoration(
        color: resolvedThumbColor,
        shape: BoxShape.circle,
        boxShadow: shadow,
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}
