import 'package:flutter/material.dart';

import 'package:santo_ui/src/components/layout/santo_app_layout_scope.dart';
import 'package:santo_ui/src/components/navbar/santo_appbar.dart';

/// 内容区默认内边距
const EdgeInsets kSantoPageLayoutPadding = EdgeInsets.all(12);

/// 页面布局:统一承载页面导航栏与内容容器
///
/// * 导航栏可配置:传 [appBar] 可使用任意自定义导航栏(如 [SantoAppBar]),
///   只传 [title] 时用 [SantoAppBar] 快速构建,两者都不传则不显示导航栏,
///   此时内容区自动避开状态栏;
/// * 内容默认可滚动([scrollable]),滚动容器自带 [padding];
/// * 内容区底部自动预留底部安全区域([bottomSafeArea])与 [bottomInset],
///   在 [SantoAppLayout] 中还会自动预留悬浮菜单栏占位。
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

  /// 内容内边距,默认 [kSantoPageLayoutPadding](四边 12)
  final EdgeInsets padding;

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
    this.padding = kSantoPageLayoutPadding,
    this.scrollable = true,
    this.bottomSafeArea = true,
    this.bottomInset = 0,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar ?? (title == null ? null : SantoAppBar(title: title)),
      body: Builder(
        builder: (context) {
          // 有导航栏时 Scaffold 已把顶部安全区域从 body 的 MediaQuery 中移除
          final media = MediaQuery.of(context);
          final bottom = (bottomSafeArea ? media.padding.bottom : 0.0) +
              bottomInset +
              SantoAppLayoutScope.bottomBarInsetOf(context);
          final contentPadding =
              padding + EdgeInsets.only(top: media.padding.top, bottom: bottom);

          if (!scrollable) {
            return Padding(padding: contentPadding, child: child);
          }
          return SingleChildScrollView(
            padding: contentPadding,
            child: child,
          );
        },
      ),
    );
  }
}
