

import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart' hide DropdownMenu;

class SelectionViewMultiListExamplePage extends StatefulWidget {
  final String _title;
  final List<SantoSelectionEntity>? _filterData;

  SelectionViewMultiListExamplePage(this._title, this._filterData);

  @override
  _SelectionViewExamplePageState createState() =>
      _SelectionViewExamplePageState();
}

class _SelectionViewExamplePageState
    extends State<SelectionViewMultiListExamplePage> {
  List<SantoSelectionEntity>? items;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget._title)),
      body: Column(
        children: <Widget>[
          DropdownMenu(
            originalSelectionData: widget._filterData!,
            onSelectionChanged: (int menuIndex,
                Map<String, String> filterParams,
                Map<String, String> customParams,
                SantoSetCustomSelectionMenuTitle setCustomTitleFunction) {
              SantoToast.show(filterParams.toString(), context);
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
