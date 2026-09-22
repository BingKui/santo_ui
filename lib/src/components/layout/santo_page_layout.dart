import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:santo_ui/src/components/layout/santo_app_layout_scope.dart';
import 'package:santo_ui/src/components/layout/santo_bottom_safe_area.dart';
import 'package:santo_ui/src/components/navbar/santo_appbar.dart';
import 'package:santo_ui/src/components/refresh/santo_refresh.dart';
import 'package:santo_ui/src/components/space/santo_space.dart';
import 'package:santo_ui/src/theme/configs/santo_common_config.dart';
import 'package:santo_ui/src/theme/santo_theme_configurator.dart';

/// 页面布局:统一承载页面导航栏与内容容器
///
/// * 导航栏可配置:传 [appBar] 可使用任意自定义导航栏(如 [SantoAppBar]),
///   只传 [title] 时用 [SantoAppBar] 快速构建,两者都不传则不显示导航栏,
///   此时内容区自动避开状态栏;
/// * 内容区内边距默认取 [iGapAllMiddle],可用 [padding] 覆盖(顶部状态栏
///   避让始终由布局叠加,不需要业务自己计算:无 [header] 时并入
///   [padding] 的顶部,有 [header] 时由 header 自行避让)。因此内容区的
///   `MediaQuery.padding.top` 统一置 0,避免内容自带的滚动组件(未显式传
///   padding 时)或 `SafeArea` 把状态栏高度再避让一次;
/// * [header] 是标题下方的固定区域(不随内容滚动),用于放搜索框、
///   筛选组件等,撑满宽度、高度自适应、不加内边距;
/// * [enableRefresh] 开启后内置滚动容器由 [SantoRefresh] 承载,
///   下拉刷新回调见 [onRefresh];
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

  /// 内容区滚动控制器,仅 [scrollable] 为 true 时生效(如回顶按钮、锚点联动)
  final ScrollController? scrollController;

  /// 内容区内边距,默认取 [iGapAllMiddle]
  ///
  /// 顶部状态栏避让([header] 为 null 时)始终由布局在传入值之上叠加,
  /// 无需业务自己计算;[header] 不受该内边距影响
  ///
  /// @since v1.2.0
  final EdgeInsetsGeometry? padding;

  /// 页面标题下方的固定区域(不随内容滚动),用于放搜索框、筛选组件等
  ///
  /// 不做任何内边距,直接撑满宽度,高度由内容自适应,
  /// 与滚动内容之间的间距由内容区内边距提供
  ///
  /// @since v1.2.0
  final Widget? header;

  /// 是否支持下拉刷新,默认 false
  ///
  /// 开启后内置滚动容器由 [SantoRefresh] 承载,[onRefresh] 必须同时提供;
  /// [scrollable] 为 false 时内容自带滚动组件,也可开启,由内容承接刷新手势
  ///
  /// @since v1.2.0
  final bool enableRefresh;

  /// 下拉刷新回调,[enableRefresh] 为 true 时必传
  ///
  /// @since v1.2.0
  final Future<void> Function()? onRefresh;

  /// 导航栏左侧活动区域,透传给 [SantoAppBar];仅 [title] 简写构建时生效,
  /// 传 [appBar] 时请在 [appBar] 上自行配置
  ///
  /// @since v1.2.0
  final Widget? appBarLeading;

  /// 导航栏右侧操作区,透传给 [SantoAppBar](Widget 或 List&lt;Widget&gt;);
  /// 仅 [title] 简写构建时生效
  ///
  /// @since v1.2.0
  final dynamic appBarActions;

  /// 导航栏背景色,透传给 [SantoAppBar];仅 [title] 简写构建时生效
  ///
  /// @since v1.2.0
  final Color? appBarBackgroundColor;

  /// 导航栏阴影高度,透传给 [SantoAppBar];仅 [title] 简写构建时生效
  ///
  /// @since v1.2.0
  final double appBarElevation;

  /// 导航栏阴影颜色,透传给 [SantoAppBar];仅 [title] 简写构建时生效
  ///
  /// @since v1.2.0
  final Color? appBarShadowColor;

  /// 导航栏形状,透传给 [SantoAppBar];仅 [title] 简写构建时生效
  ///
  /// @since v1.2.0
  final ShapeBorder? appBarShape;

  /// 导航栏图标主题,透传给 [SantoAppBar];仅 [title] 简写构建时生效
  ///
  /// @since v1.2.0
  final IconThemeData? appBarIconTheme;

  /// 导航栏操作区图标主题,透传给 [SantoAppBar];仅 [title] 简写构建时生效
  ///
  /// @since v1.2.0
  final IconThemeData? appBarActionsIconTheme;

  /// 导航栏系统 UI 样式(状态栏),透传给 [SantoAppBar];仅 [title] 简写构建时生效
  ///
  /// @since v1.2.0
  final SystemUiOverlayStyle? appBarSystemOverlayStyle;

  /// 导航栏返回按钮点击回调,透传给 [SantoAppBar];仅 [title] 简写构建时生效
  ///
  /// @since v1.2.0
  final VoidCallback? appBarBackLeadCallback;

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
    this.padding,
    this.header,
    this.enableRefresh = false,
    this.onRefresh,
    this.appBarLeading,
    this.appBarActions,
    this.appBarBackgroundColor,
    this.appBarElevation = 0,
    this.appBarShadowColor,
    this.appBarShape,
    this.appBarIconTheme,
    this.appBarActionsIconTheme,
    this.appBarSystemOverlayStyle,
    this.appBarBackLeadCallback,
  })  : assert(!enableRefresh || onRefresh != null,
            'enableRefresh 为 true 时必须提供 onRefresh'),
        assert(
            appBarActions == null ||
                appBarActions is Widget ||
                appBarActions is List<Widget>,
            'appBarActions 必须是 Widget 或 List<Widget>'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final gap =
        SantoThemeConfigurator.instance.getConfig().commonConfig.gapMd;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar ?? _buildAppBar(),
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
          // header 区域不加内边距,滚动内容不再叠加状态栏避让
          final contentPadding = (padding ?? iGapAllMiddle)
              .add(EdgeInsets.only(top: header == null ? media.padding.top : 0));

          // 内容自带滚动:把底部安全区并入内容的 MediaQuery,
          // 由内容自己的滚动避让,不在视口底部切出空白
          Widget scrollArea;
          if (!scrollable) {
            scrollArea = Padding(
              padding: contentPadding,
              child: MediaQuery(
                // top 置 0:顶部避让已由 contentPadding(无 header)或 header
                // 自身承担,内容自带的滚动组件再把状态栏高度算一次会多出一条空白
                data: media.copyWith(
                  padding: media.padding.copyWith(
                    top: 0,
                    bottom: bottomAreaInset,
                  ),
                ),
                child: _buildBlocks(gap),
              ),
            );
          } else {
            scrollArea = SingleChildScrollView(
              controller: scrollController,
              // 内容不满一屏时 ClampingScrollPhysics 不接受拖动,
              // 下拉刷新需要 AlwaysScrollableScrollPhysics 才能拉出刷新头;
              // 必须把平台物理挂到 parent 上,否则没有边界约束与回弹模拟,
              // 松手后 pixels 会停在负值,刷新头反复弹出(页面持续抖动)
              physics: enableRefresh
                  ? AlwaysScrollableScrollPhysics(
                      parent: ScrollConfiguration.of(context)
                          .getScrollPhysics(context))
                  : null,
              padding: contentPadding,
              child: MediaQuery(
                // 同非滚动态:顶部避让由 contentPadding / header 承担
                data: media.copyWith(padding: media.padding.copyWith(top: 0)),
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
              ),
            );
          }
          if (enableRefresh) {
            scrollArea = SantoRefresh(onRefresh: onRefresh, child: scrollArea);
          }

          Widget content;
          if (header != null) {
            content = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                header!,
                Expanded(child: scrollArea),
              ],
            );
          } else {
            content = scrollArea;
          }

          if (overlay == null) return content;
          // 挂件自己决定定位方式(Align / Positioned),所以直接作为 Stack 子节点
          return Stack(children: <Widget>[content, overlay!]);
        },
      ),
    );
  }

  /// [title] 简写构建导航栏,透传 appBar 系列配置
  PreferredSizeWidget? _buildAppBar() {
    if (title == null) return null;
    return SantoAppBar(
      title: title,
      leading: appBarLeading,
      actions: appBarActions,
      backgroundColor: appBarBackgroundColor,
      elevation: appBarElevation,
      shadowColor: appBarShadowColor,
      shape: appBarShape,
      iconTheme: appBarIconTheme,
      actionsIconTheme: appBarActionsIconTheme,
      systemOverlayStyle: appBarSystemOverlayStyle,
      backLeadCallback: appBarBackLeadCallback,
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
