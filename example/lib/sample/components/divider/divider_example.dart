

import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

class DividerExample extends StatefulWidget {
  @override
  _DividerExampleState createState() => _DividerExampleState();
}

class _DividerExampleState extends State<DividerExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(
        title: 'Divider 分割线',
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // ---------- SantoDivider（参考 antd） ----------
            SantoPanel(
              title: '水平分割线',
              child: const SantoDivider(),
            ),
            SantoPanel(
              title: '带标题文本',
              child: const SantoDivider(child: Text('Santo UI')),
            ),
            SantoPanel(
              title: '标题位置：start / end',
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
            SantoPanel(
              title: '弱化文本样式（plain）',
              child: const SantoDivider(
                child: Text('普通文本'),
                plain: true,
              ),
            ),
            SantoPanel(
              title: '竖向分割线',
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
            SantoPanel(
              title: '虚线分割线',
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
            SantoPanel(
              title: '不同间距（size）',
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
            SantoPanel(
              title: '自定义颜色和粗细',
              child: Column(
                children: const [
                  SantoDivider(
                    color: Color(0xFF0984F9),
                    thickness: 2,
                  ),
                  SantoDivider(
                    color: Color(0xFF00AE66),
                    thickness: 2,
                    dashed: true,
                  ),
                ],
              ),
            ),

            // ---------- SantoDashedLine（原有能力保留） ----------
            SantoPanel(
              title: 'SantoDashedLine：空间由内部内容撑开',
              child: SantoDashedLine(
                dashedLength: 20,
                dashedThickness: 5,
                axis: Axis.vertical,
                color: Colors.red,
                dashedOffset: 20,
                position: SantoDashedLinePosition.leading,
                contentWidget: Container(
                  margin:
                      EdgeInsets.only(left: 60, right: 20, top: 10, bottom: 10),
                  child: Text(
                      "穿插介绍、公司模式一句话C端服务承诺介绍、价值穿插介绍、公司模式一句话C端服务承诺介绍、价值穿插介绍、公司模式一句话C端服务承诺介绍、价值"),
                ),
              ),
            ),
            SantoPanel(
              title: 'SantoDashedLine：空间由内部容器设定',
              child: Center(
                child: SantoDashedLine(
                  dashedLength: 10,
                  dashedThickness: 3,
                  axis: Axis.horizontal,
                  color: Colors.green,
                  dashedOffset: 20,
                  position: SantoDashedLinePosition.leading,
                  contentWidget: Container(
                    width: 200,
                    height: 100,
                  ),
                ),
              ),
            ),
            SantoPanel(
              title: 'SantoDashedLine：空间由外部设定',
              child: Container(
                height: 50,
                width: 300,
                padding: EdgeInsets.all(5),
                color: Colors.red,
                child: SantoDashedLine(
                  axis: Axis.horizontal,
                  dashedOffset: 10,
                  contentWidget: Container(
                    width: 200,
                    height: 100,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
