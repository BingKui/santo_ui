

import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// Card 卡片示例（SantoShadowCard）
class SantoShadowCardExample extends StatefulWidget {
  @override
  _SantoShadowCardExampleState createState() => _SantoShadowCardExampleState();
}

class _SantoShadowCardExampleState extends State<SantoShadowCardExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(
        title: 'Card 卡片',
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 基础用法
            SantoPanel(
              title: '基础用法',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SantoBubbleText(
                    maxLines: 2,
                    text: '卡片容器，默认浅灰背景、12 圆角、0.5 边框和柔和阴影',
                  ),
                  SizedBox(height: 12),
                  SantoShadowCard(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      '基础阴影卡片，这是内容区域',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),

            // 不同圆角
            SantoPanel(
              title: '不同圆角',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('通过 circular 设置圆角大小，默认 12', style: _tipStyle()),
                  SizedBox(height: 12),
                  SantoShadowCard(
                    padding: EdgeInsets.all(12),
                    circular: 4,
                    child: Text('circular: 4', style: TextStyle(fontSize: 14)),
                  ),
                  SizedBox(height: 12),
                  SantoShadowCard(
                    padding: EdgeInsets.all(12),
                    circular: 12,
                    child: Text('circular: 12（默认）', style: TextStyle(fontSize: 14)),
                  ),
                  SizedBox(height: 12),
                  SantoShadowCard(
                    padding: EdgeInsets.all(12),
                    circular: 24,
                    child: Text('circular: 24', style: TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ),

            // 自定义阴影
            SantoPanel(
              title: '自定义阴影',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '通过 shadowColor、blurRadius、spreadRadius、offset 调整阴影',
                      style: _tipStyle()),
                  SizedBox(height: 12),
                  SantoShadowCard(
                    padding: EdgeInsets.all(12),
                    shadowColor: Color(0x331677FF),
                    blurRadius: 12,
                    child: Text('蓝色柔和阴影 blurRadius: 12',
                        style: TextStyle(fontSize: 14)),
                  ),
                  SizedBox(height: 12),
                  SantoShadowCard(
                    padding: EdgeInsets.all(12),
                    shadowColor: Color(0x22000000),
                    blurRadius: 0,
                    spreadRadius: 2,
                    offset: Offset(3, 3),
                    child: Text('硬阴影 offset: (3, 3), spreadRadius: 2',
                        style: TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ),

            // 自定义背景色和边框
            SantoPanel(
              title: '自定义背景色和边框',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('通过 color 设置背景色，borderWidth 设置边框宽度（0 为无边框）',
                      style: _tipStyle()),
                  SizedBox(height: 12),
                  SantoShadowCard(
                    padding: EdgeInsets.all(12),
                    color: Color(0xFFE8F3FF),
                    borderWidth: 0,
                    child: Text('浅蓝背景，无边框', style: TextStyle(fontSize: 14)),
                  ),
                  SizedBox(height: 12),
                  SantoShadowCard(
                    padding: EdgeInsets.all(12),
                    borderWidth: 1,
                    child: Text('白色背景，1px 边框', style: TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ),

            // 组合内容
            SantoPanel(
              title: '组合内容',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('卡片内可组合任意组件', style: _tipStyle()),
                  SizedBox(height: 12),
                  SantoShadowCard(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SantoAvatar(
                              text: 'S',
                              size: 40,
                              backgroundColor: Color(0xFF1677FF),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Santo UI',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600)),
                                  SizedBox(height: 4),
                                  Text('基于 Flutter 的组件库',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        SantoDivider(),
                        SizedBox(height: 8),
                        Text(
                          '卡片底部描述信息，可以放任意内容。',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _tipStyle() {
    return TextStyle(fontSize: 13, color: Colors.grey);
  }
}
