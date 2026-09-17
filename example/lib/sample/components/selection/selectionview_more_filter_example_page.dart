

import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

class SelectionViewMoreFilterExamplePage extends StatefulWidget {
  final String _title;
  final List<SantoSelectionEntity>? _filters;

  SelectionViewMoreFilterExamplePage(this._title, this._filters);

  @override
  _SelectionViewExamplePageState createState() =>
      _SelectionViewExamplePageState();
}

class _SelectionViewExamplePageState
    extends State<SelectionViewMoreFilterExamplePage> {
  int count = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(      appBar: SantoAppBar(title: widget._title),
      children: <Widget>[
          SantoSelectionView(
            originalSelectionData: widget._filters!,
            onMoreSelectionMenuClick: (int index, SantoOpenMorePage openMore) {
              openMore(updateData: false);
            },
            onSelectionChanged: (int menuIndex,
                Map<String, String> filterParams,
                Map<String, String> customParams,
                SantoSetCustomSelectionMenuTitle setCustomTitleFunction) {},
          ),
          Container(
            padding: EdgeInsets.only(top: 400),
            alignment: Alignment.center,
            child: Text("背景内容区域"),
          )
      ],
    );
  }
}
