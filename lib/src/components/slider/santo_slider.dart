import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 滑块组件
///
/// 支持单值和双值（范围）模式，支持刻度标记，支持自定义颜色。
///
/// 使用示例：
/// ```dart
/// SantoSlider(value: 30, onChanged: (v) {})
/// SantoSlider(rangeValue: [20, 80], onChanged: (v) {})
/// ```
class SantoSlider extends StatelessWidget {
  /// 最小值
  final double min;

  /// 最大值
  final double max;

  /// 单值模式的当前值（与 rangeValue 二选一）
  final double? value;

  /// 范围模式的当前值 [start, end]（与 value 二选一）
  final List<double>? rangeValue;

  /// 刻度数量，0 表示不显示刻度
  final int divisions;

  /// 是否显示当前值标签
  final bool showLabel;

  /// 拖动时显示的标签文案,默认显示当前值取整
  final String? label;

  /// 无障碍语义格式化回调
  final String Function(double value)? semanticFormatterCallback;

  /// 激活区域颜色（滑块左侧），默认使用主题色 brandPrimary
  final Color? activeColor;

  /// 未激活区域颜色（滑块右侧）
  final Color? inactiveColor;

  /// 值变化回调
  final ValueChanged<dynamic> onChanged;

  /// 开始拖动回调
  final ValueChanged<dynamic>? onChangeStart;

  /// 结束拖动回调
  final ValueChanged<dynamic>? onChangeEnd;

  const SantoSlider({
    Key? key,
    this.min = 0,
    this.max = 100,
    this.value,
    this.rangeValue,
    this.divisions = 0,
    this.showLabel = false,
    this.label,
    this.semanticFormatterCallback,
    this.activeColor,
    this.inactiveColor,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
  })  : assert(value != null || rangeValue != null,
            '必须提供 value 或 rangeValue 之一'),
        assert(rangeValue == null || rangeValue.length == 2,
            'rangeValue 必须包含两个元素'),
        super(key: key);

  Color get _brandPrimary =>
      SantoThemeConfigurator.instance.getConfig().commonConfig.brandPrimary;

  bool get _isRange => rangeValue != null;

  @override
  Widget build(BuildContext context) {
    final Color active = activeColor ?? _brandPrimary;
    final Color inactive = inactiveColor ?? const Color(0xFFE0E0E0);

    if (_isRange) {
      return _buildRangeSlider(active, inactive);
    }
    return _buildSingleSlider(active, inactive);
  }

  Widget _buildSingleSlider(Color active, Color inactive) {
    return SliderTheme(
      data: SliderThemeData(
        activeTrackColor: active,
        inactiveTrackColor: inactive,
        thumbColor: active,
        overlayColor: active.withAlpha(40),
        valueIndicatorColor: active,
        showValueIndicator: showLabel
            ? ShowValueIndicator.always
            : ShowValueIndicator.never,
        trackHeight: 4.0,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
        valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
        valueIndicatorTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
      child: Slider(
        value: (value ?? min).clamp(min, max),
        min: min,
        max: max,
        divisions: divisions > 0 ? divisions : null,
        label: showLabel || label != null
            ? (label ?? '${(value ?? min).round()}')
            : null,
        semanticFormatterCallback: semanticFormatterCallback,
        onChangeStart:
            onChangeStart != null ? (v) => onChangeStart!(v) : null,
        onChangeEnd:
            onChangeEnd != null ? (v) => onChangeEnd!(v) : null,
        onChanged: (v) => onChanged(v),
      ),
    );
  }

  Widget _buildRangeSlider(Color active, Color inactive) {
    return SliderTheme(
      data: SliderThemeData(
        activeTrackColor: active,
        inactiveTrackColor: inactive,
        thumbColor: active,
        overlayColor: active.withAlpha(40),
        rangeThumbShape:
            const RoundRangeSliderThumbShape(enabledThumbRadius: 8),
        rangeTickMarkShape: const RoundRangeSliderTickMarkShape(),
        rangeValueIndicatorShape:
            const PaddleRangeSliderValueIndicatorShape(),
        showValueIndicator: showLabel
            ? ShowValueIndicator.always
            : ShowValueIndicator.never,
        valueIndicatorTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
      child: RangeSlider(
        values: RangeValues(
          (rangeValue![0]).clamp(min, max),
          (rangeValue![1]).clamp(min, max),
        ),
        min: min,
        max: max,
        divisions: divisions > 0 ? divisions : null,
        semanticFormatterCallback: semanticFormatterCallback,
        labels: showLabel
            ? RangeLabels(
                '${rangeValue![0].round()}',
                '${rangeValue![1].round()}',
              )
            : null,
        onChangeStart: onChangeStart != null
            ? (v) => onChangeStart!([v.start, v.end])
            : null,
        onChangeEnd: onChangeEnd != null
            ? (v) => onChangeEnd!([v.start, v.end])
            : null,
        onChanged: (v) => onChanged([v.start, v.end]),
      ),
    );
  }
}
