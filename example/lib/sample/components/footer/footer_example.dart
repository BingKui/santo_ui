import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// 页脚组件示例
class FooterExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(      title: 'Footer 页脚',
      children: <Widget>[
        SantoSection(
          title: '纯文字页脚',
          description: '仅传入 text，展示最简的纯文字页脚',
          child: SantoFooter(text: 'Santo UI 组件库'),
        ),
        SantoSection(
          title: '带链接页脚',
          description: 'links 传入 SantoFooterLink 列表，点击触发各自 onTap',
          child: SantoFooter(
            text: '© 2026 Santo UI',
            links: [
              SantoFooterLink(text: '官网', onTap: () {}),
              SantoFooterLink(text: '文档', onTap: () {}),
              SantoFooterLink(text: '关于', onTap: () {}),
            ],
          ),
        ),
        SantoSection(
          title: '带 Logo 页脚',
          description: 'logo 传入图标组件，与文字一起展示品牌标识',
          child: SantoFooter(
            text: 'Powered by Santo UI',
            logo: Icon(
              Icons.flutter_dash,
              size: 20,
              color: Color(0xFF1677FF),
            ),
          ),
        ),
      ],
    );
  }
}
