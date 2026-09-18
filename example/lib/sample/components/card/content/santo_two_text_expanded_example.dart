import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';

class SantoTextExpandedContentExample extends StatefulWidget {
  @override
  _SantoTextExpandedContentExampleState createState() =>
      _SantoTextExpandedContentExampleState();
}

class _SantoTextExpandedContentExampleState
    extends State<SantoTextExpandedContentExample> {
  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(      title: '展开收起文本',
      children: <Widget>[
ExampleIntro('card'),
SantoSection(
        title: '正常案例',
        description: 'maxLines 限制显示行数，点击更多展开全部并回调 onExpanded',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        SantoExpandableText(
          text: '冠寓是龙湖地产的第三大主航道业务，专注做中高端租赁市场，标语是我家我自在；门店位于昌平区390号，'
              '距离昌平线生命科学冠寓是龙湖地产的第三大主航道业务，专注做中高端租赁市场，标语是我家我自在标语是我家我自在。',
          onExpanded: (value) {
            SantoToast.show("当前的状态是$value", context);
          },
          maxLines: 2,
        )],
        ),
      ),
      ],
    );
  }
}
