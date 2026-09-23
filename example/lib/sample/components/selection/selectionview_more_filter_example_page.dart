import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart' hide DropdownMenu;

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
    return SantoPageLayout(
      title: widget._title,
      scrollable: false,
      padding: EdgeInsets.zero,
      children: <Widget>[
        Column(
          children: <Widget>[
            DropdownMenu(
              originalSelectionData: widget._filters!,
              onMoreSelectionMenuClick:
                  (int index, SantoOpenMorePage openMore) {
                    openMore(updateData: false);
                  },
              onSelectionChanged: (
                int menuIndex,
                Map<String, String> filterParams,
                Map<String, String> customParams,
                SantoSetCustomSelectionMenuTitle setCustomTitleFunction,
              ) {},
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Text("背景内容区域"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
