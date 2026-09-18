import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';

/// SantoHighlight 关键词高亮示例
class HighlightExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(      title: 'Highlight 关键词高亮',
      children: <Widget>[
        ExampleIntro('highlight'),
        SantoSection(
          title: '基础用法',
          description: 'keywords 传入需要高亮的关键词，命中片段使用品牌主题色',
          child: const SantoHighlight(
            sourceString: '慢慢来，比较快',
            keywords: ['慢慢来'],
          ),
        ),
        SantoSection(
          title: '多关键词',
          description: 'keywords 传入多个关键词，命中区间按位置合并，重叠部分合并为一个片段',
          child: const SantoHighlight(
            sourceString: '1 慢慢来 2 比较快 3',
            keywords: ['慢慢来', '比较快'],
          ),
        ),
        SantoSection(
          title: '大小写敏感',
          description: 'caseSensitive 默认 false 忽略大小写，设为 true 后只命中大小写一致的片段',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SantoHighlight(
                sourceString: 'Flutter 是跨端框架，flutter 生态完善',
                keywords: ['Flutter'],
              ),
              SizedBox(height: 12),
              SantoHighlight(
                sourceString: 'Flutter 是跨端框架，flutter 生态完善',
                keywords: ['Flutter'],
                caseSensitive: true,
              ),
            ],
          ),
        ),
        SantoSection(
          title: '自定义高亮样式',
          description: 'highlightStyle 与 unhighlightStyle 分别控制高亮与普通片段的样式',
          child: const SantoHighlight(
            sourceString: '慢慢来，比较快',
            keywords: ['慢慢来'],
            highlightStyle: TextStyle(
              color: Color(0xFFFF5722),
              fontWeight: FontWeight.w500,
            ),
            unhighlightStyle: TextStyle(color: Color(0xFF808695)),
          ),
        ),
        SantoSection(
          title: '自定义片段',
          description: 'highlightBuilder 返回自定义 span，可加工底色、下划线等特殊样式',
          child: SantoHighlight(
            sourceString: '慢慢来，比较快',
            keywords: ['比较快'],
            highlightBuilder: (context, text) => TextSpan(
              text: ' $text ',
              style: const TextStyle(
                color: Colors.white,
                backgroundColor: Color(0xFF1677FF),
              ),
            ),
          ),
        ),
        SantoSection(
          title: '关键词未命中',
          description: '关键词与空关键词都不命中时，整段文本按普通片段展示',
          child: const SantoHighlight(
            sourceString: '慢慢来，比较快',
            keywords: ['不存在的词', ''],
          ),
        ),
      ],
    );
  }
}
