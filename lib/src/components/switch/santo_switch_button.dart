import 'package:santo_ui/src/theme/santo_theme.dart';
import 'package:flutter/material.dart';

import 'santo_switch_button_base.dart';

/// 描述: 开关按钮

/// 受控组件:[value] 由父级持有,点击通过 [onChanged] 回传,父级改 [value] 即可从外部驱动开关
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

  ///选中时轨道颜色,默认主题 brandPrimary
  final Color? activeColor;

  ///未选中时轨道颜色,默认主题 fillBody
  final Color? inactiveColor;

  ///滑块颜色,默认主题 fillBase
  final Color? thumbColor;

  ///开启文案,与 [closeText] 任一传入即展示文案(轨道自动加宽)
  final String? openText;

  ///关闭文案,与 [openText] 任一传入即展示文案(轨道自动加宽)
  final String? closeText;

  SantoSwitchButton({
    Key? key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.loading = false,
    this.size = const Size(42, 26),
    this.borderColor,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.openText,
    this.closeText,
  }) : super(key: key);

  @override
  _SantoSwitchButtonState createState() => _SantoSwitchButtonState();
}

class _SantoSwitchButtonState extends State<SantoSwitchButton> {
  SantoCommonConfig get _commonConfig =>
      SantoThemeConfigurator.instance.getConfig().commonConfig;

  @override
  Widget build(BuildContext context) {
    return SantoBaseSwitchButton(
      borderColor: widget.borderColor ?? _commonConfig.dividerColorBase,
      value: widget.value,
      enabled: widget.enabled,
      loading: widget.loading,
      size: widget.size,
      trackOnColor: widget.activeColor ?? _commonConfig.brandPrimary,
      trackOffColor: widget.inactiveColor,
      thumbColor: widget.thumbColor,
      openText: widget.openText,
      closeText: widget.closeText,
      openTextColor: _commonConfig.colorTextBaseInverse,
      closeTextColor: _commonConfig.colorTextSecondary,
      onChanged: widget.onChanged,
    );
  }
}
