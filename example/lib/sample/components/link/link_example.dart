import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// 链接组件示例
class LinkExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(title: 'Link 链接'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SantoPanel(
              title: '基础链接',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SantoLink(text: '默认链接', onTap: () {}),
                  SizedBox(height: 12),
                  SantoLink(text: '带下划线链接', underline: true, onTap: () {}),
                ],
              ),
            ),
            SantoPanel(
              title: '链接状态',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SantoLink(text: '普通状态', onTap: () {}),
                  SizedBox(height: 12),
                  SantoLink(text: '禁用状态', state: SantoLinkState.disabled),
                ],
              ),
            ),
            SantoPanel(
              title: '带图标链接',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SantoLink(
                    text: '前置图标链接',
                    prefixIcon: Icons.link,
                    onTap: () {},
                  ),
                  SizedBox(height: 12),
                  SantoLink(
                    text: '后置图标链接',
                    suffixIcon: Icons.arrow_forward,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            SantoPanel(
              title: '自定义颜色',
              child: SantoLink(
                text: '自定义颜色链接',
                color: Color(0xFF00AE66),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
