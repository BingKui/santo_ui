import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 结果状态类型
enum SantoResultStatus {
  /// 成功
  success,

  /// 失败
  error,

  /// 警告
  warning,

  /// 信息
  info,
}

/// 操作结果反馈页
///
/// 用于展示操作完成后的结果状态，支持多种状态：成功、失败、警告、信息。
/// 每种状态有默认图标和颜色，支持自定义标题、描述和操作按钮。
///
/// 使用示例：
/// ```dart
/// SantoResult(
///   status: SantoResultStatus.success,
///   title: '操作成功',
///   description: '内容已提交',
///   actions: [
///     SantoSmallMainButton(title: '返回', onTap: () {}),
///   ],
/// )
/// ```
class SantoResult extends StatelessWidget {
  /// 结果状态
  final SantoResultStatus status;

  /// 标题
  final String? title;

  /// 描述信息
  final String? description;

  /// 自定义图标，不传则使用状态对应的默认图标
  final IconData? icon;

  /// 自定义图标颜色，不传则使用状态对应的默认颜色
  final Color? iconColor;

  /// 操作按钮列表
  final List<Widget>? actions;

  const SantoResult({
    Key? key,
    required this.status,
    this.title,
    this.description,
    this.icon,
    this.iconColor,
    this.actions,
  }) : super(key: key);

  /// 获取状态对应的默认图标
  IconData _getDefaultIcon() {
    if (icon != null) return icon!;
    switch (status) {
      case SantoResultStatus.success:
        return Icons.check_circle_outline;
      case SantoResultStatus.error:
        return Icons.cancel_outlined;
      case SantoResultStatus.warning:
        return Icons.warning_amber_outlined;
      case SantoResultStatus.info:
        return Icons.info_outline;
    }
  }

  /// 获取状态对应的默认颜色
  Color _getDefaultColor(dynamic commonConfig) {
    if (iconColor != null) return iconColor!;
    switch (status) {
      case SantoResultStatus.success:
        return commonConfig.brandSuccess;
      case SantoResultStatus.error:
        return commonConfig.brandError;
      case SantoResultStatus.warning:
        return commonConfig.brandWarning;
      case SantoResultStatus.info:
        return commonConfig.brandPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final color = _getDefaultColor(commonConfig);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 图标
            Icon(
              _getDefaultIcon(),
              size: 64,
              color: color,
            ),
            // 标题
            if (title != null) ...[
              const SizedBox(height: 24),
              Text(
                title!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: commonConfig.colorTextBase,
                ),
              ),
            ],
            // 描述
            if (description != null) ...[
              SizedBox(height: commonConfig.pageGap),
              Text(
                description!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: commonConfig.fontSizeBase,
                  color: commonConfig.colorTextSecondary,
                ),
              ),
            ],
            // 操作按钮
            if (actions != null && actions!.isNotEmpty) ...[
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: actions!.map((action) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: commonConfig.hSpacingSm),
                    child: action,
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
