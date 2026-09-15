import 'package:santo_ui/src/components/button/santo_icon_button.dart';
import 'package:flutter/material.dart';

///
/// 由上（Icon）、下（文本）两部分组成的 图标按钮
///
/// 按钮的总体尺寸是固定的48*48，上部图标的约束是24*24
///
/// ```dart
///   SantoBottomButtonPanel(
///      mainButtonName: '主按钮',
///      iconButtonList: [
///          SantoVerticalIconButton(
///             name: '写备注',
///             iconWidget: Icon(Icons.add),
///          ),
///          SantoVerticalIconButton(
///             name: '写跟进',
///             iconWidget: Icon(Icons.functions),
///          ),
///      ],
///   )
///
/// ```
/// 其他按钮如下:
///  * [SantoBottomButtonPanel], 主、次、图标按钮组成的横向面板
///
class SantoVerticalIconButton extends StatelessWidget {
  /// 下半部分的文案
  final String name;

  /// 上部分的icon 不可为null
  final Widget iconWidget;

  /// 按钮点击的回调
  final VoidCallback? onTap;

  /// create SantoVerticalIconButton
  const SantoVerticalIconButton({
    Key? key,
    required this.name,
    required this.iconWidget,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SantoIconButton(
      widgetWidth: 48,
      widgetHeight: 48,
      direction: Direction.bottom,
      iconHeight: 24,
      iconWidth: 24,
      name: name,
      iconWidget: iconWidget,
      onTap: onTap,
    );
  }
}
