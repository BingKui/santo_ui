import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 数量增减控件（步进器）
///
/// 支持最小值/最大值限制、步长设置、禁用状态。
///
/// 使用示例：
/// ```dart
/// SantoStepper(value: 1, onChanged: (v) {})
/// SantoStepper(value: 5, min: 0, max: 10, step: 2, onChanged: (v) {})
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

  /// 输入框宽度
  final double inputWidth;

  /// 输入框高度
  final double inputHeight;

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
    this.inputWidth = 50.0,
    this.inputHeight = 32.0,
    this.buttonColor,
    this.disabledColor,
    this.textColor,
  })  : assert(max >= min, 'max 必须大于等于 min'),
        assert(step > 0, 'step 必须大于 0'),
        super(key: key);

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
    final Color btnColor = widget.buttonColor ?? Colors.white;
    final Color disColor = widget.disabledColor ?? _dividerColor.withAlpha(100);
    final Color txtColor = widget.textColor ?? _textBase;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 减号按钮
        _buildButton(
          icon: Icons.remove,
          enabled: _canDecrease,
          color: btnColor,
          disabledColor: disColor,
          onTap: _decrease,
        ),
        // 输入框
        Container(
          width: widget.inputWidth,
          height: widget.inputHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: _dividerColor.withAlpha(150)),
              bottom: BorderSide(color: _dividerColor.withAlpha(150)),
            ),
          ),
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
              fontSize: 14,
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
        // 加号按钮
        _buildButton(
          icon: Icons.add,
          enabled: _canIncrease,
          color: btnColor,
          disabledColor: disColor,
          onTap: _increase,
        ),
      ],
    );
  }

  Widget _buildButton({
    required IconData icon,
    required bool enabled,
    required Color color,
    required Color disabledColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: widget.inputHeight,
        height: widget.inputHeight,
        decoration: BoxDecoration(
          color: enabled ? color : disabledColor,
          border: Border.all(color: _dividerColor.withAlpha(150)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 18,
          color: enabled
              ? _textBase
              : _textBase.withAlpha(100),
        ),
      ),
    );
  }
}
