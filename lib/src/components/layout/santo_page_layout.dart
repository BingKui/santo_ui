import 'package:flutter/material.dart';

import 'package:santo_ui/src/components/layout/santo_app_layout_scope.dart';
import 'package:santo_ui/src/components/layout/santo_bottom_safe_area.dart';
import 'package:santo_ui/src/components/navbar/santo_appbar.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';

/// 页面布局:统一承载页面导航栏与内容容器
///
/// * 导航栏可配置:传 [appBar] 可使用任意自定义导航栏(如 [SantoAppBar]),
///   只传 [title] 时用 [SantoAppBar] 快速构建,两者都不传则不显示导航栏,
///   此时内容区自动避开状态栏;
/// * 内容区固定内边距,取主题 `commonConfig.pageGap`(默认 12),不可单独调整;
/// * 内容默认可滚动([scrollable]),滚动容器自带该内边距,底部安全区域
///   ([bottomSafeArea])、[bottomInset] 与 [SantoAppLayout] 悬浮菜单栏占位
///   作为 [SantoBottomSafeArea] 追加在内容末尾,滚到底时最后一段内容
///   正好落在安全区域之上;
/// * 内容自带滚动([scrollable] 为 false,如 ListView/Refresh)时,底部安全区域
///   会并入内容的 `MediaQuery.padding`,滚动组件(未显式传 padding 时)会自动
///   避让,不会在视口底部切出一条空白;内容不是滚动组件时,请自行在末尾
///   放一个 [SantoBottomSafeArea]。
///
/// 示例:
/// ```dart
/// SantoPageLayout(
///   title: '订单详情',
///   child: Column(children: [...]),
/// )
/// ```
class SantoPageLayout extends StatelessWidget {
  /// 页面内容
  final Widget child;

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

  const SantoPageLayout({
    Key? key,
    required this.child,
    this.appBar,
    this.title,
    this.scrollable = true,
    this.bottomSafeArea = true,
    this.bottomInset = 0,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gap =
        SantoThemeConfigurator.instance.getConfig().commonConfig.pageGap;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar ?? (title == null ? null : SantoAppBar(title: title)),
      body: Builder(
        builder: (context) {
          // 有导航栏时 Scaffold 已把顶部安全区域从 body 的 MediaQuery 中移除
          final media = MediaQuery.of(context);
          final bottomAreaInset = (bottomSafeArea ? media.padding.bottom : 0.0) +
              bottomInset +
              SantoAppLayoutScope.bottomBarInsetOf(context);
          final contentPadding =
              EdgeInsets.all(gap) + EdgeInsets.only(top: media.padding.top);

          // 内容自带滚动:把底部安全区并入内容的 MediaQuery,
          // 由内容自己的滚动避让,不在视口底部切出空白
          if (!scrollable) {
            return Padding(
              padding: contentPadding,
              child: MediaQuery(
                data: media.copyWith(
                  padding: media.padding.copyWith(bottom: bottomAreaInset),
                ),
                child: child,
              ),
            );
          }
          return SingleChildScrollView(
            padding: contentPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                child,
                SantoBottomSafeArea(
                  safeArea: false,
                  extra: bottomAreaInset,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
