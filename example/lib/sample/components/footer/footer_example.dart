import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// 页脚组件示例
class FooterExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(title: 'Footer 页脚'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SantoPanel(
              title: '纯文字页脚',
              child: SantoFooter(text: 'Santo UI 组件库'),
            ),
            SantoPanel(
              title: '带链接页脚',
              child: SantoFooter(
                text: '© 2026 Santo UI',
                links: [
                  SantoFooterLink(text: '官网', onTap: () {}),
                  SantoFooterLink(text: '文档', onTap: () {}),
                  SantoFooterLink(text: '关于', onTap: () {}),
                ],
              ),
            ),
            SantoPanel(
              title: '带 Logo 页脚',
              child: SantoFooter(
                text: 'Powered by Santo UI',
                logo: Icon(
                  Icons.flutter_dash,
                  size: 20,
                  color: Color(0xFF0984F9),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
