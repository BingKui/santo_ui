import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 步进器圆角
const double kSantoStepperRadius = 12;

/// 贴外框左侧的圆角(减号按钮)
const BorderRadius _leftEdgeRadius = BorderRadius.only(
  topLeft: Radius.circular(kSantoStepperRadius),
  bottomLeft: Radius.circular(kSantoStepperRadius),
);

/// 贴外框右侧的圆角(加号按钮)
const BorderRadius _rightEdgeRadius = BorderRadius.only(
  topRight: Radius.circular(kSantoStepperRadius),
  bottomRight: Radius.circular(kSantoStepperRadius),
);

/// 步进器尺寸档位
enum SantoStepperSize {
  /// 小号:高 24
  small,

  /// 正常:高 32
  normal,

  /// 大号:高 40
  large,
}

/// 各档位的尺寸预设
class _StepperSizePreset {
  /// 控件高度,也是两侧按钮的边长
  final double height;

  /// 数值区宽度
  final double inputWidth;

  /// 数值字号
  final double fontSize;

  /// 加减号尺寸
  final double iconSize;

  const _StepperSizePreset({
    required this.height,
    required this.inputWidth,
    required this.fontSize,
    required this.iconSize,
  });
}

const _StepperSizePreset _smallPreset =
    _StepperSizePreset(height: 24, inputWidth: 40, fontSize: 12, iconSize: 14);
const _StepperSizePreset _normalPreset =
    _StepperSizePreset(height: 32, inputWidth: 50, fontSize: 14, iconSize: 18);
const _StepperSizePreset _largePreset =
    _StepperSizePreset(height: 40, inputWidth: 60, fontSize: 16, iconSize: 22);

/// 数量增减控件（步进器）
///
/// 支持最小值/最大值限制、步长设置、禁用状态,以及 small/normal/large 三档尺寸。
///
/// 使用示例：
/// ```dart
/// SantoStepper(value: 1, onChanged: (v) {})
/// SantoStepper(value: 5, min: 0, max: 10, step: 2, onChanged: (v) {})
/// SantoStepper(value: 3, size: SantoStepperSize.small, onChanged: (v) {})
/// ```
class SantoStepper extends StatefulWidget {
  /// 当前值
  final int value;

  /// 最小值
  final int min;

  /// 最大值
  final int max;

  /// 步长
  final int step;

  /// 是否启用
  final bool enabled;

  /// 值变化回调
  final ValueChanged<int> onChanged;

  /// 尺寸档位,默认 [SantoStepperSize.normal]
  final SantoStepperSize size;

  /// 数值区宽度,不传则用尺寸档位的预设值
  final double? inputWidth;

  /// 控件高度,不传则用尺寸档位的预设值
  final double? inputHeight;

  /// 按钮颜色
  final Color? buttonColor;

  /// 按钮禁用颜色
  final Color? disabledColor;

  /// 文字颜色
  final Color? textColor;

  const SantoStepper({
    Key? key,
    required this.value,
    this.min = 0,
    this.max = 99,
    this.step = 1,
    this.enabled = true,
    required this.onChanged,
    this.size = SantoStepperSize.normal,
    this.inputWidth,
    this.inputHeight,
    this.buttonColor,
    this.disabledColor,
    this.textColor,
  })  : assert(max >= min, 'max 必须大于等于 min'),
        assert(step > 0, 'step 必须大于 0'),
        super(key: key);

  /// 当前档位的尺寸预设
  _StepperSizePreset get _preset {
    switch (size) {
      case SantoStepperSize.small:
        return _smallPreset;
      case SantoStepperSize.large:
        return _largePreset;
      case SantoStepperSize.normal:
        return _normalPreset;
    }
  }

  /// 控件高度
  double get height => inputHeight ?? _preset.height;

  /// 数值区宽度
  double get width => inputWidth ?? _preset.inputWidth;

  @override
  State<SantoStepper> createState() => _SantoStepperState();
}

