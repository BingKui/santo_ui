import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart' hide DropdownMenu;

class SelectionViewDateRangeExamplePage extends StatefulWidget {
  final String _title;
  final List<SantoSelectionEntity>? _filterData;

  SelectionViewDateRangeExamplePage(this._title, this._filterData);

  @override
  _SelectionViewExamplePageState createState() =>
      _SelectionViewExamplePageState();
}

class _SelectionViewExamplePageState
    extends State<SelectionViewDateRangeExamplePage> {
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
              originalSelectionData: widget._filterData!,
              onSelectionChanged:
                  (
                    int menuIndex,
                    Map<String, String> filterParams,
                    Map<String, String> customParams,
                    SantoSetCustomSelectionMenuTitle setCustomTitleFunction,
                  ) {
                    SantoToast.show(filterParams.toString(), context);
                  },
              onSelectionPreShow: (int index, SantoSelectionEntity entity) {
                if (entity.key == 'date_11' || entity.key == 'date_22') {
                  return SantoSelectionWindowType.range;
                }
                return entity.filterShowType!;
              },
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
