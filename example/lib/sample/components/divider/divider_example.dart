

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
            _sectionTitle('水平分割线'),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SantoDivider(),
            ),

            _sectionTitle('带标题文本'),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SantoDivider(child: Text('Santo UI')),
            ),

            _sectionTitle('标题位置：start / end'),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SantoDivider(
                child: Text('居左标题'),
                titlePlacement: SantoDividerTitlePlacement.start,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SantoDivider(
                child: Text('居右标题'),
                titlePlacement: SantoDividerTitlePlacement.end,
              ),
            ),

            _sectionTitle('弱化文本样式（plain）'),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SantoDivider(
                child: Text('普通文本'),
                plain: true,
              ),
            ),

            _sectionTitle('竖向分割线'),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text('服务'),
                  SantoDivider(orientation: SantoDividerOrientation.vertical),
                  Text('隐私政策'),
                  SantoDivider(orientation: SantoDividerOrientation.vertical),
                  Text('关于我们'),
                ],
              ),
            ),

            _sectionTitle('虚线分割线'),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SantoDivider(dashed: true),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SantoDivider(
                dashed: true,
                child: Text('虚线带标题'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
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
            ),

            _sectionTitle('不同间距（size）'),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SantoDivider(size: SantoDividerSize.small),
                  Text('small：上下间距 8'),
                  SantoDivider(size: SantoDividerSize.medium),
                  Text('medium：上下间距 16（默认）'),
                  SantoDivider(size: SantoDividerSize.large),
                  Text('large：上下间距 24'),
                ],
              ),
            ),

            _sectionTitle('自定义颜色和粗细'),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
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
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                'SantoDashedLine：分割线的空间是由内部内容撑开',
                style: TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 18,
                ),
              ),
            ),
            // 分割线的空间是由内部内容撑开
            SantoDashedLine(
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
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                'SantoDashedLine：分割线的空间是由内部容器设定',
                style: TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 18,
                ),
              ),
            ),
            // 分割线的空间是由内部容器设定
            SantoDashedLine(
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
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                'SantoDashedLine：分割线的空间由外部设定',
                style: TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 18,
                ),
              ),
            ),
            // 分割线的空间由外部设定
            Container(
              height: 50,
              width: 300,
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.only(left: 16, bottom: 24),
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
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        text,
        style: TextStyle(
          color: Color(0xFF222222),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
