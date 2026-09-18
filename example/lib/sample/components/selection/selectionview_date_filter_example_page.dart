

import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart' hide DropdownMenu;

class SelectionViewDateFilterExamplePage extends StatefulWidget {
  final String _title;
  final List<SantoSelectionEntity> _filters;

  SelectionViewDateFilterExamplePage(this._title, this._filters);

  @override
  _SelectionViewExamplePageState createState() =>
      _SelectionViewExamplePageState(_filters);
}

class _SelectionViewExamplePageState
    extends State<SelectionViewDateFilterExamplePage> {
  late List<SantoSelectionEntity> _filterData;

  _SelectionViewExamplePageState(List<SantoSelectionEntity> filters) {
    _filterData = filters;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget._title)),
      body: Column(
        children: <Widget>[
          DropdownMenu(
            originalSelectionData: _filterData,
            onCustomSelectionMenuClick: (int index,
                SantoSelectionEntity customMenuItem,
                SantoSetCustomSelectionParams customHandleCallBack) {
              customHandleCallBack({"customKey": "customValue"});
            },
            onMoreSelectionMenuClick:
                (int index, SantoOpenMorePage openMorePage) {
              openMorePage(
                  updateData: false, moreSelections: widget._filters);
            },
            onSelectionChanged: (int menuIndex,
                Map<String, String> filterParams,
                Map<String, String> customParams,
                SantoSetCustomSelectionMenuTitle setCustomTitleFunction) {
              SantoToast.show(
                  'filterParams : $filterParams'
                      ',\n customParams : $customParams',
                  context);
            },
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text("背景内容区域"),
            ),
          )
        ],
      ),
    );
  }
}
