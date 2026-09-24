import 'dart:async';

import 'package:flutter/material.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';

/// 消息通知类型枚举
enum SantoMessageType {
  /// 成功
  success,

  /// 错误
  error,

  /// 警告
  warning,

  /// 信息
  info,
}

/// Message 消息通知组件
///
/// 顶部轻量消息提示，支持多种类型：success、error、warning、info。
/// 使用 Overlay 实现，自动消失。
///
/// 使用示例：
/// ```dart
/// // 显示成功消息
/// SantoMessage.show(
///   context: context,
///   content: '操作成功',
///   type: SantoMessageType.success,
/// );
///
/// // 显示自定义消息
/// SantoMessage.show(
///   context: context,
///   content: '自定义消息',
///   duration: Duration(seconds: 5),
/// );
/// ```
class SantoMessage {
  /// 当前显示的 OverlayEntry
  static OverlayEntry? _currentEntry;

  /// 当前计时器
  static Timer? _dismissTimer;

  /// 显示消息通知
  ///
  /// [context] 上下文
  /// [content] 消息内容
  /// [type] 消息类型，默认 info
  /// [duration] 自动消失时长，默认2秒
  /// [backgroundColor] 背景色，默认根据类型自动设置
  /// [textColor] 文字颜色，默认白色
  /// [icon] 自定义图标，默认根据类型自动设置
  /// [onDismiss] 消失回调
  static void show({
    required BuildContext context,
    required String content,
    SantoMessageType type = SantoMessageType.info,
    Duration duration = const Duration(seconds: 2),
    Color? backgroundColor,
    Color? textColor,
    IconData? icon,
    VoidCallback? onDismiss,
  }) {
    // 移除之前的消息
    _dismiss();

    final overlayState = Overlay.of(context);

    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;

    // 根据类型获取默认颜色和图标
    final Color defaultBgColor;
    final IconData defaultIcon;
    switch (type) {
      case SantoMessageType.success:
        defaultBgColor = commonConfig.brandSuccess;
        defaultIcon = Icons.check_circle_outline;
        break;
      case SantoMessageType.error:
        defaultBgColor = commonConfig.brandError;
        defaultIcon = Icons.error_outline;
        break;
      case SantoMessageType.warning:
        defaultBgColor = commonConfig.brandWarning;
        defaultIcon = Icons.warning_amber_outlined;
        break;
      case SantoMessageType.info:
        defaultBgColor = commonConfig.brandPrimary;
        defaultIcon = Icons.info_outline;
        break;
    }

    final bgColor = backgroundColor ?? defaultBgColor;
    final tColor = textColor ?? commonConfig.colorTextBaseInverse;
    final msgIcon = icon ?? defaultIcon;

    final entry = OverlayEntry(
      builder: (context) {
        return _SantoMessageWidget(
          content: content,
          backgroundColor: bgColor,
          textColor: tColor,
          icon: msgIcon,
        );
      },
    );

    _currentEntry = entry;
    overlayState.insert(entry);

    // 定时消失
    _dismissTimer = Timer(duration, () {
      _dismiss();
      onDismiss?.call();
    });
  }

  /// 显示成功消息
  static void success({
    required BuildContext context,
    required String content,
    Duration duration = const Duration(seconds: 2),
    Color? backgroundColor,
    Color? textColor,
    VoidCallback? onDismiss,
  }) {
    show(
      context: context,
      content: content,
      type: SantoMessageType.success,
      duration: duration,
      backgroundColor: backgroundColor,
      textColor: textColor,
      onDismiss: onDismiss,
    );
  }

  /// 显示错误消息
  static void error({
    required BuildContext context,
    required String content,
    Duration duration = const Duration(seconds: 2),
    Color? backgroundColor,
    Color? textColor,
    VoidCallback? onDismiss,
  }) {
    show(
      context: context,
      content: content,
      type: SantoMessageType.error,
      duration: duration,
      backgroundColor: backgroundColor,
      textColor: textColor,
      onDismiss: onDismiss,
    );
  }

  /// 显示警告消息
  static void warning({
    required BuildContext context,
    required String content,
    Duration duration = const Duration(seconds: 2),
    Color? backgroundColor,
    Color? textColor,
    VoidCallback? onDismiss,
  }) {
    show(
      context: context,
      content: content,
      type: SantoMessageType.warning,
      duration: duration,
      backgroundColor: backgroundColor,
      textColor: textColor,
      onDismiss: onDismiss,
    );
  }

  /// 显示信息消息
  static void info({
    required BuildContext context,
    required String content,
    Duration duration = const Duration(seconds: 2),
    Color? backgroundColor,
    Color? textColor,
    VoidCallback? onDismiss,
  }) {
    show(
      context: context,
      content: content,
      type: SantoMessageType.info,
      duration: duration,
      backgroundColor: backgroundColor,
      textColor: textColor,
      onDismiss: onDismiss,
    );
  }

  /// 手动关闭消息
  static void dismiss() {
    _dismiss();
  }

  /// 内部关闭方法
  static void _dismiss() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    _currentEntry?.remove();
    _currentEntry = null;
  }
}

/// 消息通知内部 Widget
class _SantoMessageWidget extends StatefulWidget {
  /// 消息内容
  final String content;

  /// 背景色
  final Color backgroundColor;

  /// 文字颜色
  final Color textColor;

  /// 图标
  final IconData icon;

  const _SantoMessageWidget({
    Key? key,
    required this.content,
    required this.backgroundColor,
    required this.textColor,
    required this.icon,
  }) : super(key: key);

  @override
  State<_SantoMessageWidget> createState() => _SantoMessageWidgetState();
}

class _SantoMessageWidgetState extends State<_SantoMessageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final topPadding = MediaQuery.of(context).padding.top;

    return Positioned(
      top: topPadding,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: commonConfig.gapMd,
                  vertical: commonConfig.vSpacingXs),
              padding: EdgeInsets.symmetric(
                  horizontal: commonConfig.hSpacingMd,
                  vertical: commonConfig.gapMd),
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(commonConfig.radiusXs),
                boxShadow: [
                  BoxShadow(
                    color: commonConfig.shadowMd.first.color,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    widget.icon,
                    color: widget.textColor,
                    size: 20,
                  ),
                  SizedBox(width: commonConfig.hSpacingSm),
                  Expanded(
                    child: Text(
                      widget.content,
                      style: TextStyle(
                        color: widget.textColor,
                        fontSize: commonConfig.fontSizeBase,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
