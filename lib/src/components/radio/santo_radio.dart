import 'package:flutter/material.dart';

import 'package:santo_ui/src/components/checkbox/santo_checkbox.dart';
import 'package:santo_ui/src/components/checkbox/santo_checkbox_group.dart';
import 'package:santo_ui/src/components/radio/santo_radio_group.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';

/// 单选框样式
enum SantoRadioStyle {
  /// 圆形(选中为实心对号圆)
  circle,

  /// 方形
  square,

  /// 无背景勾选(仅对号)
  check,

  /// 镂空圆点
  hollowCircle,
}

/// 单选框
///
/// 字段含义与 [SantoCheckbox] 一致,额外支持 [radioStyle] 四种单选框样式;
/// 通常配合 [SantoRadioGroup] 使用,由分组保证组内互斥。
class SantoRadio extends SantoCheckbox {
  const SantoRadio({
    Key? key,
    String? id,
    String? title,
    String? subTitle,
    TextStyle? titleStyle,
    TextStyle? subTitleStyle,
    bool enable = true,
    bool checked = false,
    int? titleMaxLine = 1,
    int subTitleMaxLine = 1,
    SantoCheckboxIconBuilder? customIconBuilder,
    SantoCheckboxContentBuilder? customContentBuilder,
    double? insetSpacing,
    double? spacing,
    Color? backgroundColor,
    Color? selectColor,
    Color? disableColor,
    SantoCheckBoxSize size = SantoCheckBoxSize.small,
    bool cardMode = false,
    bool showDivider = true,
    SantoContentDirection contentDirection = SantoContentDirection.right,
    SantoCheckboxValueChanged? onChanged,
    Color? titleColor,
    Color? subTitleColor,
    double? checkBoxLeftSpace,
    EdgeInsetsGeometry? customSpace,
    this.radioStyle = SantoRadioStyle.circle,
  }) : super(
          key: key,
          id: id,
          title: title,
          subTitle: subTitle,
          titleStyle: titleStyle,
          subTitleStyle: subTitleStyle,
          enable: enable,
          checked: checked,
          titleMaxLine: titleMaxLine,
          subTitleMaxLine: subTitleMaxLine,
          customIconBuilder: customIconBuilder,
          customContentBuilder: customContentBuilder,
          insetSpacing: insetSpacing,
          spacing: spacing,
          backgroundColor: backgroundColor,
          selectColor: selectColor,
          disableColor: disableColor,
          size: size,
          cardMode: cardMode,
          showDivider: showDivider,
          contentDirection: contentDirection,
          onChanged: onChanged,
          titleColor: titleColor,
          subTitleColor: subTitleColor,
          checkBoxLeftSpace: checkBoxLeftSpace,
          customSpace: customSpace,
        );

  /// 单选框样式
  final SantoRadioStyle radioStyle;

  @override
  Widget buildDefaultIcon(
      BuildContext context, SantoCheckboxGroupState? groupState, bool isChecked) {
    if (cardMode) return const SizedBox.shrink();
    // 分组可统一样式
    final style = groupState is SantoRadioGroupState
        ? (groupState.widget as SantoRadioGroup).radioCheckStyle ?? radioStyle
        : radioStyle;

    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final unselectedColor = style == SantoRadioStyle.check
        ? Colors.transparent
        : commonConfig.borderColorBase;

    final Color color;
    if (!enable) {
      color = isChecked
          ? (disableColor ?? commonConfig.brandPrimary.withAlpha(0x4D))
          : unselectedColor;
    } else {
      color = isChecked
          ? (selectColor ?? commonConfig.brandPrimary)
          : unselectedColor;
    }

    if (style == SantoRadioStyle.hollowCircle) {
      return SizedBox(
        width: SantoCheckboxState.indicatorSize,
        height: SantoCheckboxState.indicatorSize,
        child: CustomPaint(
          painter: _HollowCirclePainter(isChecked: isChecked, color: color),
        ),
      );
    }

    final IconData iconData = style == SantoRadioStyle.square
        ? (isChecked ? Icons.check_box : Icons.check_box_outline_blank)
        : style == SantoRadioStyle.check
            ? Icons.check
            : (isChecked ? Icons.check_circle : Icons.radio_button_unchecked);
    return SizedBox(
      width: SantoCheckboxState.indicatorSize,
      height: SantoCheckboxState.indicatorSize,
      child: Icon(iconData,
          size: SantoCheckboxState.indicatorSize, color: color),
    );
  }

  static SantoCommonConfig _commonConfigOf(BuildContext context) =>
      SantoCheckbox._commonConfig();

  @override
  State<SantoCheckbox> createState() => SantoRadioState();
}

class SantoRadioState extends SantoCheckboxState {
  @override
  Widget build(BuildContext context) {
    // 严格模式:只能切换、不能取消勾选
    final groupState = SantoCheckboxGroupInherited.of(context)?.state;
    if (groupState is SantoRadioGroupState &&
        (groupState.widget as SantoRadioGroup).strictMode) {
      canNotCancel = true;
    }
    return super.build(context);
  }
}

/// 镂空圆点:外圈描边 + 内圈实心点
class _HollowCirclePainter extends CustomPainter {
  const _HollowCirclePainter({required this.isChecked, required this.color});

  final bool isChecked;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(
      center,
      10.5,
      Paint()
        ..isAntiAlias = true
        ..color = color
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );
    if (isChecked) {
      canvas.drawCircle(
        center,
        6,
        Paint()
          ..isAntiAlias = true
          ..color = color
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _HollowCirclePainter oldDelegate) =>
      oldDelegate.isChecked != isChecked || oldDelegate.color != color;
}
