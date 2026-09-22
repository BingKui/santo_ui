import 'dart:math';

import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 位置枚举
enum SantoToastGravity {
  /// 底部显示
  bottom,

  /// 居中显示
  center,

  /// 顶部显示
  top,
}

/// toast 显示时长
class SantoDuration {
  SantoDuration._();

  /// toast 显示较短时间（1s）
  static const Duration short = Duration(seconds: 1);

  /// toast 显示较长时间（3s）
  static const Duration long = Duration(seconds: 3);
}

/// 通用的Toast组件
class SantoToast {
  /// Toast 距离顶部默认间距
  static const int _defaultTopOffset = 50;

  /// Toast 距离底部默认间距
  static const int _defaultBottomOffset = 50;

  /// _ToastView
  static _ToastView? preToastView;

  /// 显示在中间。如不设置duration则会自动根据内容长度来计算（更友好，最长5秒）
  static void showInCenter(
      {required String text,
      required BuildContext context,
      Duration? duration}) {
    show(
      text,
      context,
      duration: duration,
      gravity: SantoToastGravity.center,
    );
  }

  /// 显示Toast，如不设置duration则会自动根据内容长度来计算（更友好，最长5秒）
  static void show(
    String text,
    BuildContext context, {
    Duration? duration,
    Color? backgroundColor,
    TextStyle textStyle = const TextStyle(fontSize: 16, color: Colors.white),
    double? radius,
    Widget? preIcon,
    double? verticalOffset,
    VoidCallback? onDismiss,
    SantoToastGravity? gravity,
  }) {
    final OverlayState? overlayState = Overlay.of(context);
    if (overlayState == null) return;

    preToastView?._dismiss();
    preToastView = null;

    final double finalVerticalOffset = getVerticalOffset(
      context: context,
      gravity: gravity,
      verticalOffset: verticalOffset,
    );

    /// 自动根据内容长度决定显示时长，更加人性化
    final int autoDuration = min(text.length * 0.06 + 0.8, 5.0).ceil();
    final Duration finalDuration = duration ?? Duration(seconds: autoDuration);
    final OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) {
        return _ToastWidget(
          widget: ToastChild(
            backgroundColor: backgroundColor,
            radius: radius,
            msg: text,
            leading: preIcon,
            textStyle: textStyle,
            gravity: gravity,
            verticalOffset: finalVerticalOffset,
          ),
        );
      },
    );
    final _ToastView toastView =
        _ToastView(overlayState: overlayState, overlayEntry: overlayEntry);
    preToastView = toastView;
    toastView._show(
      duration: finalDuration,
      onDismiss: onDismiss,
    );
  }

  /// 获取默认设置的垂直间距
  static double getVerticalOffset({
    required BuildContext context,
    SantoToastGravity? gravity,
    double? verticalOffset,
  }) {
    final double _verticalOffset = verticalOffset ?? 0;
    final double defaultOffset;
    switch (gravity) {
      case SantoToastGravity.bottom:
        final offset = verticalOffset ?? _defaultBottomOffset;
        defaultOffset = MediaQuery.of(context).viewInsets.bottom + offset;
        break;
      case SantoToastGravity.top:
        final offset = verticalOffset ?? _defaultTopOffset;
        defaultOffset = MediaQuery.of(context).viewInsets.top + offset;
        break;
      case SantoToastGravity.center:
      default:
        defaultOffset = verticalOffset ?? 0;
    }

    return defaultOffset + _verticalOffset;
  }
}

class _ToastView {
  OverlayState overlayState;
  OverlayEntry overlayEntry;
  bool _isVisible = false;

  _ToastView({
    required this.overlayState,
    required this.overlayEntry,
  });

  void _show({required Duration duration, VoidCallback? onDismiss}) async {
    _isVisible = true;
    overlayState.insert(overlayEntry);
    Future.delayed(duration, () {
      _dismiss();
      onDismiss?.call();
    });
  }

  void _dismiss() async {
    if (!_isVisible) {
      return;
    }
    _isVisible = false;
    overlayEntry.remove();
  }
}

class ToastChild extends StatelessWidget {
  const ToastChild({
    Key? key,
    required this.msg,
    required this.verticalOffset,
    this.backgroundColor,
    this.radius,
    this.leading,
    this.gravity,
    this.textStyle,
  }) : super(key: key);

  Alignment get alignment {
    switch (gravity) {
      case SantoToastGravity.bottom:
        return Alignment.bottomCenter;
      case SantoToastGravity.top:
        return Alignment.topCenter;
      case SantoToastGravity.center:
      default:
        return Alignment.center;
    }
  }

  EdgeInsets get padding {
    switch (gravity) {
      case SantoToastGravity.bottom:
        return EdgeInsets.only(bottom: verticalOffset);
      case SantoToastGravity.top:
        return EdgeInsets.only(top: verticalOffset);
      case SantoToastGravity.center:
      default:
        return EdgeInsets.only(top: verticalOffset);
    }
  }

  final String msg;
  final double verticalOffset;
  final Color? backgroundColor;
  final double? radius;
  final Widget? leading;
  final SantoToastGravity? gravity;
  final TextStyle? textStyle;

  InlineSpan get leadingSpan {
    if (leading == null) {
      return const TextSpan(text: "");
    }
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: Padding(
          padding: EdgeInsets.only(right: commonConfig.hSpacingXs),
          child: leading!),
    );
  }

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding: padding,
        alignment: alignment,
        width: MediaQuery.of(context).size.width,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? const Color(0xFF17233D),
            borderRadius: BorderRadius.circular(radius ?? commonConfig.radiusXs),
          ),
          margin: EdgeInsets.symmetric(horizontal: commonConfig.hSpacingLg),
          padding: EdgeInsets.fromLTRB(commonConfig.hSpacingLg,
              commonConfig.vSpacingSm, commonConfig.hSpacingLg,
              commonConfig.vSpacingSm),
          child: RichText(
            text: TextSpan(children: <InlineSpan>[
              leadingSpan,
              TextSpan(text: msg, style: textStyle),
            ]),
          ),
        ),
      ),
    );
  }
}

class _ToastWidget extends StatelessWidget {
  const _ToastWidget({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final Widget widget;

  /// 使用IgnorePointer，方便手势透传过去
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Material(color: Colors.transparent, child: widget),
    );
  }
}
