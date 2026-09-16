import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:santo_ui/src/theme/configs/santo_common_config.dart';
import 'package:santo_ui/src/components/menu_bar/santo_menu_bar_more_menu.dart';

/// 菜单栏样式
enum SantoMenuBarStyle {
  /// 默认样式:纯色背景,顶部左右圆角,贴边停靠
  docked,

  /// 悬浮样式:毛玻璃背景,圆角容器与屏幕边缘保持 [SantoMenuBar.gap] 间距
  floating,
}

/// 底部标签项
class SantoMenuBarItem {
  /// 标签文本
  final String? text;

  /// 选中时图标
  final Widget? selectedIcon;

  /// 未选中时图标;未设置则使用 [selectedIcon]
  final Widget? unselectedIcon;

  /// 点击回调
  final GestureTapCallback? onTap;

  /// 是否显示红点
  final bool showBadge;

  /// 自定义徽标(如数字角标),设置后替代红点
  final Widget? badge;

  const SantoMenuBarItem({
    this.text,
    this.selectedIcon,
    this.unselectedIcon,
    this.onTap,
    this.showBadge = false,
    this.badge,
  });
}

/// 菜单栏
///
/// 两种样式:
/// * [SantoMenuBarStyle.docked] 默认停靠:纯色背景(默认白色),
///   顶部左右圆角,底部贴边。
/// * [SantoMenuBarStyle.floating] 悬浮:透明毛玻璃圆角容器,
///   与屏幕边缘保持 [gap] 间距,每个标签项为大圆角胶囊。
///
/// 示例:
/// ```dart
/// SantoMenuBar(
///   style: SantoMenuBarStyle.floating,
///   gap: 12,
///   items: [
///     SantoMenuBarItem(text: '首页', selectedIcon: Icon(Icons.home)),
///     SantoMenuBarItem(text: '我的', selectedIcon: Icon(Icons.person)),
///   ],
/// )
/// ```
class SantoMenuBar extends StatefulWidget {
  /// 标签栏样式,默认停靠样式
  final SantoMenuBarStyle style;

  /// 标签项
  final List<SantoMenuBarItem> items;

  /// 当前选中索引(受控);不传则内部维护
  final int? currentIndex;

  /// 选中索引变化回调
  final ValueChanged<int>? onChange;

  /// 栏高度,默认 docked 56 / floating 64
  final double? barHeight;

  /// 背景颜色;docked 默认白色,floating 默认半透明白毛玻璃
  final Color? backgroundColor;

  /// docked 样式顶部左右圆角,默认 12
  final double topRadius;

  /// docked 样式是否显示顶部分割线,默认 true
  final bool showTopDivider;

  /// floating 样式容器与屏幕边缘(左/右/下)的距离,默认 12
  final double gap;

  /// floating 样式容器大圆角,默认 28
  final double containerRadius;

  /// floating 样式每个标签项的大圆角,默认 20
  final double itemRadius;

  /// floating 样式选中项背景色,默认主色
  final Color? itemSelectedBgColor;

  /// 选中文字颜色,默认主色(docked)/白色(floating)
  final Color? selectedTextColor;

  /// 未选中文字颜色,默认次要文字色
  final Color? unselectedTextColor;

  /// 是否使用底部安全区域,默认 true
  final bool useSafeArea;

  /// 是否开启"更多"标签:开启且 [moreMenu] 配置了菜单数据时才展示
  final bool showMoreMenu;

  /// "更多"菜单配置(标题/右上角操作/菜单项)
  final SantoMenuBarMoreMenu? moreMenu;

  /// 切换动画时长
  final Duration duration;

  const SantoMenuBar({
    Key? key,
    this.style = SantoMenuBarStyle.docked,
    required this.items,
    this.currentIndex,
    this.onChange,
    this.barHeight,
    this.backgroundColor,
    this.topRadius = 12,
    this.showTopDivider = true,
    this.gap = 12,
    this.containerRadius = 28,
    this.itemRadius = 20,
    this.itemSelectedBgColor,
    this.selectedTextColor,
    this.unselectedTextColor,
    this.useSafeArea = true,
    this.duration = const Duration(milliseconds: 200),
    this.showMoreMenu = false,
    this.moreMenu,
  })  : assert(items.length > 0, 'items 不能为空'),
        super(key: key);

  /// 组合后的标签项:开启且配置了菜单数据时,末尾追加"更多"标签
  List<SantoMenuBarItem> get effectiveItems {
    final moreEnabled = showMoreMenu &&
        moreMenu != null &&
        moreMenu!.items.isNotEmpty;
    if (!moreEnabled) return items;
    return [
      ...items,
      SantoMenuBarItem(
        text: '更多',
        selectedIcon: const Icon(Icons.apps),
        unselectedIcon: const Icon(Icons.apps_outlined),
      ),
    ];
  }

  @override
  State<SantoMenuBar> createState() => _SantoMenuBarState();
}

class _SantoMenuBarState extends State<SantoMenuBar> {
  late int _currentIndex;

