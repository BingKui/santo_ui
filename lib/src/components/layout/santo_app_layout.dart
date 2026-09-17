import 'package:flutter/material.dart';

import 'package:santo_ui/src/components/layout/santo_app_layout_scope.dart';
import 'package:santo_ui/src/components/menu_bar/santo_menu_bar.dart';
import 'package:santo_ui/src/components/menu_bar/santo_menu_bar_more_menu.dart';

/// [SantoAppLayout] 的菜单项:菜单文案/图标 + 该菜单对应的页面
class SantoAppLayoutItem {
  /// 菜单文案
  final String? text;

  /// 选中时图标
  final Widget? selectedIcon;

  /// 未选中时图标;未设置则使用 [selectedIcon]
  final Widget? unselectedIcon;

  /// 是否显示红点
  final bool showBadge;

  /// 自定义徽标(如数字角标),设置后替代红点
  final Widget? badge;

  /// 该菜单对应的页面
  final Widget page;

  const SantoAppLayoutItem({
    this.text,
    this.selectedIcon,
    this.unselectedIcon,
    this.showBadge = false,
    this.badge,
    required this.page,
  });
}

/// [SantoAppLayout] "更多"菜单项:点击后按页面地址跳转
class SantoAppLayoutMoreItem {
  /// 菜单文案
  final String label;

  /// 图标
  final IconData? icon;

  /// 自定义图标控件,设置后 [icon] 失效
  final Widget? iconWidget;

  /// 页面地址(命名路由),由宿主 App 在 MaterialApp.routes/onGenerateRoute 中注册
  final String routeName;

  /// 路由参数,跳转时传给目标页面
  final Object? arguments;

  const SantoAppLayoutMoreItem({
    required this.label,
    this.icon,
    this.iconWidget,
    required this.routeName,
    this.arguments,
  });
}

/// [SantoAppLayout] 的"更多"菜单配置:标题 + 页面地址宫格
class SantoAppLayoutMoreMenu {
  /// 面板标题
  final String? title;

  /// 菜单项
  final List<SantoAppLayoutMoreItem> items;

  const SantoAppLayoutMoreMenu({this.title, required this.items});
}

/// 应用布局:底部菜单栏 + 每个菜单对应的页面
///
/// * 页面由 [IndexedStack] 承载,切换菜单时各页面状态(滚动位置、输入内容)保留;
/// * [SantoMenuBarStyle.floating] 悬浮样式下菜单栏浮在内容之上,页面内容可以
///   从毛玻璃容器下方穿过,[SantoPageLayout] 会自动预留菜单栏占位;
///   [SantoMenuBarStyle.docked] 停靠样式下菜单栏占据底部空间,内容区在其上方;
/// * "更多"菜单项按 [SantoAppLayoutMoreItem.routeName] 跳转命名路由,
///   未配置 [moreMenu] 时不会出现"更多"标签。
///
/// 示例:
/// ```dart
/// SantoAppLayout(
///   items: [
///     SantoAppLayoutItem(
///       text: '首页',
///       selectedIcon: const Icon(Icons.home_filled),
///       page: SantoPageLayout(
///         title: '首页',
///         children: <Widget>[...],
///       ),
///     ),
///   ],
///   moreMenu: const SantoAppLayoutMoreMenu(
///     title: '更多',
///     items: [
///       SantoAppLayoutMoreItem(
///         label: '通知',
///         icon: Icons.notifications_none,
///         routeName: '/notice',
///       ),
///     ],
///   ),
/// )
/// ```
class SantoAppLayout extends StatefulWidget {
  /// 菜单项(每项含菜单文案/图标与对应页面)
  final List<SantoAppLayoutItem> items;

  /// "更多"菜单;不配置或菜单项为空时不展示"更多"标签
  final SantoAppLayoutMoreMenu? moreMenu;

  /// 当前选中的菜单索引(受控);不传则内部维护
  final int? currentIndex;

  /// 菜单切换回调
  final ValueChanged<int>? onChanged;

  /// 菜单栏样式,默认悬浮
  final SantoMenuBarStyle style;

  /// 菜单栏高度,默认 docked 56 / floating 64
  final double? barHeight;

  /// 悬浮样式下菜单栏与屏幕边缘(左/右/下)的距离,默认 12
  final double gap;

