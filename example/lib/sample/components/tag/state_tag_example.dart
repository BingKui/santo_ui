

import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

class StateTagExample extends StatefulWidget {
  @override
  _StateTagExampleState createState() => _StateTagExampleState();
}

class _StateTagExampleState extends State<StateTagExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(
        title: '状态角标签',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SantoPanel(
              title: '状态样式',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SantoBubbleText(maxLines: 4, text: '同自定义标签'),
                  SizedBox(height: 12),
                  _stateItem('等待状态', TagState.waiting, '待进行'),
                  _stateItem('失效状态', TagState.invalidate, '失效态'),
                  _stateItem('运行状态', TagState.running, '进行中'),
                  _stateItem('失败状态', TagState.failed, '失败态'),
                  _stateItem('成功状态', TagState.succeed, '成功态'),
                ],
              ),
            ),
            SantoPanel(
              title: '自定义颜色',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SantoStateTag(
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    tagText:
                        '自定义标签自定义标签自定义标签自定义标签自定义标签自定义标签自定义标签自定义标签',
                  ),
                  SizedBox(height: 20),
                  SantoStateTag(
                    tagText: '自定义标签自定义标签自定义标标别长特别签自定义标签自定义标签',
                  ),
                ],
              ),
            ),
            SantoPanel(
              title: '异常案例：文案特别长',
              child: SantoStateTag(
                tagText:
                    '标题特别长特别长特别长特别长特别长特别长特别长特别长标题特别长特别长特别长特别长特别长特别长特别长特别长标题特别长特别长特别长特别长特别长特别长特别长特别长',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stateItem(String label, TagState state, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey)),
        SizedBox(height: 8),
        SantoStateTag(tagText: text, tagState: state),
        SizedBox(height: 12),
      ],
    );
  }
}