  SantoCommonConfig get _commonConfig =>
      SantoThemeConfigurator.instance.getConfig().commonConfig;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex ?? 0;
  }

  @override
  void didUpdateWidget(covariant SantoMenuBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != null &&
        widget.currentIndex != oldWidget.currentIndex &&
        widget.currentIndex != _currentIndex) {
      _currentIndex = widget.currentIndex!;
    }
  }

  bool get _moreEnabled =>
      widget.showMoreMenu &&
      widget.moreMenu != null &&
      widget.moreMenu!.items.isNotEmpty;

  /// 更多标签在 effectiveItems 中的索引
  int get _moreIndex => widget.items.length;

  void _select(int index) {
    final items = widget.effectiveItems;
    if (_moreEnabled && index == _moreIndex) {
      // 更多标签:不切换选中,弹出菜单面板
      SantoMenuBarMoreMenu.open(context, menu: widget.moreMenu!);
      return;
    }
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
    widget.onChange?.call(index);
    items[index].onTap?.call();
  }

  Color get _selectedColor =>
      widget.selectedTextColor ??
      (widget.style == SantoMenuBarStyle.floating
          ? Colors.white
          : _commonConfig.brandPrimary);

  Color get _unselectedColor =>
      widget.unselectedTextColor ?? _commonConfig.colorTextSecondary;

  double get _barHeight =>
      widget.barHeight ??
      (widget.style == SantoMenuBarStyle.floating ? 64 : 56);

  @override
  Widget build(BuildContext context) {
    return widget.style == SantoMenuBarStyle.floating
        ? _buildFloating(context)
        : _buildDocked(context);
  }

  /// 默认停靠样式:纯色背景 + 顶部圆角
  Widget _buildDocked(BuildContext context) {
    Widget bar = Container(
      height: _barHeight,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(widget.topRadius),
        ),
      ),
      child: Row(
        children: [
          for (int i = 0; i < widget.effectiveItems.length; i++)
            Expanded(child: _buildItem(context, i)),
        ],
      ),
    );
    if (widget.showTopDivider) {
      bar = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              height: 0.5, color: _commonConfig.dividerColorBase),
          bar,
        ],
      );
    }
    if (widget.useSafeArea) {
      bar = SafeArea(top: false, child: bar);
    }
    return Material(color: Colors.transparent, child: bar);
  }

  /// 悬浮样式:毛玻璃圆角容器 + 圆角标签项
  Widget _buildFloating(BuildContext context) {
    final bottomPadding =
        widget.useSafeArea ? MediaQuery.of(context).padding.bottom : 0.0;
    Widget bar = ClipRRect(
      borderRadius: BorderRadius.circular(widget.containerRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: _barHeight,
          color:
              widget.backgroundColor ?? Colors.white.withAlpha(0xCC),
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              for (int i = 0; i < widget.effectiveItems.length; i++)
                Expanded(child: _buildFloatingItem(context, i)),
            ],
          ),
        ),
      ),
    );
    return Padding(
      padding: EdgeInsets.fromLTRB(widget.gap, 0, widget.gap,
          widget.gap + bottomPadding),
      child: Material(
        color: Colors.transparent,
        child: bar,
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final item = widget.effectiveItems[index];
    final selected = index == _currentIndex;
    final color = selected ? _selectedColor : _unselectedColor;

    Widget? icon;
    if (selected && item.selectedIcon != null) {
      icon = item.selectedIcon;
    } else if (item.unselectedIcon != null) {
      icon = item.unselectedIcon;
    } else {
      icon = item.selectedIcon;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _select(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: _wrapBadge(icon, item, selected),
            ),
          if (item.text != null)
            Text(
              item.text!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                color: color,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFloatingItem(BuildContext context, int index) {
    final item = widget.effectiveItems[index];
    final selected = index == _currentIndex;
    final color = selected ? _selectedColor : _unselectedColor;

    Widget? icon;
    if (selected && item.selectedIcon != null) {
      icon = item.selectedIcon;
    } else if (item.unselectedIcon != null) {
      icon = item.unselectedIcon;
    } else {
      icon = item.selectedIcon;
    }
    if (icon != null) {
      icon = IconTheme.merge(
        data: IconThemeData(color: color),
        child: icon,
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _select(index),
      child: AnimatedContainer(
        duration: widget.duration,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: selected
              ? (widget.itemSelectedBgColor ?? _commonConfig.brandPrimary)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(widget.itemRadius),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: _wrapBadge(icon, item, selected),
              ),
            if (item.text != null)
              Text(
                item.text!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                  color: color,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 图标红点/徽标包装
  Widget _wrapBadge(Widget icon, SantoMenuBarItem item, bool selected) {
    if (!item.showBadge && item.badge == null) return icon;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        icon,
        Positioned(
          right: -6,
          top: -4,
          child: item.badge ??
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _commonConfig.brandError,
                  shape: BoxShape.circle,
                ),
              ),
        ),
      ],
    );
  }
}
