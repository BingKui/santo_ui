

import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

class SelectedListActionSheetCustomExamplePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>
      SelectedListActionSheetCustomExamplePageState();
}

class SelectedListActionSheetCustomExamplePageState
    extends State<SelectedListActionSheetCustomExamplePage> {
  late SantoSelectedListActionSheetController controller;

  var _bottomActionKey = GlobalKey();
  List<String>? _data;

  @override
  void initState() {
    _data = ['数据源1', '数据源2', '数据源3', '数据源4'];

    controller = SantoSelectedListActionSheetController();

    super.initState();
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// 要拦截 Android 的系统返回行为，请务必自行添加以下 WillPopScope 逻辑
    return WillPopScope(
      onWillPop: () async {
        if (!controller.isHidden) {
          controller.dismiss();
          return false;
        }
        return true;
      },
      child: Scaffold(
          appBar: SantoAppBar(
            title: '已选菜单列表',
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SantoBottomButtonPanel(
                  key: _bottomActionKey,
                  mainButtonName: 'SantoBottomButtonPanel',
                  mainButtonOnTap: () {
                    SantoToast.show('确定！sheet 的数据源长度 ${_data!.length}', context);
                  },
                  iconButtonList: [
                    SantoVerticalIconButton(
                        name: '已选(${_data!.length})',
                        iconWidget: SantoTools.getAssetImage(
                            'icons/grey_place_holder.png'),
                        onTap: () {
                          if (!controller.isHidden) {
                            controller.dismiss();
                          } else {
                            if (_data == null || _data!.length <= 0) {
                              SantoToast.show('数据为空，弹窗不展示', context);
                              return;
                            }
                            SantoSelectedListActionSheet<String>(
                                    context: context,
                                    isClearButtonHidden: false,
                                    isDeleteButtonHidden: true,
                                    items: _data!,
                                    bottomOffset: 82,
                                    maxHeight: 400,
                                    controller: controller,
                                    title: '自定义行视图例子',
                                    itemTitleBuilder: (int index, String? entity) {
                                      return Material(
                                        child: SantoStepInputFormItem(
                                          title: 'SantoStepInputFormItemWidget',
                                          subTitle: 'subtitle，可不传。最小值、最大值可自定义',
                                          minLimit: 0,
                                          maxLimit: 10,
                                          onChanged:
                                              (int oldValue, int newValue) {
                                            SantoToast.show(
                                                "onChanged 回调$oldValue ---- $newValue",
                                                context);
                                          },
                                        ),
                                      );
                                    },
                                    onClear: () {
                                      controller.dismiss();
                                      // 自定义清空的操作，可以不实现，会走默认的清空操作。
                                      SantoDialogManager.showConfirmDialog(
                                          context,
                                          title: "确定要清空已选列表吗?",
                                          cancel: '取消',
                                          confirm: '确定', onConfirm: () {
                                        setState(() {});
                                        _data!.clear();
                                      }, onCancel: () {});
                                    })
                                .showWithTargetKey(
                                    bottomWidgetKey: _bottomActionKey);
                          }
                        })
                  ]),
            ],
          )),
    );
  }
}
