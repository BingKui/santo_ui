

import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

class CustomTagExample extends StatefulWidget {
  @override
  _CustomTagExampleState createState() => _CustomTagExampleState();
}

class _CustomTagExampleState extends State<CustomTagExample> {
  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SantoSection(
            title: '基础用法',
            description: 'SantoTagCustom 默认样式，支持自定义背景色和文字色',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SantoBubbleText(
                    maxLines: 4,
                    text: '标签的文字11号字，上下左右的边距是3，圆角是2，支持自定义的背景色和文字颜色'),
                SizedBox(height: 12),
                SantoTagCustom(
                  tagText: '自定义标签',
                ),
              ],
            ),
          ),
          SantoSection(
            title: '异常案例：文案特别长',
            description: '超长文案下标签的截断与换行表现',
            child: SantoTagCustom(
              tagText:
                  '标题特别长特别长特别长特别长特别长特别长特别长特别长标题特别长特别长特别长特别长特别长特别长特别长特别长标题特别长特别长特别长特别长特别长特别长特别长特别长',
            ),
          ),
        ],
      ),
    );
  }
}
