import 'package:santo_ui/src/theme/santo_theme.dart';
import 'package:flutter/material.dart';

import 'santo_switch_button_base.dart';


/// 描述: 开关按钮
class SantoSwitchButton extends StatefulWidget {
  final Size size;

  ///选中的状态
  final bool value;

  ///是否可以交互
  final bool enabled;

  ///是否处于加载状态：显示加载指示器并禁用交互（参考 TDesign）
  final bool loading;

  ///点击事件
  final ValueChanged<bool> onChanged;

  ///未选中时边框的颜色
  final Color? borderColor;

  SantoSwitchButton({
    Key? key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.loading = false,
    this.size = const Size(42, 26),
    this.borderColor,
  }) : super(key: key);

  @override
  _SantoSwitchButtonState createState() => _SantoSwitchButtonState();
}

class _SantoSwitchButtonState extends State<SantoSwitchButton> {
  @override
  Widget build(BuildContext context) {
    return SantoBaseSwitchButton(
      borderColor: widget.borderColor ?? _getBorderColor(),
      value: widget.value,
      enabled: widget.enabled,
      loading: widget.loading,
      size: widget.size,
      trackColor: _getTrackColor(),
      thumbColor: Colors.white,
      onChanged: widget.onChanged,
    );
  }

  Color _getTrackColor() {
    if (widget.value) {
      return SantoThemeConfigurator.instance
          .getConfig()
          .commonConfig
          .brandPrimary;
    } else {
      return const Color(0xFFFAFAFA);
    }
  }

  Color _getBorderColor() {
    if (widget.value) {
      return _getTrackColor();
    } else {
      return const Color(0xffeeeeee);
    }
  }
}
