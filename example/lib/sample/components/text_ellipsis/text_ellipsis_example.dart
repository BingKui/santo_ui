import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

const String _ellipsisText =
    '慢慢来，比较快。这是一段用于演示文本省略的长文本，超出指定行数后自动折叠，'
    '并在省略号之后紧跟展开操作，点击即可展开全部内容，再次点击收起。';

/// SantoTextEllipsis 文本省略示例
class TextEllipsisExample extends StatefulWidget {
  @override
  State<TextEllipsisExample> createState() => _TextEllipsisExampleState();
}

class _TextEllipsisExampleState extends State<TextEllipsisExample> {
  final GlobalKey<SantoTextEllipsisState> _ellipsisKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(      title: 'TextEllipsis 文本省略',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SantoSection(
            title: '基础用法',
            description: 'rows 默认 1 行，超出后折叠并在省略号后紧跟 expandText',
            child: const SantoTextEllipsis(
              content: _ellipsisText,
              expandText: '展开',
              collapseText: '收起',
            ),
          ),
          SantoSection(
            title: '多行折叠',
            description: 'rows 设为 3，超出 3 行的部分折叠，展开后展示完整内容',
            child: const SantoTextEllipsis(
              content: _ellipsisText,
              rows: 3,
              expandText: '展开',
              collapseText: '收起',
            ),
          ),
          SantoSection(
            title: '省略位置',
            description: 'position 取 start、middle、end，分别省略开头、中间与结尾',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SantoTextEllipsis(
                  content: _ellipsisText,
                  rows: 2,
                  position: SantoTextEllipsisPosition.start,
                  expandText: '展开',
                  collapseText: '收起',
                ),
                SizedBox(height: 12),
                SantoTextEllipsis(
                  content: _ellipsisText,
                  rows: 2,
                  position: SantoTextEllipsisPosition.middle,
                  expandText: '展开',
                  collapseText: '收起',
                ),
                SizedBox(height: 12),
                SantoTextEllipsis(
                  content: _ellipsisText,
                  rows: 2,
                  expandText: '展开',
                  collapseText: '收起',
                ),
              ],
            ),
          ),
          SantoSection(
            title: '自定义省略文案',
            description: 'dots 替换默认的英文省略号，可与中文标点保持一致',
            child: const SantoTextEllipsis(
              content: _ellipsisText,
              rows: 2,
              dots: '……',
              expandText: '展开',
              collapseText: '收起',
            ),
          ),
          SantoSection(
            title: '自定义操作样式',
            description: 'actionStyle 控制展开与收起文案的样式，默认使用品牌主题色',
            child: const SantoTextEllipsis(
              content: _ellipsisText,
              rows: 2,
              expandText: '展开全部',
              collapseText: '收起',
              actionStyle: TextStyle(
                color: Color(0xFFFF5722),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SantoSection(
            title: '自定义操作内容',
            description: 'actionBuilder 按展开态返回自定义 span，需自行挂载 recognizer 处理点击',
            child: SantoTextEllipsis(
              content: _ellipsisText,
              rows: 2,
              actionBuilder: (context, expanded) => TextSpan(
                text: expanded ? ' [收起]' : ' [展开]',
                style: const TextStyle(
                  color: Color(0xFF1677FF),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SantoSection(
            title: '展开与收起回调',
            description: '点击操作触发 onClickAction，回调参数为点击后的展开状态',
            child: SantoTextEllipsis(
              content: _ellipsisText,
              rows: 2,
              expandText: '展开',
              collapseText: '收起',
              onClickAction: (expanded) {
                SantoToast.show(expanded ? '已展开' : '已收起', context);
              },
            ),
          ),
          SantoSection(
            title: '外部控制展开态',
            description: '通过 GlobalKey 取到 State 后调用 toggle，可用外部按钮切换',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SantoTextEllipsis(
                  key: _ellipsisKey,
                  content: _ellipsisText,
                  rows: 2,
                  expandText: '展开',
                  collapseText: '收起',
                ),
                const SizedBox(height: 12),
                SantoNormalButton(
                  text: '切换展开/收起',
                  onTap: () => _ellipsisKey.currentState?.toggle(),
                ),
              ],
            ),
          ),
          SantoSection(
            title: '内容未超出',
            description: '文本行数未超过 rows 时原样展示，不出现省略号与操作文案',
            child: const SantoTextEllipsis(
              content: '慢慢来，比较快',
              rows: 2,
              expandText: '展开',
              collapseText: '收起',
            ),
          ),
        ],
      ),
    );
  }
}
