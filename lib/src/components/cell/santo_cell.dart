import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

/// 单元格组件
///
/// 标准列表行布局，支持左图标 + 标题 + 描述 + 右侧内容/箭头
/// 适用于设置页面、列表展示等场景
///
/// 示例：
/// ```dart
/// SantoCell(
///   title: '个人信息',
///   description: '查看和编辑个人资料',
///   leftIcon: Icons.person,
///   onTap: () {},
/// )
/// ```
///
class SantoCell extends StatelessWidget {
  /// 标题
  final String? title;

  /// 标题下方的描述文字
  final String? description;

  /// 右侧备注文字
  final String? note;

  /// 左侧图标
  final IconData? leftIcon;

  /// 左侧自定义组件，优先级高于 [leftIcon]
  final Widget? leftWidget;

  /// 右侧图标
  final IconData? rightIcon;

  /// 是否显示右侧箭头，默认 true
  final bool showArrow;

  /// 点击回调
  final VoidCallback? onTap;

  /// 是否显示上分割线
  final bool topLine;

  /// 是否显示下分割线
  final bool bottomLine;

  /// 右侧自定义组件，优先级高于 [note] 和 [rightIcon]
  final Widget? rightWidget;

  /// 标题文字样式
  final TextStyle? titleStyle;

  /// 描述文字样式
  final TextStyle? descriptionStyle;

  /// 内边距
  final EdgeInsetsGeometry? padding;

  /// 最小高度
  final double minHeight;

  /// 单元格组件构造函数
  const SantoCell({
    Key? key,
    this.title,
    this.description,
    this.note,
    this.leftIcon,
    this.leftWidget,
    this.rightIcon,
    this.showArrow = true,
    this.onTap,
    this.topLine = false,
    this.bottomLine = true,
    this.rightWidget,
    this.titleStyle,
    this.descriptionStyle,
    this.padding,
    this.minHeight = 56,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;
    final dividerColor = commonConfig.dividerColorBase;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (topLine)
            Divider(height: 0.5, thickness: 0.5, color: dividerColor),
          Container(
            constraints: BoxConstraints(minHeight: minHeight),
            padding: padding ??
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                // 左侧图标
                if (leftWidget != null) ...[
                  leftWidget!,
                  const SizedBox(width: 12),
                ] else if (leftIcon != null) ...[
                  Icon(
                    leftIcon,
                    size: 22,
                    color: commonConfig.colorTextBase,
                  ),
                  const SizedBox(width: 12),
                ],
                // 中间内容
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (title != null)
                        Text(
                          title!,
                          style: titleStyle ??
                              TextStyle(
                                fontSize: 16,
                                color: commonConfig.colorTextBase,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      if (description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          description!,
                          style: descriptionStyle ??
                              TextStyle(
                                fontSize: 12,
                                color: commonConfig.colorTextSecondary,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
                // 右侧内容
                if (rightWidget != null)
                  rightWidget!
                else if (note != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Text(
                      note!,
                      style: TextStyle(
                        fontSize: 14,
                        color: commonConfig.colorTextSecondary,
                      ),
                    ),
                  ),
                if (showArrow)
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Icon(
                      rightIcon ?? Icons.chevron_right,
                      size: 20,
                      color: commonConfig.colorTextSecondary,
                    ),
                  ),
              ],
            ),
          ),
          if (bottomLine)
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Divider(
                  height: 0.5, thickness: 0.5, color: dividerColor),
            ),
        ],
      ),
    );
  }
}

/// 单元格组组件
///
/// 将多个 [SantoCell] 组合在一起，可选添加标题和底部间距
///
/// 示例：
/// ```dart
/// SantoCellGroup(
///   title: '基本设置',
///   children: [
///     SantoCell(title: '个人信息'),
///     SantoCell(title: '通知设置'),
///     SantoCell(title: '隐私'),
///   ],
/// )
/// ```
///
class SantoCellGroup extends StatelessWidget {
  /// 子组件列表
  final List<Widget> children;

  /// 组标题
  final String? title;

  /// 组标题样式
  final TextStyle? titleStyle;

  /// 背景颜色
  final Color? backgroundColor;

  /// 单元格组构造函数
  const SantoCellGroup({
    Key? key,
    required this.children,
    this.title,
    this.titleStyle,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final commonConfig =
        SantoThemeConfigurator.instance.getConfig().commonConfig;

    return Container(
      color: backgroundColor ?? Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null)
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(12, 16, 12, 8),
              child: Text(
                title!,
                style: titleStyle ??
                    TextStyle(
                      fontSize: 14,
                      color: commonConfig.colorTextSecondary,
                    ),
              ),
            ),
          ...children,
        ],
      ),
    );
  }
}
