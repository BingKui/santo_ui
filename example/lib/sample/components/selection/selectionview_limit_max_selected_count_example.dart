import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart' hide DropdownMenu;

class SelectionViewLimitMaxSelectedCountExamplePage extends StatefulWidget {
  final String _title;
  final List<SantoSelectionEntity> _filterData;

  SelectionViewLimitMaxSelectedCountExamplePage(this._title, this._filterData);

  @override
  _SelectionViewExamplePageState createState() =>
      _SelectionViewExamplePageState();
}

class _SelectionViewExamplePageState
    extends State<SelectionViewLimitMaxSelectedCountExamplePage> {
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
              originalSelectionData: widget._filterData,
              onSelectionChanged:
                  (
                    int menuIndex,
                    Map<String, String> filterParams,
                    Map<String, String> customParams,
                    SantoSetCustomSelectionMenuTitle setCustomTitleFunction,
                  ) {
                    SantoToast.show(
                      'filterParams : $filterParams'
                      ',\n customParams : $customParams',
                      context,
                    );
                  },
              onMenuClickInterceptor: (index) {
                if (index == 4) {
                  SantoToast.show('第$index个被拦截了', context);
                  return true;
                } else {
                  return false;
                }
              },
              onSelectionPreShow: (int index, SantoSelectionEntity entity) {
                if (entity.key == "role" || entity.key == "guidePrice") {
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
