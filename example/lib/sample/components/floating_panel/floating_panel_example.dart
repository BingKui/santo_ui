import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/components/floating_panel/floating_panel_basic_example.dart';
import 'package:example/sample/components/floating_panel/floating_panel_controlled_example.dart';
import 'package:example/sample/components/floating_panel/floating_panel_header_example.dart';
import 'package:example/sample/home/list_item.dart';
import 'package:flutter/material.dart';

/// FloatingPanel 浮层面板示例入口
class FloatingPanelExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: 'FloatingPanel 浮层面板',
        children: <Widget>[
          ListItem(
            title: '基础用法',
            isShowLine: false,
            describe: '默认锚点,拖动把手或内容区域改变高度',
            onPressed: () => _push(context, const FloatingPanelBasicExample()),
          ),
          ListItem(
            title: '自定义标头与多锚点',
            describe: 'header 插槽整块可拖,三档锚点吸附',
            onPressed: () => _push(context, const FloatingPanelHeaderExample()),
          ),
          ListItem(
            title: '受控高度与开关',
            describe: 'height 受控 + magnetic/draggable/contentDraggable',
            onPressed: () =>
                _push(context, const FloatingPanelControlledExample()),
          ),
        ],
    );
  }

  void _push(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
