import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';
import 'package:example/sample/home/rule_panel.dart';

class SantoTextExpandedContentExample extends StatefulWidget {
  @override
  _SantoTextExpandedContentExampleState createState() =>
      _SantoTextExpandedContentExampleState();
}

class _SantoTextExpandedContentExampleState
    extends State<SantoTextExpandedContentExample> {
  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
RulePanel(
          '显示指定行数的文本，超过的收起，点击更多会显示全部',
          maxLines: 4),
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
      ),
    );
  }
}
