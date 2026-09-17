

import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

class SelectionViewMultiRangeExamplePage extends StatefulWidget {
  final String _title;
  final List<SantoSelectionEntity>? _filters;

  SelectionViewMultiRangeExamplePage(this._title, this._filters);

  @override
  _SelectionViewExamplePageState createState() =>
      _SelectionViewExamplePageState();
}

class _SelectionViewExamplePageState
    extends State<SelectionViewMultiRangeExamplePage> {
  List<String>? titles;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      appBar: SantoAppBar(title: widget._title),
      padding: EdgeInsets.zero,
      child: Column(
          children: <Widget>[
            SantoSelectionView(
              originalSelectionData: widget._filters!,
              onSelectionChanged: (int menuIndex,
                  Map<String, String> filterParams,
                  Map<String, String> customParams,
                  SantoSetCustomSelectionMenuTitle setCustomTitleFunction) {
                SantoToast.show(filterParams.toString(), context);
              },
              onSelectionPreShow: (int index, SantoSelectionEntity entity) {
                if (entity.key == "one_range_key" ||
                    entity.key == "two_range_key") {
                  return SantoSelectionWindowType.range;
                }
                return entity.filterShowType!;
              },
            ),
            Container(
              padding: EdgeInsets.only(top: 400),
              alignment: Alignment.center,
              child: Text("背景内容区域"),
            )
          ],
        ),
    );
  }
}
