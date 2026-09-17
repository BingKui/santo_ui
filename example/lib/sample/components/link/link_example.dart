import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// 链接组件示例
class LinkExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(      title: 'Link 链接',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SantoSection(
            title: '基础链接',
            description: '点击触发 onTap 回调，underline 控制是否显示下划线',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SantoLink(text: '默认链接', onTap: () {}),
                SizedBox(height: 12),
                SantoLink(text: '带下划线链接', underline: true, onTap: () {}),
              ],
            ),
          ),
          SantoSection(
            title: '链接状态',
            description: 'state 传 disabled 时链接置灰且不响应点击',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SantoLink(text: '普通状态', onTap: () {}),
                SizedBox(height: 12),
                SantoLink(text: '禁用状态', state: SantoLinkState.disabled),
              ],
            ),
          ),
          SantoSection(
            title: '带图标链接',
            description: 'prefixIcon、suffixIcon 分别在文字前后插入图标',
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
          SantoSection(
            title: '自定义颜色',
            description: 'color 覆盖主题默认色，文字与图标同步变色',
            child: SantoLink(
              text: '自定义颜色链接',
              color: Color(0xFF52C41A),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
