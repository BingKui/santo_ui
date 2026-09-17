

import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/components/bubble_text/bubble_text_example.dart';
import 'package:flutter/material.dart';

class SelectionViewMoreCustomFloatLayerExamplePage extends StatefulWidget {
  final String _title;
  final List<SantoSelectionEntity>? _filterData;

  SelectionViewMoreCustomFloatLayerExamplePage(this._title, this._filterData);

  @override
  _SelectionViewExamplePageState createState() =>
      _SelectionViewExamplePageState();
}

class _SelectionViewExamplePageState
    extends State<SelectionViewMoreCustomFloatLayerExamplePage> {
  List<SantoSelectionEntity>? items;

  SantoSelectionViewController? controller;

  var selectionKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    controller = SantoSelectionViewController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      child: Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 20),
          alignment: Alignment.center,
          child: GestureDetector(
            child: Text("点击关闭弹窗"),
            onTap: () {
              controller!.closeSelectionView();
            },
          ),
        ),
        SantoSelectionView(
          key: selectionKey,
          selectionViewController: controller,
          originalSelectionData: widget._filterData!,
          onMoreSelectionMenuClick:
              (int index, SantoOpenMorePage openMorePage) {
            openMorePage(updateData: false);
          },
          onCustomFloatingLayerClick: (int customFloatingLayerIndex,
              SantoSelectionEntity customLayerEntity,
              SantoSetCustomFloatingLayerSelectionParams resultCallBack) {
            Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) {
                return BubbleTextExample();
              },
            )).then((data) {
              Map<String, String> result = Map();
              result['Key1'] = 'Value1';
              result['Key2'] = 'Value2';
              List<SantoSelectionEntity> resultEntity = [];
              result.forEach((userId, userName) {
                resultEntity.add(SantoSelectionEntity(
                    value: userId,
                    title: userName,
                    isSelected: true,
                    type: 'radio'));
              });
              resultCallBack(resultEntity);
            });
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
        Container(
          padding: EdgeInsets.only(top: 300),
          alignment: Alignment.center,
          child: Text("背景内容区域"),
        ),
      ],
    ),
    );
  }
}
