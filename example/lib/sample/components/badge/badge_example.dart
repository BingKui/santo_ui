import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// 徽标组件示例
class BadgeExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(title: 'Badge 示例'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SantoPanel(
              title: '红点模式',
              child: Row(
                children: [
                  SantoBadge(
                    isDot: true,
                    child: Icon(Icons.notifications, size: 32),
                  ),
                  SizedBox(width: 40),
                  SantoBadge(
                    isDot: true,
                    color: Color(0xFF00AE66),
                    child: Icon(Icons.message, size: 32),
                  ),
                  SizedBox(width: 40),
                  SantoBadge(
                    isDot: true,
                    child: Text('消息', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
            SantoPanel(
              title: '数字模式',
              child: Row(
                children: [
                  SantoBadge(count: 5, child: Icon(Icons.mail, size: 32)),
                  SizedBox(width: 40),
                  SantoBadge(
                    count: 20,
                    child: Icon(Icons.chat_bubble, size: 32),
                  ),
                  SizedBox(width: 40),
                  SantoBadge(
                    count: 120,
                    maxCount: 99,
                    child: Icon(Icons.favorite, size: 32),
                  ),
                ],
              ),
            ),
            SantoPanel(
              title: '自定义颜色与文字',
              child: Row(
                children: [
                  SantoBadge(
                    count: 8,
                    color: Color(0xFF00AE66),
                    child: Icon(Icons.shopping_cart, size: 32),
                  ),
                  SizedBox(width: 40),
                  SantoBadge(
                    count: 6,
                    badgeContent: Text(
                      '新',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    child: Icon(Icons.star, size: 32),
                  ),
                ],
              ),
            ),
            SantoPanel(
              title: '数字为 0 时的展示',
              child: Row(
                children: [
                  SantoBadge(
                    count: 0,
                    showZero: true,
                    child: Icon(Icons.inbox, size: 32),
                  ),
                  SizedBox(width: 40),
                  SantoBadge(count: 0, child: Icon(Icons.archive, size: 32)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
