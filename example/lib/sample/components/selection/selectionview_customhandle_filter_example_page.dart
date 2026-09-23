import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart' hide DropdownMenu;

class SelectionViewCustomHandleFilterExamplePage extends StatefulWidget {
  final String _title;
  final List<SantoSelectionEntity>? _filters;

  SelectionViewCustomHandleFilterExamplePage(this._title, this._filters);

  @override
  _SelectionViewExamplePageState createState() =>
      _SelectionViewExamplePageState();
}

class _SelectionViewExamplePageState
    extends State<SelectionViewCustomHandleFilterExamplePage> {
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
              onCustomSelectionMenuClick:
                  (
                    int index,
                    SantoSelectionEntity customMenuItem,
                    SantoSetCustomSelectionParams customHandleCallBack,
                  ) {
                    /// 用户操作一段时间之后，将自定义参数回传，触发 onSelectionChanged回调。
                    SantoDialog.confirm(
                      context,
                      cancelText: '取消',
                      okText: '确定',
                      message: '点击确定，回传自定义参数到筛选',
                      onOk: () {
                        count++;
                        customHandleCallBack({"CKey": "CValue$count"});
                      },
                    );
                  },
              onSelectionChanged:
                  (
                    int menuIndex,
                    Map<String, String> filterParams,
                    Map<String, String> customParams,
                    SantoSetCustomSelectionMenuTitle setCustomTitleFunction,
                  ) {
                    if (menuIndex == 1) {
                      setCustomTitleFunction(
                        menuTitle: SantoTools.isEmpty(customParams)
                            ? ""
                            : customParams['CKey'] ?? "",
                        isMenuTitleHighLight: !SantoTools.isEmpty(
                          customParams['CKey'],
                        ),
                      );
                    }
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
