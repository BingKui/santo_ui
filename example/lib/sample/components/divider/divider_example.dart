

import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';

class DividerExample extends StatefulWidget {
  @override
  _DividerExampleState createState() => _DividerExampleState();
}

class _DividerExampleState extends State<DividerExample> {
  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(      title: 'Divider 分割线',
      children: <Widget>[
        ExampleIntro('divider'),
        // ---------- SantoDivider（参考 antd） ----------
        SantoSection(
          title: '水平分割线',
          description: '最简用法，不传 child 时仅渲染一条水平细线',
          child: const SantoDivider(),
        ),
        SantoSection(
          title: '带标题文本',
          description: 'child 传入文本作为标题，默认居中展示',
          child: const SantoDivider(child: Text('Santo UI')),
        ),
        SantoSection(
          title: '标题位置：start / end',
          description: 'titlePlacement 控制标题居左或居右，与默认居中形成对比',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SantoDivider(
                child: Text('居左标题'),
                titlePlacement: SantoDividerTitlePlacement.start,
              ),
              SantoDivider(
                child: Text('居右标题'),
                titlePlacement: SantoDividerTitlePlacement.end,
              ),
            ],
          ),
        ),
        SantoSection(
          title: '弱化文本样式（plain）',
          description: 'plain 设为 true 弱化标题文字，适合次要信息的分隔',
          child: const SantoDivider(
            child: Text('普通文本'),
            plain: true,
          ),
        ),
        SantoSection(
          title: '竖向分割线',
          description: 'orientation 设为 vertical，用于行内元素之间的竖向分隔',
          child: const Row(
            children: [
              Text('服务'),
              SantoDivider(orientation: SantoDividerOrientation.vertical),
              Text('隐私政策'),
              SantoDivider(orientation: SantoDividerOrientation.vertical),
              Text('关于我们'),
            ],
          ),
        ),
        SantoSection(
          title: '虚线分割线',
          description: 'dashed 为 true 时线条改为虚线，带标题与竖向同样适用',
          child: Column(
            children: const [
              SantoDivider(dashed: true),
              SantoDivider(
                dashed: true,
                child: Text('虚线带标题'),
              ),
              Row(
                children: [
                  Text('使用'),
                  SantoDivider(
                    orientation: SantoDividerOrientation.vertical,
                    dashed: true,
                  ),
                  Text('虚线'),
                  SantoDivider(
                    orientation: SantoDividerOrientation.vertical,
                    dashed: true,
                  ),
                  Text('竖向'),
                ],
              ),
            ],
          ),
        ),
        SantoSection(
          title: '不同间距（size）',
          description: 'size 可选 small、medium、large，对应上下间距 8、16、24',
          child: Column(
            children: const [
              SantoDivider(size: SantoDividerSize.small),
              Text('small：上下间距 8'),
              SantoDivider(size: SantoDividerSize.medium),
              Text('medium：上下间距 16（默认）'),
              SantoDivider(size: SantoDividerSize.large),
              Text('large：上下间距 24'),
            ],
          ),
        ),
        SantoSection(
          title: '自定义颜色和粗细',
          description: 'color 与 thickness 自定义线条颜色和粗细，可与 dashed 组合',
          child: Column(
            children: const [
              SantoDivider(
                color: Color(0xFF1677FF),
                thickness: 2,
              ),
              SantoDivider(
                color: Color(0xFF52C41A),
                thickness: 2,
                dashed: true,
              ),
            ],
          ),
        ),
        SizedBox(height: 24),
      ],
    );
  }
}
