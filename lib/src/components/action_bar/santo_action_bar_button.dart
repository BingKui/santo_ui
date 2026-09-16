import 'package:flutter/material.dart';

import 'package:santo_ui/src/components/button/santo_press_feedback.dart';
import 'package:santo_ui/src/theme/configs/santo_common_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';

/// 操作栏按钮高度
const double kSantoActionBarButtonHeight = 40;

/// 操作栏按钮外侧(首个左侧、末个右侧)留白
const double kSantoActionBarButtonMargin = 5;

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
/// 对标 Vant ActionBarButton:在 [SantoActionBar] 中自动平分剩余宽度,
/// 位于整组按钮首位时左侧带圆角与外边距,末位时右侧带圆角与外边距,
/// 中间的按钮保持直角,与相邻按钮拼成一组。
///
/// 示例:
/// ```dart
/// SantoActionBar(children: [
///   SantoActionBarIcon(icon: Icon(Icons.chat), text: '客服'),
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

  /// 是否禁用,禁用后降低透明度且不响应点击
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
    final SantoCommonConfig common =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final Color background = color ?? _backgroundColor(common);
    final Color foreground = _foregroundColor(common);
    final bool hasCustomColor = color != null;

    Widget content = child ??
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (loading) ...[
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: foreground,
                ),
              ),
              const SizedBox(width: 6),
            ],
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 4),
            ],
            Flexible(
              child: Text(
                text ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: common.fontSizeBase,
                  fontWeight: FontWeight.bold,
                  color: foreground,
                ),
              ),
            ),
          ],
        );

    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: kSantoActionBarButtonHeight,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(
            left: first ? kSantoActionBarButtonMargin : 0,
            right: last ? kSantoActionBarButtonMargin : 0,
          ),
          child: SantoPressFeedback(
            enabled: !disabled && !loading,
            onTap: onTap,
            child: Opacity(
              opacity: disabled ? 0.4 : 1,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: background,
                  border: hasCustomColor || type != SantoActionBarButtonType.normal
                      ? null
                      : Border.all(
                          color: common.borderColorBase,
                          width: common.borderWidthMd,
                        ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(first ? kSantoActionBarRadius : 0),
                    bottomLeft: Radius.circular(first ? kSantoActionBarRadius : 0),
                    topRight: Radius.circular(last ? kSantoActionBarRadius : 0),
                    bottomRight: Radius.circular(last ? kSantoActionBarRadius : 0),
                  ),
                ),
                child: content,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _backgroundColor(SantoCommonConfig common) {
    switch (type) {
      case SantoActionBarButtonType.normal:
        return common.fillBase;
      case SantoActionBarButtonType.primary:
        return common.brandPrimary;
      case SantoActionBarButtonType.success:
        return common.brandSuccess;
      case SantoActionBarButtonType.warning:
        return common.brandWarning;
      case SantoActionBarButtonType.danger:
        return common.brandError;
    }
  }

  Color _foregroundColor(SantoCommonConfig common) {
    if (color != null || type != SantoActionBarButtonType.normal) {
      return common.colorTextBaseInverse;
    }
    return common.colorTextBase;
  }
}
