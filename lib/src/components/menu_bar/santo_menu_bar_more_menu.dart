import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/theme/configs/santo_common_config.dart';

/// 菜单栏"更多"面板的菜单项
class SantoMenuBarMoreMenuItem {
  /// 菜单文案
  final String label;

  /// 图标
  final IconData? icon;

  /// 自定义图标控件,设置后 [icon] 失效
  final Widget? iconWidget;

  /// 点击回调
  final GestureTapCallback? onTap;

  const SantoMenuBarMoreMenuItem({
    required this.label,
    this.icon,
    this.iconWidget,
    this.onTap,
  });
}

/// MenuBar 的"更多"菜单:底部弹出的大圆角面板,标题栏 + 图标宫格。
///
/// 通过 [SantoMenuBarMoreMenu.show] 弹出。
///
/// 示例:
/// 通过 [SantoMenuBarItem.moreMenu] 配置到"更多"标签上,点击标签时自动弹出。
///
/// ```dart
/// SantoMenuBarItem(
///   text: '更多',
///   moreMenu: SantoMenuBarMoreMenu(
///     title: '更多',
///     actionText: '编辑',
///     items: [
///       SantoMenuBarMoreMenuItem(label: '文档', icon: Icons.description_outlined),
///       SantoMenuBarMoreMenuItem(label: '会议', icon: Icons.videocam_outlined),
///     ],
///   ),
/// )
/// ```
class SantoMenuBarMoreMenu extends StatefulWidget {
  /// 标题
  final String? title;

  /// 自定义标题控件
  final Widget? titleWidget;

  /// 右上角操作文案(如"编辑")
  final String? actionText;

  /// 右上角操作点击回调
  final VoidCallback? onActionTap;

  /// 菜单项
  final List<SantoMenuBarMoreMenuItem> items;

  /// 宫格列数,默认 4
  final int columns;

  /// 面板圆角,默认 28
  final double radius;

  /// 面板与屏幕左右/底部边缘的间距,默认 12
  final double edgeGap;

  /// 面板背景色,默认白色
  final Color? backgroundColor;

  /// 菜单项图标颜色,默认主文字色
  final Color? itemColor;

  /// 点击遮罩是否可关闭,默认 true
  final bool barrierDismissible;

  const SantoMenuBarMoreMenu({
    Key? key,
    this.title,
    this.titleWidget,
    this.actionText,
    this.onActionTap,
    required this.items,
    this.columns = 4,
    this.radius = 28,
    this.edgeGap = 12,
    this.backgroundColor,
    this.itemColor,
    this.barrierDismissible = true,
  }) : super(key: key);

  /// 弹出更多菜单(独立用法)
  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    Widget? titleWidget,
    String? actionText,
    VoidCallback? onActionTap,
    required List<SantoMenuBarMoreMenuItem> items,
    int columns = 4,
    double radius = 28,
    double edgeGap = 12,
    Color? backgroundColor,
    Color? itemColor,
    bool barrierDismissible = true,
  }) {
    return open(
      context,
      menu: SantoMenuBarMoreMenu(
        title: title,
        titleWidget: titleWidget,
        actionText: actionText,
        onActionTap: onActionTap,
        items: items,
        columns: columns,
        radius: radius,
        edgeGap: edgeGap,
        backgroundColor: backgroundColor,
        itemColor: itemColor,
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  /// 弹出配置实例对应的菜单面板(MenuBar 的更多标签使用)
  static Future<T?> open<T>(
    BuildContext context, {
    required SantoMenuBarMoreMenu menu,
    bool barrierDismissible = true,
  }) {
    return Navigator.of(context).push<T>(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: barrierDismissible,
        barrierColor: Colors.black.withAlpha(0x66),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(opacity: animation, child: menu);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide = Tween<Offset>(
            begin: const Offset(0, 0.15),
            end: Offset.zero,
          ).animate(CurvedAnimation(
              parent: animation, curve: Curves.easeOutCubic));
          return SlideTransition(position: slide, child: child);
        },
      ),
    );
  }

  @override
  State<SantoMenuBarMoreMenu> createState() => _SantoMenuBarMoreMenuState();
}

class _SantoMenuBarMoreMenuState extends State<SantoMenuBarMoreMenu> {
  SantoCommonConfig get _commonConfig =>
      SantoThemeConfigurator.instance.getConfig().commonConfig;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final itemColor = widget.itemColor ?? _commonConfig.colorTextBase;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            widget.edgeGap, 0, widget.edgeGap, widget.edgeGap + bottomPadding),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.radius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: widget.backgroundColor ?? Colors.white.withAlpha(0xF2),
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 标题栏
                    Row(
                      children: [
                        Expanded(
                          child: widget.titleWidget ??
                              Text(
                                widget.title ?? '',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: _commonConfig.colorTextBase,
                                ),
                              ),
                        ),
                        if (widget.actionText != null)
                          GestureDetector(
                            onTap: () {
                              widget.onActionTap?.call();
                              Navigator.of(context).pop();
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                widget.actionText!,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: _commonConfig.brandPrimary,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // 图标宫格
                    GridView.count(
                      crossAxisCount: widget.columns,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      childAspectRatio: 0.85,
                      children: [
                        for (final item in widget.items)
                          _buildItem(item, itemColor),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(SantoMenuBarMoreMenuItem item, Color itemColor) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context).pop();
        item.onTap?.call();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          item.iconWidget ??
              Icon(item.icon, size: 30, color: itemColor),
          const SizedBox(height: 10),
          Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14, color: itemColor),
          ),
        ],
      ),
    );
  }
}
