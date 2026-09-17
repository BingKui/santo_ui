

import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/list_item.dart';
import 'package:flutter/material.dart';

import 'santo_tabbar_sticky_example.dart';

class SantoTabExample extends StatefulWidget {
  @override
  _SantoTabExampleState createState() => _SantoTabExampleState();
}

class _SantoTabExampleState extends State<SantoTabExample>
    with TickerProviderStateMixin {
  SantoCloseWindowController? closeWindowController;

  @override
  void initState() {
    super.initState();
    closeWindowController = SantoCloseWindowController();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: SantoPageLayout(          title: 'SantoTab示例',
          children: <Widget>[
            ListItem(
              title: "SantoTabBarBadge实现",
            ),
            SantoSection(
              title: '吸顶 Tab',
              description: '点击按钮进入独立页面，查看 Tab 点击后自动收起的吸顶效果',
              child: Center(
                child: SantoNormalButton.outline(
                  onTap: () {
                    Navigator.of(context)
                        .push(new MaterialPageRoute(builder: (context) {
                      return SantoTabbarStickyExample();
                    }));
                  },
                  text: "Tabbar点击自动收起example",
                ),
              ),
            ),
            SantoSection(
              title: '展开更多',
              description: 'showMore 开启更多入口，moreWindowText 为弹窗标题',
              child: _createExpandedMoreTabbarWidgets(),
            ),
            SantoSection(
              title: '基础用法',
              description: '4 个 Tab 均分宽度，每项带 12px 圆角底色，选中项底色加深',
              child: _createStableTabbar4Widgets(),
            ),
            SantoSection(
              title: '徽标样式',
              description: 'badgeText、badgeNum、showRedBadge 对应三种徽标',
              child: _createStableTabbarWidgets(),
            ),
            SantoSection(
              title: '多 Tab 滚动',
              description: 'Tab 数量超过 4 个时自动横向滚动，徽标类型可混合',
              child: _createTabbarBadgeWidgets(),
            ),
            SantoSection(
              title: '超长数字徽标',
              description: 'badgeNum 超过 99 时统一展示为 99+',
              child: _createStableTabbarBadgeWidgets(),
            ),
            SantoSection(
              title: '序号与分割线',
              description: 'hasIndex 在 Tab 上方显示序号，hasDivider 绘制分割线',
              child: _createDividerTabbarWidgets(),
            ),
            SantoSection(
              title: '自定义 Tab 宽度',
              description: 'tabWidth 固定每个 Tab 宽度，总宽超出屏幕后横向滚动',
              child: _createCustomTabbarWidgets(),
            ),
            SantoSection(
              title: '顶部标签',
              description: 'hasIndex 开启后 topText 显示在 Tab 上方，颜色可自定义',
              child: _createTopTabbarWidgets(),
            ),
            SantoSection(
              title: '顶部标签带数字',
              description: 'topText 与 badgeNum 同时使用，徽标显示在 Tab 右上角',
              child: _createTopTabbarCountWidgets(),
            ),
            SantoSection(
              title: 'origin 模式',
              description: 'mode 为 origin 时按原始 TabBar 方式布局，不等分宽度',
              child: _createOriginWidgets(),
            ),
          ],
        ),
        onWillPop: () {
          if (closeWindowController!.isShow) {
            closeWindowController!.closeMoreWindow();
            return Future.value(false);
          }
          return Future.value(true);
        });
  }

  _createExpandedMoreTabbarWidgets() {
    var tabs = <BadgeTab>[];
    tabs.add(BadgeTab(text: "业务一"));
    tabs.add(BadgeTab(text: "业务二"));
    tabs.add(BadgeTab(text: "业务三"));
    tabs.add(BadgeTab(text: "业务四"));
    tabs.add(BadgeTab(text: "业务五"));
    TabController tabController =
        TabController(length: tabs.length, vsync: this);
    return SantoTabBar(
      controller: tabController,
      tabs: tabs,
      showMore: true,
      moreWindowText: "Tabs描述",
      closeController: closeWindowController,
      onTap: (state, index) {
        state.refreshBadgeState(index);
      },
    );
  }

  _createStableTabbar4Widgets() {
    var tabs = <BadgeTab>[];
    tabs.add(BadgeTab(text: "业务一"));
    tabs.add(BadgeTab(text: "业务二"));
    tabs.add(BadgeTab(text: "业务三"));
    tabs.add(BadgeTab(text: "业务四"));
    TabController tabController =
        TabController(length: tabs.length, vsync: this);
    return SantoTabBar(
      controller: tabController,
      tabs: tabs,
      onTap: (state, index) {
        state.refreshBadgeState(index);
      },
    );
  }

  _createStableTabbarWidgets() {
    var tabs = <BadgeTab>[];
    tabs.add(BadgeTab(text: "特殊业务详情一", badgeText: "新"));
    tabs.add(BadgeTab(text: "业务二", badgeNum: 22));
    tabs.add(BadgeTab(text: "业务三", badgeNum: 11));
    tabs.add(BadgeTab(text: "业务四", showRedBadge: true));
    TabController tabController =
        TabController(length: tabs.length, vsync: this);
    return SantoTabBar(
      controller: tabController,
      tabs: tabs,
      mode: SantoTabBarBadgeMode.origin,
      isScroll: false,
      labelPadding: EdgeInsets.only(left: 20, right: 12),
      indicatorPadding: EdgeInsets.only(left: 10),
      onTap: (state, index) {
        SantoToast.show("点击了", context);
      },
    );
  }

  _createTabbarBadgeWidgets() {
    var tabs = <BadgeTab>[];
    tabs.add(BadgeTab(text: "业务一", badgeText: "新"));
    tabs.add(BadgeTab(text: "业务二", badgeNum: 22));
    tabs.add(BadgeTab(text: "业务三", badgeNum: 11));
    tabs.add(BadgeTab(text: "业务四", showRedBadge: true));
    tabs.add(BadgeTab(text: "业务五", badgeNum: 12));
    tabs.add(BadgeTab(text: "业务六", badgeNum: 30));
    tabs.add(BadgeTab(text: "业务七"));
    tabs.add(BadgeTab(text: "业务八", badgeNum: 23));
    tabs.add(BadgeTab(text: "业务九", badgeNum: 43));
    TabController tabController =
        TabController(length: tabs.length, vsync: this);
    return SantoTabBar(
      controller: tabController,
      tabs: tabs,
      onTap: (state, index) {
        state.refreshBadgeState(index);
      },
    );
  }

  _createStableTabbarBadgeWidgets() {
    var tabs = <BadgeTab>[];
    tabs.add(BadgeTab(text: "业务一", badgeNum: 100));
    tabs.add(BadgeTab(text: "业务二", badgeNum: 22));
    tabs.add(BadgeTab(text: "业务三", badgeNum: 11));
    tabs.add(BadgeTab(text: "业务四"));
    TabController tabController =
        TabController(length: tabs.length, vsync: this);
    return SantoTabBar(
      controller: tabController,
      tabs: tabs,
      onTap: (state, index) {
        state.refreshBadgeState(index);
      },
    );
  }

  _createDividerTabbarWidgets() {
    var tabs = <BadgeTab>[];
    tabs.add(BadgeTab(text: "业务一", topText: "1"));
    tabs.add(BadgeTab(text: "业务二", topText: "2"));
    tabs.add(BadgeTab(text: "业务三", topText: "3"));
    tabs.add(BadgeTab(text: "业务四", topText: "4"));
    tabs.add(BadgeTab(text: "业务五", topText: "5"));
    TabController tabController =
        TabController(length: tabs.length, vsync: this);
    return SantoTabBar(
      controller: tabController,
      tabs: tabs,
      hasIndex: true,
      hasDivider: true,
      onTap: (state, index) {},
    );
  }

  ///
  /// 自定义Tab宽度，如果tab宽度之和大于屏幕宽度，默认能左右滚动
  ///
  _createCustomTabbarWidgets() {
    var tabs = <BadgeTab>[];
    tabs.add(BadgeTab(text: "业务一", badgeNum: 2));
    tabs.add(BadgeTab(text: "业务二"));
    tabs.add(BadgeTab(text: "业务三", badgeNum: 33));
    TabController tabController =
        TabController(length: tabs.length, vsync: this);
    return SantoTabBar(
      controller: tabController,
      tabs: tabs,
      tabWidth: 80,
      hasIndex: true,
      hasDivider: false,
      onTap: (state, index) {},
    );
  }

  _createTopTabbarWidgets() {
    var tabs = <BadgeTab>[];
    tabs.add(BadgeTab(text: "08月09日", topText: "今天"));
    tabs.add(BadgeTab(text: "08月10日", topText: "明天"));
    tabs.add(BadgeTab(text: "08月11日", topText: "周三"));
    tabs.add(BadgeTab(text: "08月12日", topText: "周四"));
    tabs.add(BadgeTab(text: "08月13日", topText: "周五"));
    TabController tabController =
        TabController(length: tabs.length, vsync: this);
    return SantoTabBar(
      controller: tabController,
      tabs: tabs,
      hasIndex: true,
      labelColor: Color(0xFF21C1B5),
      indicatorColor: Color(0xFF21C1B5),
      hasDivider: true,
      onTap: (state, index) {},
    );
  }

  _createTopTabbarCountWidgets() {
    var tabs = <BadgeTab>[];
    tabs.add(BadgeTab(text: "08月09日", topText: "今天"));
    tabs.add(BadgeTab(text: "08月10日", topText: "明天"));
    tabs.add(BadgeTab(text: "08月11日", topText: "周三"));
    TabController tabController =
        TabController(length: tabs.length, vsync: this);
    return SantoTabBar(
      controller: tabController,
      tabs: tabs,
      hasIndex: true,
      labelColor: Color(0xFF21C1B5),
      indicatorColor: Color(0xFF21C1B5),
      hasDivider: true,
      onTap: (state, index) {},
    );
  }

  _createOriginWidgets() {
    var tabs = <BadgeTab>[];
    tabs.add(BadgeTab(text: "业务一", badgeText: "新"));
    tabs.add(BadgeTab(text: "业务二", badgeNum: 22));
    tabs.add(BadgeTab(text: "业务三", badgeNum: 11));
    tabs.add(BadgeTab(text: "业务四", showRedBadge: true));
    tabs.add(BadgeTab(text: "业务五", badgeNum: 12));
    tabs.add(BadgeTab(text: "业务六", badgeNum: 30));
    tabs.add(BadgeTab(text: "业务七"));
    tabs.add(BadgeTab(text: "业务八", badgeNum: 23));
    tabs.add(BadgeTab(text: "业务九"));
    TabController tabController =
        TabController(length: tabs.length, vsync: this);
    return SantoTabBar(
      controller: tabController,
      tabs: tabs,
      mode: SantoTabBarBadgeMode.origin,
      isScroll: false,
      labelPadding: EdgeInsets.only(left: 20, right: 12),
      indicatorPadding: EdgeInsets.only(left: 10),
      onTap: (state, index) {},
    );
  }
}
