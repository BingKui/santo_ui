

import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

class BorderTagExample extends StatefulWidget {
  @override
  _BorderTagExampleState createState() => _BorderTagExampleState();
}

class _BorderTagExampleState extends State<BorderTagExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(
        title: "带边框的标签",
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SantoPanel(
              title: '基础用法',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SantoBubbleText(maxLines: 4, text: ' 文字大小 11，上下左右间距 3'),
                  SizedBox(height: 12),
                  SantoTagCustom.buildBorderTag(
                    tagText: '已盘点',
                  ),
                ],
              ),
            ),
            SantoPanel(
              title: '自定义颜色和字号',
              child: SantoTagCustom.buildBorderTag(
                tagText: '认证通过',
                textColor: Colors.red,
                borderColor: Colors.red,
                borderWidth: 2,
                fontSize: 24,
                textPadding: EdgeInsets.all(6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
