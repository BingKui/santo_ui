import 'package:santo_ui/santo_ui.dart';
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
    return Scaffold(
      appBar: SantoAppBar(
        title: '展开收起文本',
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
SantoPanel(
            title: '规则',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SantoBubbleText(
              maxLines: 4,
              text: '显示指定行数的文本，超过的收起，点击更多会显示全部',
            )],
            ),
          ),
SantoPanel(
            title: '正常案例',
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
      ),
    );
  }
}
