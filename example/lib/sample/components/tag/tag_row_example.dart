

import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

class RowTagExample extends StatefulWidget {
  @override
  _RowTagExampleState createState() => _RowTagExampleState();
}

class _RowTagExampleState extends State<RowTagExample> {
  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(      title: '标签组合',
      children: <Widget>[
        SantoSection(
          title: '标签组',
          description: 'Wrap 排列多个普通标签与描边标签，自动换行',
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.start,
            children: [
              SantoTagCustom(
                tagText: '自定义标签',
              ),
              SantoTagCustom(
                tagText: '标签',
              ),
              SantoTagCustom.buildBorderTag(tagText: '标签1'),
              SantoTagCustom.buildBorderTag(tagText: '标签2'),
              SantoTagCustom.buildBorderTag(tagText: '特长长长长长长的标签'),
              SantoTagCustom(tagText: '一级标签'),
              SantoTagCustom(tagText: '二级标签'),
              SantoTagCustom(tagText: '其他标签'),
              SantoTagCustom(tagText: '二级标签'),
              SantoTagCustom(tagText: '一级标签'),
              SantoTagCustom(tagText: '二级标签'),
            ],
            spacing: 5,
            runSpacing: 5,
          ),
        ),
      ],
    );
  }
}
