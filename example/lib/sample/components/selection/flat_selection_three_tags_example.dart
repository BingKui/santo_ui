

import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart' hide DropdownMenu;

class FlatSelectionThreeTagsExample extends StatefulWidget {
  final String _title;
  final List<SantoSelectionEntity> _filterData;

  FlatSelectionThreeTagsExample(this._title, this._filterData);

  @override
  _SelectionViewExamplePageState createState() =>
      _SelectionViewExamplePageState();
}

class _SelectionViewExamplePageState
    extends State<FlatSelectionThreeTagsExample> {
  SantoSelectionEntity? entity;

  SantoFlatSelectionController? controller;

  var selectionKey = GlobalKey();

  bool _isShow = true;

  @override
  void initState() {
    super.initState();

    controller = SantoFlatSelectionController();
  }

  @override
  void dispose() {
    controller!.dispose();
    controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget._title)),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 20),
            alignment: Alignment.center,
            child: GestureDetector(
              child: Text("点击关闭展开"),
              onTap: () {
                setState(() {
                  _isShow = !_isShow;
                });
              },
            ),
          ),
          Expanded(
            child: _isShow
                ? Column(
                    children: <Widget>[
                      Container(
                          color: Colors.white,
                          width: double.infinity,
                          height: 400,
                          child: SantoFlatSelection(
                              entityDataList: widget._filterData,
                              confirmCallback: (data) {
                                var str = "";
                                data.forEach(
                                    (k, v) => str = str + " " + '$k: $v');
                                SantoToast.show(str, context);
                              },
                              controller: controller)),
                      _bottomWidget(),
                    ],
                  )
                : Container(),
          ),
        ],
      ),
    );
  }

  Widget _bottomWidget() {
    return Column(
      children: <Widget>[
        Divider(
          height: 0.3,
          color: Color(0xFFE8EAEC),
        ),
        Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(8, 11, 20, 11),
          child: Row(
            children: <Widget>[
              InkWell(
                child: Container(
                  padding: EdgeInsets.only(left: 12, right: 20),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 24,
                        width: 24,
                        child: SantoTools.getAssetImage(
                            SantoAsset.iconSelectionReset),
                      ),
                      Text(
                        "重置",
                        style:
                            TextStyle(fontSize: 11, color: Color(0xFF808695)),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  if (controller != null) {
                    controller!.resetSelectedOptions();
                  }
                },
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SantoButton(
                      width: 104,
                      type: SantoButtonType.normal,
                      size: SantoButtonSize.large,
                      text: "取消",
                      onTap: () {
                        if (controller != null) {
                          controller!.cancelSelectedOptions();
                          setState(() {
                            _isShow = false;
                          });
                        }
                      }),
                  Container(
                    width: 20,
                  ),
                  SantoButton(
                      width: 104,
                      type: SantoButtonType.primary,
                      size: SantoButtonSize.large,
                      text: "确定",
                      onTap: () {
                        if (controller != null) {
                          controller!.confirmSelectedOptions();
                          setState(() {
                            _isShow = false;
                          });
                        }
                      }),
                ],
              ))
            ],
          ),
        )
      ],
    );
  }
}
