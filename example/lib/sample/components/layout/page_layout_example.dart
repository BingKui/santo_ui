import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// SantoPageLayout 页面布局示例
class PageLayoutExample extends StatelessWidget {
  const PageLayoutExample({Key? key}) : super(key: key);

  /// Section 默认左右各留 12,本页 padding 同为 12,去掉左右边距避免叠加
  static const EdgeInsets _sectionMargin = EdgeInsets.only(bottom: 12);

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      // 传 appBar 接管导航栏;只传 title 时 PageLayout 会用 SantoAppBar 构建
      appBar: SantoAppBar(
        title: 'PageLayout 页面布局',
        actions: SantoTextAction(
          '操作',
          iconPressed: () => SantoToast.show('点击了导航栏操作', context),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SantoSection(
            margin: _sectionMargin,
            title: '页面导航栏',
            description:
                'appBar 可传任意导航栏,只传 title 时用 SantoAppBar 构建,都不传则不显示导航栏',
            child: _card('示例页传入的是「标题 + 右侧文字操作」的自定义导航栏'),
          ),
          SantoSection(
            margin: _sectionMargin,
            title: '内容滚动与内边距',
            description: '内容超出屏幕时由 PageLayout 提供滚动容器,padding 默认四边 12',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                for (int i = 1; i <= 8; i++)
                  _card('第 $i 张卡片,左右留白来自 padding'),
              ],
            ),
          ),
          SantoSection(
            margin: _sectionMargin,
            title: '底部安全区域',
            description:
                'bottomSafeArea 默认 true 预留 Home Indicator 区域,bottomInset 可在其之上叠加留白',
            child: _card('滚动到底部时,最后一张卡片不会被底部安全区域遮住'),
          ),
        ],
      ),
    );
  }

  Widget _card(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }
}
