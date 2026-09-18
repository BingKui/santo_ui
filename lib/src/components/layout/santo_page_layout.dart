import 'package:flutter/material.dart';

import 'package:santo_ui/src/components/layout/santo_app_layout_scope.dart';
import 'package:santo_ui/src/components/layout/santo_bottom_safe_area.dart';
import 'package:santo_ui/src/components/navbar/santo_appbar.dart';
import 'package:santo_ui/src/components/space/santo_space.dart';
import 'package:santo_ui/src/theme/configs/santo_common_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';

/// 页面布局:统一承载页面导航栏与内容容器
///
/// * 导航栏可配置:传 [appBar] 可使用任意自定义导航栏(如 [SantoAppBar]),
///   只传 [title] 时用 [SantoAppBar] 快速构建,两者都不传则不显示导航栏,
///   此时内容区自动避开状态栏;
/// * 内容区固定内边距取 [iGapAllMiddle],不可单独调整;
/// * [children] 是页面的内容块,块之间由 [SantoSpace] 统一加 `gapMd` 间距,
///   页面不用自己写分隔间距;
/// * 内容默认可滚动([scrollable]),滚动容器自带该内边距(可用 [scrollController]
///   驱动,便于回顶/锚点等联动),底部安全区域
///   ([bottomSafeArea])、[bottomInset] 与 [SantoAppLayout] 悬浮菜单栏占位
///   作为 [SantoBottomSafeArea] 追加在内容末尾,滚到底时最后一段内容
///   正好落在安全区域之上;
/// * 内容自带滚动([scrollable] 为 false,如 ListView/Refresh)时,底部安全区域
///   会并入内容的 `MediaQuery.padding`,滚动组件(未显式传 padding 时)会自动
///   避让,不会在视口底部切出一条空白;内容不是滚动组件时,请自行在末尾
///   放一个 [SantoBottomSafeArea];该模式下块间距同样由 [SantoSpace] 提供,
///   需要占满剩余高度的块请自行用 `Expanded` 包裹。
///
/// 页面级挂件,按需选:
/// * [floatingActionButton] / [floatingActionButtonLocation]:交给 Scaffold 的
///   悬浮按钮(如右下角操作按钮);
/// * [bottomNavigationBar]:占据底部空间的常驻栏(如停靠样式的 `SantoMenuBar`、
///   `SantoActionBar`),内容区自动退到栏上方;
/// * [overlay]:叠在内容区之上的控件,直接作为 `Stack` 子节点插入,可自行用
///   `Align` / `Positioned` 定位(如悬浮菜单栏、浮层面板、`SantoFab.positioned`);
///   内容会被遮住,记得同时用 [bottomInset] 给内容留出避让空间。
///
/// 示例:
/// ```dart
/// SantoPageLayout(
///   title: '订单详情',
///   children: <Widget>[
///     SantoSection(title: '基础信息', child: ...),
///     SantoSection(title: '金额', child: ...),
///   ],
/// )
/// ```
class SantoPageLayout extends StatelessWidget {
  /// 页面内容块,块之间统一加 `commonConfig.gapMd` 间距
  final List<Widget> children;

  /// 页面导航栏;设置后 [title] 失效
  final PreferredSizeWidget? appBar;

  /// 导航栏标题简写:未传 [appBar] 时用它构建 [SantoAppBar]
  final String? title;

  /// 内容是否可滚动,默认 true;内容自带滚动(如 ListView/Refresh)时传 false
  final bool scrollable;

  /// 内容区底部是否预留安全区域,默认 true
  final bool bottomSafeArea;

  /// 内容区底部额外留白(在安全区域之上叠加),默认 0
  final double bottomInset;

  /// 页面背景色,默认跟随主题
  final Color? backgroundColor;

  /// 悬浮按钮,交给 Scaffold 承载;需要 `Positioned` 定位的挂件用 [overlay]
  final Widget? floatingActionButton;

  /// 悬浮按钮位置
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// 底部常驻栏,占据底部空间,内容区在其上方
  final Widget? bottomNavigationBar;

  /// 叠在内容区之上的控件,直接作为 Stack 子节点插入
  final Widget? overlay;

  /// 内容滚动控制器,仅 [scrollable] 为 true 时生效(如回顶按钮、锚点联动)
  final ScrollController? scrollController;

  const SantoPageLayout({
    Key? key,
    required this.children,
    this.appBar,
    this.title,
    this.scrollable = true,
    this.bottomSafeArea = true,
    this.bottomInset = 0,
    this.backgroundColor,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.overlay,
    this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gap =
        SantoThemeConfigurator.instance.getConfig().commonConfig.gapMd;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar ?? (title == null ? null : SantoAppBar(title: title)),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      body: Builder(
        builder: (context) {
          // 有导航栏时 Scaffold 已把顶部安全区域从 body 的 MediaQuery 中移除
          final media = MediaQuery.of(context);
          final bottomAreaInset = (bottomSafeArea ? media.padding.bottom : 0.0) +
              bottomInset +
              SantoAppLayoutScope.bottomBarInsetOf(context);
          final contentPadding =
              iGapAllMiddle + EdgeInsets.only(top: media.padding.top);

          // 内容自带滚动:把底部安全区并入内容的 MediaQuery,
          // 由内容自己的滚动避让,不在视口底部切出空白
          Widget content;
          if (!scrollable) {
            content = Padding(
              padding: contentPadding,
              child: MediaQuery(
                data: media.copyWith(
                  padding: media.padding.copyWith(bottom: bottomAreaInset),
                ),
                child: _buildBlocks(gap),
              ),
            );
          } else {
            content = SingleChildScrollView(
              controller: scrollController,
              padding: contentPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildBlocks(gap),
                  SantoBottomSafeArea(
                    safeArea: false,
                    extra: bottomAreaInset,
                  ),
                ],
              ),
            );
          }

          if (overlay == null) return content;
          // 挂件自己决定定位方式(Align / Positioned),所以直接作为 Stack 子节点
          return Stack(children: <Widget>[content, overlay!]);
        },
      ),
    );
  }

  /// 内容块:竖向排布并统一加间距;只有一块时直接返回,避免多余嵌套
  Widget _buildBlocks(double gap) {
    if (children.length == 1) return children.first;
    return SantoSpace(
      direction: SantoSpaceDirection.vertical,
      customSize: gap,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}
