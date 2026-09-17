import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/components/menu_bar/menu_bar_default_example.dart';
import 'package:example/sample/components/menu_bar/menu_bar_floating_example.dart';
import 'package:example/sample/components/menu_bar/menu_bar_badge_example.dart';
import 'package:example/sample/components/menu_bar/menu_bar_controlled_example.dart';
import 'package:example/sample/components/menu_bar/menu_bar_floating_badge_example.dart';
import 'package:example/sample/home/list_item.dart';
import 'package:flutter/material.dart';

/// MenuBar 菜单栏示例入口
class MenuBarExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: 'MenuBar 菜单栏',
      padding: EdgeInsets.zero,
      scrollable: false,
      child: ListView(
        children: [
          ListItem(
            title: '默认样式',
            isShowLine: false,
            describe: '纯色背景、顶部左右圆角、底部贴边停靠',
            onPressed: () => _push(context, const MenuBarDefaultExample()),
          ),
          ListItem(
            title: '悬浮样式',
            describe: '毛玻璃圆角容器,与屏幕边缘保持 gap 间距',
            onPressed: () => _push(context, const MenuBarFloatingExample()),
          ),
          ListItem(
            title: '红点与徽标',
            describe: '图标/文字展示红点或自定义数字角标',
            onPressed: () => _push(context, const MenuBarBadgeExample()),
          ),
          ListItem(
            title: '悬浮红点与徽标',
            describe: '悬浮样式下图标与文字同样支持红点/角标',
            onPressed: () =>
                _push(context, const MenuBarFloatingBadgeExample()),
          ),
          ListItem(
            title: '受控选中与更多菜单',
            describe: 'currentIndex 受控,点更多弹出宫格菜单',
            onPressed: () => _push(context, const MenuBarControlledExample()),
          ),
        ],
      ),
    );
  }

  void _push(BuildContext context, Widget page) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));
  }
}
