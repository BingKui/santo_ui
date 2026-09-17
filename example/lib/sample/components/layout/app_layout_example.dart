import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// AppLayout 示例「更多」菜单用到的页面地址
class AppLayoutDemoRoutes {
  AppLayoutDemoRoutes._();

  static const String notice = '/app_layout/notice';
  static const String schedule = '/app_layout/schedule';
  static const String report = '/app_layout/report';
}

/// SantoAppLayout 应用布局示例:底部悬浮菜单栏 + 三个菜单对应页面 + 更多菜单
class AppLayoutExample extends StatelessWidget {
  const AppLayoutExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SantoAppLayout(
      moreMenu: const SantoAppLayoutMoreMenu(
        title: '更多',
        items: <SantoAppLayoutMoreItem>[
          SantoAppLayoutMoreItem(
            label: '通知',
            icon: Icons.notifications_none,
            routeName: AppLayoutDemoRoutes.notice,
          ),
          SantoAppLayoutMoreItem(
            label: '日程',
            icon: Icons.event_note_outlined,
            routeName: AppLayoutDemoRoutes.schedule,
          ),
          SantoAppLayoutMoreItem(
            label: '报表',
            icon: Icons.bar_chart_outlined,
            routeName: AppLayoutDemoRoutes.report,
          ),
        ],
      ),
      items: const <SantoAppLayoutItem>[
        SantoAppLayoutItem(
          text: '首页',
          selectedIcon: Icon(Icons.home_filled),
          unselectedIcon: Icon(Icons.home_outlined),
          page: _AppLayoutHomePage(),
        ),
        SantoAppLayoutItem(
          text: '发现',
          selectedIcon: Icon(Icons.travel_explore),
          unselectedIcon: Icon(Icons.explore_outlined),
          page: _AppLayoutDiscoverPage(),
        ),
        SantoAppLayoutItem(
          text: '我的',
          selectedIcon: Icon(Icons.person),
          unselectedIcon: Icon(Icons.person_outline),
          page: _AppLayoutProfilePage(),
        ),
      ],
    );
  }
}

/// 「更多」菜单的目标页:按 routeName 注册在示例 App 的路由表里
class AppLayoutDemoRoutePage extends StatelessWidget {
  final String title;

  const AppLayoutDemoRoutePage({Key? key, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeName = ModalRoute.of(context)?.settings.name;
    return SantoPageLayout(
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 12),
          SantoSection(
            title: '页面地址跳转',
            description: '「更多」菜单项按 routeName 跳转,路由由宿主 App 注册',
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '当前页面地址:${routeName ?? ''}',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 首页:内容从悬浮菜单栏下方穿过,滚动到底部不被遮挡
class _AppLayoutHomePage extends StatelessWidget {
  const _AppLayoutHomePage();

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      // padding 置 0,分块间距交给 Section 自身的 margin
      padding: EdgeInsets.zero,
      appBar: SantoAppBar(title: '首页'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 12),
          SantoSection(
            title: 'AppLayout 应用布局',
            description: '底部悬浮菜单栏 + 每个菜单对应的页面,切换菜单时各页面状态保留',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                for (int i = 1; i <= 14; i++) _card('首页内容卡片 $i'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 发现:使用 PageLayout 默认的四边 12 内边距
class _AppLayoutDiscoverPage extends StatelessWidget {
  const _AppLayoutDiscoverPage();

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      appBar: SantoAppBar(title: '发现'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SantoSection(
            // 本页用默认 padding 12,Section 去掉左右边距避免叠加
            margin: const EdgeInsets.only(bottom: 12),
            title: '悬浮菜单栏占位',
            description: '内容延伸到底部,PageLayout 自动预留栏高 + gap,最后一张卡片不会被遮住',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                for (int i = 1; i <= 12; i++) _card('发现内容卡片 $i'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 我的:简单的个人页,用于对比不同标签页的独立状态
class _AppLayoutProfilePage extends StatelessWidget {
  const _AppLayoutProfilePage();

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      padding: EdgeInsets.zero,
      appBar: SantoAppBar(title: '我的'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 12),
          Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: const <Widget>[
                Icon(Icons.account_circle, size: 48, color: Color(0xFFBFC3CC)),
                SizedBox(width: 12),
                Text('Santo 用户', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          SantoSection(
            title: '独立页面状态',
            description: 'IndexedStack 承载各页面,切换到其它标签再切回来时滚动位置不丢失',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                for (int i = 1; i <= 10; i++) _card('我的内容卡片 $i'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _card(String text) {
  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(text, style: const TextStyle(fontSize: 14)),
  );
}
