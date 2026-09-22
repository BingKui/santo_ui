import 'package:flutter/material.dart';

import 'package:santo_ui/src/components/button/santo_button.dart';

/// 操作栏按钮外侧(首个左侧、末个右侧)留白
const double kSantoActionBarButtonMargin = 10;

/// 操作栏按钮上下留白
const double kSantoActionBarButtonVerticalPadding = 5;

/// 操作栏圆角,统一 12
const double kSantoActionBarRadius = 12;

/// 操作栏按钮类型
///
/// 对标 Vant ActionBarButton 的 type:
///  * [normal] 白底描边按钮
///  * [primary] 主题色按钮
///  * [success] 成功色按钮
///  * [warning] 警告色按钮
///  * [danger] 危险色按钮
enum SantoActionBarButtonType {
  normal,
  primary,
  success,
  warning,
  danger,
}

/// 操作栏按钮
///
/// 基于 [SantoButton] 实现:在 [SantoActionBar] 中自动平分剩余宽度,
/// 位于整组按钮首位时左侧带圆角与外边距,末位时右侧带圆角与外边距,
/// 中间的按钮保持直角,与相邻按钮拼成一组。
///
/// @changed v1.1.0 改为基于 SantoButton 实现
///
/// 示例:
/// ```dart
/// SantoActionBar(children: [
///   SantoActionBarIcon(icon: SantoIcons.headset, text: '客服'),
///   SantoActionBarButton(text: '加入购物车', type: SantoActionBarButtonType.warning),
///   SantoActionBarButton(text: '立即购买', type: SantoActionBarButtonType.danger),
/// ])
/// ```
class SantoActionBarButton extends StatelessWidget {
  /// 按钮文案,与 [child] 至少提供一个
  final String? text;

  /// 自定义按钮内容,优先级高于 [text]
  final Widget? child;

  /// 按钮类型,决定背景色与文字色,默认 [SantoActionBarButtonType.normal]
  final SantoActionBarButtonType type;

  /// 自定义背景色,优先级高于 [type],使用自定义色时文字为白色
  final Color? color;

  /// 文案左侧的图标
  final Widget? icon;

  /// 是否加载中,展示进度指示且不响应点击
  final bool loading;

  /// 是否禁用,禁用后使用 [SantoButton] 的禁用态且不响应点击
  final bool disabled;

  /// 点击回调
  final VoidCallback? onTap;

  /// 是否为整组按钮的首个,由 [SantoActionBar] 按所在位置计算
  final bool first;

  /// 是否为整组按钮的末个,由 [SantoActionBar] 按所在位置计算
  final bool last;

  const SantoActionBarButton({
    Key? key,
    this.text,
    this.child,
    this.type = SantoActionBarButtonType.normal,
    this.color,
    this.icon,
    this.loading = false,
    this.disabled = false,
    this.onTap,
    this.first = true,
    this.last = true,
  })  : assert(text != null || child != null, 'text 与 child 至少提供一个'),
        super(key: key);

  /// 按在操作栏中的位置重建按钮,由 [SantoActionBar] 内部调用
  SantoActionBarButton withPosition({required bool first, required bool last}) {
    return SantoActionBarButton(
      key: key,
      text: text,
      child: child,
      type: type,
      color: color,
      icon: icon,
      loading: loading,
      disabled: disabled,
      onTap: onTap,
      first: first,
      last: last,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasCustomColor = color != null;
    final SantoButtonColor? buttonColor = hasCustomColor
        ? null
        : switch (type) {
            SantoActionBarButtonType.normal => null,
            SantoActionBarButtonType.primary => SantoButtonColor.primary,
            SantoActionBarButtonType.success => SantoButtonColor.success,
            SantoActionBarButtonType.warning => SantoButtonColor.warning,
            SantoActionBarButtonType.danger => SantoButtonColor.danger,
          };
    final SantoButtonType? buttonType =
        hasCustomColor || buttonColor != null ? null : SantoButtonType.normal;

    return Padding(
      padding: EdgeInsets.only(
        left: first ? kSantoActionBarButtonMargin : 0,
        right: last ? kSantoActionBarButtonMargin : 0,
        top: kSantoActionBarButtonVerticalPadding,
        bottom: kSantoActionBarButtonVerticalPadding,
      ),
      child: SizedBox(
        width: double.infinity,
        child: SantoButton(
          text: text,
          child: child,
          icon: icon,
          loading: loading,
          isEnable: !disabled,
          onTap: onTap,
          type: buttonType,
          color: buttonColor,
          variant: buttonColor != null || hasCustomColor
              ? SantoButtonVariant.solid
              : null,
          backgroundColor: color,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(first ? kSantoActionBarRadius : 0),
            bottomLeft: Radius.circular(first ? kSantoActionBarRadius : 0),
            topRight: Radius.circular(last ? kSantoActionBarRadius : 0),
            bottomRight: Radius.circular(last ? kSantoActionBarRadius : 0),
          ),
        ),
      ),
    );
  }
}