  /// 页面背景色,默认跟随主题
  final Color? backgroundColor;

  /// 菜单栏背景色;悬浮样式默认半透明白毛玻璃
  final Color? barBackgroundColor;

  /// 悬浮样式选中项背景色,默认主色
  final Color? itemSelectedBgColor;

  /// 选中文字颜色
  final Color? selectedTextColor;

  /// 未选中文字颜色,默认次要文字色
  final Color? unselectedTextColor;

  /// 是否使用底部安全区域,默认 true
  final bool useSafeArea;

  /// 菜单切换动画时长
  final Duration duration;

  const SantoAppLayout({
    Key? key,
    required this.items,
    this.moreMenu,
    this.currentIndex,
    this.onChanged,
    this.style = SantoMenuBarStyle.floating,
    this.barHeight,
    this.gap = 12,
    this.backgroundColor,
    this.barBackgroundColor,
    this.itemSelectedBgColor,
    this.selectedTextColor,
    this.unselectedTextColor,
    this.useSafeArea = true,
    this.duration = const Duration(milliseconds: 200),
  })  : assert(items.length > 0, 'items 不能为空'),
        super(key: key);

  @override
  State<SantoAppLayout> createState() => _SantoAppLayoutState();
}

class _SantoAppLayoutState extends State<SantoAppLayout> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex ?? 0;
  }

  @override
  void didUpdateWidget(covariant SantoAppLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != null &&
        widget.currentIndex != oldWidget.currentIndex &&
        widget.currentIndex != _currentIndex) {
      _currentIndex = widget.currentIndex!;
    }
  }

  bool get _floating => widget.style == SantoMenuBarStyle.floating;

  double get _barHeight =>
      widget.barHeight ?? (_floating ? 64 : 56);

  bool get _moreEnabled =>
      widget.moreMenu != null && widget.moreMenu!.items.isNotEmpty;

  void _handleChange(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
    widget.onChanged?.call(index);
  }

  /// 把"页面地址"配置转成 MenuBar 的更多菜单:点击后跳转命名路由
  SantoMenuBarMoreMenu? _buildMoreMenu(BuildContext context) {
    final config = widget.moreMenu;
    if (config == null) return null;
    return SantoMenuBarMoreMenu(
      title: config.title,
      items: [
        for (final item in config.items)
          SantoMenuBarMoreMenuItem(
            label: item.label,
            icon: item.icon,
            iconWidget: item.iconWidget,
            onTap: () => Navigator.of(context).pushNamed(
              item.routeName,
              arguments: item.arguments,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = IndexedStack(
      index: _currentIndex.clamp(0, widget.items.length - 1),
      children: [for (final item in widget.items) item.page],
    );

    final bar = SantoMenuBar(
      style: widget.style,
      items: [
        for (final item in widget.items)
          SantoMenuBarItem(
            text: item.text,
            selectedIcon: item.selectedIcon,
            unselectedIcon: item.unselectedIcon,
            showBadge: item.showBadge,
            badge: item.badge,
          ),
      ],
      currentIndex: _currentIndex,
      onChanged: _handleChange,
      barHeight: widget.barHeight,
      gap: widget.gap,
      backgroundColor: widget.barBackgroundColor,
      itemSelectedBgColor: widget.itemSelectedBgColor,
      selectedTextColor: widget.selectedTextColor,
      unselectedTextColor: widget.unselectedTextColor,
      useSafeArea: widget.useSafeArea,
      duration: widget.duration,
      showMoreMenu: _moreEnabled,
      moreMenu: _buildMoreMenu(context),
    );

    // 停靠样式:菜单栏占据底部空间,内容区整体在其上方
    if (!_floating) {
      return Scaffold(
        backgroundColor: widget.backgroundColor,
        body: pages,
        bottomNavigationBar: bar,
      );
    }

    // 悬浮样式:菜单栏浮在内容之上,注入占位供页面内容区避让
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: SantoAppLayoutScope(
        bottomBarInset: _barHeight + widget.gap,
        child: Stack(
          children: [
            Positioned.fill(child: pages),
            Positioned(left: 0, right: 0, bottom: 0, child: bar),
          ],
        ),
      ),
    );
  }
}