class _SantoStepperState extends State<SantoStepper> {
  late TextEditingController _controller;

  Color get _brandPrimary =>
      SantoThemeConfigurator.instance.getConfig().commonConfig.brandPrimary;

  Color get _dividerColor =>
      SantoThemeConfigurator.instance.getConfig().commonConfig.dividerColorBase;

  Color get _textBase =>
      SantoThemeConfigurator.instance.getConfig().commonConfig.colorTextBase;

  Color get _fillBase =>
      SantoThemeConfigurator.instance.getConfig().commonConfig.fillBase;

  Color get _borderColor =>
      SantoThemeConfigurator.instance.getConfig().commonConfig.borderColorBase;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
  }

  @override
  void didUpdateWidget(SantoStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.text = widget.value.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _canDecrease =>
      widget.enabled && (widget.value - widget.step) >= widget.min;

  bool get _canIncrease =>
      widget.enabled && (widget.value + widget.step) <= widget.max;

  void _decrease() {
    if (!_canDecrease) return;
    final newValue = widget.value - widget.step;
    widget.onChanged(newValue);
  }

  void _increase() {
    if (!_canIncrease) return;
    final newValue = widget.value + widget.step;
    widget.onChanged(newValue);
  }

  void _onInputSubmitted(String text) {
    final parsed = int.tryParse(text);
    if (parsed == null) {
      _controller.text = widget.value.toString();
      return;
    }
    final clamped = parsed.clamp(widget.min, widget.max);
    widget.onChanged(clamped);
    _controller.text = clamped.toString();
  }

  @override
  Widget build(BuildContext context) {
    final Color btnColor = widget.buttonColor ?? _fillBase;
    final Color disColor = widget.disabledColor ?? _dividerColor.withAlpha(100);
    final Color txtColor = widget.textColor ?? _textBase;
    final _StepperSizePreset preset = widget._preset;

    // 外圈整体一个描边,内部三段不画描边(参考分页简易版)
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: _fillBase,
        borderRadius: BorderRadius.all(Radius.circular(kSantoStepperRadius)),
        border: Border.all(color: _borderColor, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // 减号:贴外框左侧承担圆角
          _buildButton(
            icon: Icons.remove,
            enabled: _canDecrease,
            color: btnColor,
            disabledColor: disColor,
            borderRadius: _leftEdgeRadius,
            onTap: _decrease,
          ),
          _buildDivider(),
          // 数值区:无底色、无描边
          Container(
            width: widget.width,
            alignment: Alignment.center,
            child: TextField(
              controller: _controller,
              enabled: widget.enabled,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              style: TextStyle(
                fontSize: preset.fontSize,
                color: widget.enabled ? txtColor : txtColor.withAlpha(100),
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              ),
              onSubmitted: _onInputSubmitted,
            ),
          ),
          _buildDivider(),
          // 加号:贴外框右侧承担圆角
          _buildButton(
            icon: Icons.add,
            enabled: _canIncrease,
            color: btnColor,
            disabledColor: disColor,
            borderRadius: _rightEdgeRadius,
            onTap: _increase,
          ),
        ],
      ),
    );
  }

  /// 项与项之间的分割线
  Widget _buildDivider() {
    return Container(width: 0.5, color: _dividerColor);
  }

  Widget _buildButton({
    required IconData icon,
    required bool enabled,
    required Color color,
    required Color disabledColor,
    required BorderRadius borderRadius,
    required VoidCallback onTap,
  }) {
    return Material(
      color: enabled ? color : disabledColor,
      borderRadius: borderRadius,
      // 裁切后点击水波纹跟着圆角走
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: enabled ? onTap : null,
        child: SizedBox(
          width: widget.height,
          height: widget.height,
          child: Icon(
            icon,
            size: widget._preset.iconSize,
            color: enabled ? _textBase : _textBase.withAlpha(100),
          ),
        ),
      ),
    );
  }
}
