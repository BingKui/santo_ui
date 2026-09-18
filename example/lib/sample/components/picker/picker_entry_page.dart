

import 'dart:convert';

import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:example/sample/components/picker/cutomer_bottom_picker_example.dart';
import 'package:example/sample/home/list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'date_picker_example.dart';
import 'expend_multi_item.dart';
import 'multi_picker_example.dart';

class PickerEntryPage extends StatelessWidget {
  final String _title;
  final List<SantoPickerEntity> dataList = [];

  PickerEntryPage(this._title);

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      appBar: SantoAppBar(
          title: _title,
        ),
        children: <Widget>[
          ExampleIntro('picker'),
          ListItem(
            title: "MultiDataPicker",
            describe: '底部多级选择',
            onPressed: () {
              _showMultiDataPicker(context);
            },
          ),
          ListItem(
            title: "DatePicker",
            describe: '日期选择控件',
            onPressed: () {
              _showDatePicker(context);
            },
          ),
          ListItem(
            title: "BottomWriteDialog",
            describe: 'Picker/文字录入  底部输入弹框',
            onPressed: () {
              _showBottomWriteDialog(context);
            },
          ),
          ListItem(
            title: "Picker/多选/勾选（MultiSelectBottomPicker）",
            describe: '底部多选弹框',
            onPressed: () {
              _showBottomMultiSelectPicker(context);
            },
          ),
          ListItem(
            title: "Picker/多选/勾选（MultiSelectBottomPicker）",
            describe: '底部多选弹框(自定义数据协议)',
            onPressed: () {
              _showExpandBottomMultiSelectPicker(context);
            },
          ),
          ListItem(
            title: "Picker/多选/勾选（MultiSelectBottomPicker）",
            describe: '底部多选弹框(实现限制选择个数)',
            onPressed: () {
              _showCountLimitBottomMultiSelectPicker(context);
            },
          ),
          ListItem(
            title: "Picker/标签选择（SantoTagsPicker）",
            describe: "底部标签弹框，支持多选/单选与输入框",
            onPressed: () {
              _showTagsPicker(context);
            },
          ),
          ListItem(
            title: "Picker/标签选择-带输入框（SantoTagsPicker）",
            describe: "单选 + 输入框",
            onPressed: () {
              _showTagsPickerWithInput(context);
            },
          ),
          ListItem(
            title: "Picker 级联选择",
            describe: "底部级联选择框",
            onPressed: () {
              rootBundle.loadString('assets/list_picker.json').then((data) {
                List<SantoPickerEntity> _selectionData = []..addAll(
                    (JsonDecoder().convert(data)["data"]['list'] as List? ??
                            [])
                        .map((o) => SantoPickerEntity.fromMap(o)));
                if (_selectionData.length > 0) {
                  _selectionData.forEach((f) => f.configChild());
                  if (dataList.length == 0) {
                    dataList.addAll(_selectionData);
                  }
                  _showRangePicker(context, dataList);
                }
              });
            },
          ),
          ListItem(
            title: "Picker 级联选择",
            describe: "底部级联选择框（Title 动态改变）",
            onPressed: () {
              rootBundle.loadString('assets/list_picker.json').then((data) {
                List<SantoPickerEntity> _selectionData = []..addAll(
                    (JsonDecoder().convert(data)["data"]['list'] as List? ??
                            [])
                        .map((o) => SantoPickerEntity.fromMap(o)));
                if (_selectionData.length > 0) {
                  _selectionData.forEach((f) => f.configChild());
                  if (dataList.length == 0) {
                    dataList.addAll(_selectionData);
                  }
                  _showRangePicker1(context, dataList);
                }
              });
            },
          ),
          ListItem(
            title: "自定义底部弹窗Picker",
            describe: "支持自定义内容",
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return CustomPickerExamplePage();
                },
              ));
            },
          ),
        ],
    );
  }

  ///多选弹框
  void _showBottomMultiSelectPicker(BuildContext context) {
    List<SantoMultiSelectBottomPickerItem> items = [];
    items.add(new SantoMultiSelectBottomPickerItem("100", "这里是标题1"));
    items.add(new SantoMultiSelectBottomPickerItem("101", "这里是标题2"));
    items.add(
        new SantoMultiSelectBottomPickerItem("102", "这里是标题3", isChecked: true));
    items.add(
        new SantoMultiSelectBottomPickerItem("103", "这里是标题4", isChecked: true));
    items.add(new SantoMultiSelectBottomPickerItem("104", "这里是标题5"));
    items.add(new SantoMultiSelectBottomPickerItem("104", "这里是标题6"));
    SantoMultiSelectListPicker.show(
      context,
      items: items,
      pickerTitleConfig: SantoPickerTitleConfig(titleContent: "多选 Picker"),
      onSubmit: (List<SantoMultiSelectBottomPickerItem> data) {
        var str = "";
        data.forEach((item) {
          str = str + item.content + "  ";
        });
        SantoToast.show(str, context);
        Navigator.of(context).pop();
      },
    );
  }

  ///多选弹框自定义数据协议
  void _showExpandBottomMultiSelectPicker(BuildContext context) {
    List<ExpendMultiSelectBottomPickerItem> items = [];
    items.add(new ExpendMultiSelectBottomPickerItem("100", "这里是标题1",attribute1: "第一条自定义参数1"));
    items.add(new ExpendMultiSelectBottomPickerItem("101", "这里是标题2",attribute1: "第二条自定义参数2"));
    items.add(
        new ExpendMultiSelectBottomPickerItem("102", "这里是标题3", isChecked: true,attribute1: "第三条自定义参数3"));
    items.add(
        new ExpendMultiSelectBottomPickerItem("103", "这里是标题4", isChecked: true));
    items.add(new ExpendMultiSelectBottomPickerItem("104", "这里是标题5"));
    items.add(new ExpendMultiSelectBottomPickerItem("104", "这里是标题6"));
    SantoMultiSelectListPicker.show<ExpendMultiSelectBottomPickerItem>(
      context,
      items: items,
      pickerTitleConfig: SantoPickerTitleConfig(titleContent: "多选 Picker"),
      onSubmit: (List<ExpendMultiSelectBottomPickerItem> data) {
        var str = "";
        data.forEach((item) {
          String attribute = item.attribute1 ?? "";
          str = str + attribute;
        });
        SantoToast.show(str, context);
        Navigator.of(context).pop();
      },
    );
  }

  /// 实现限制选择数量的情况
  void _showCountLimitBottomMultiSelectPicker(BuildContext context) {
    List<SantoMultiSelectBottomPickerItem> items = [];
    items.add(new SantoMultiSelectBottomPickerItem("100", "这里是标题1"));
    items.add(new SantoMultiSelectBottomPickerItem("101", "这里是标题2"));
    items.add(
        new SantoMultiSelectBottomPickerItem("102", "这里是标题3", isChecked: true));
    items.add(
        new SantoMultiSelectBottomPickerItem("103", "这里是标题4", isChecked: true));
    items.add(new SantoMultiSelectBottomPickerItem("104", "这里是标题5"));
    items.add(new SantoMultiSelectBottomPickerItem("104", "这里是标题6"));
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(builder: (_, setState) {
          return SantoMultiSelectListPicker(
            pickerTitleConfig: SantoPickerTitleConfig(titleContent: "多选 Picker"),
            items: items,
            onItemClick: (_, index) {
              if (items.where((element) => element.isChecked).length > 3) {
                SantoToast.show("选择数目超过了 3 个", context);
                items[index].isChecked = false;
                setState(() {});
              }
            },
            onSubmit: (List<SantoMultiSelectBottomPickerItem> data) {
              var str = "";
              data.forEach((item) {
                str = str + item.content + "  ";
              });
              SantoToast.show(str, context);
              Navigator.of(context).pop();
            },
            onCancel: () {
              SantoToast.show('自定义 cancel 回调', context);
            },
          );
        });
      },
    );
  }

  ///底部有输入框弹框
  void _showBottomWriteDialog(BuildContext context) {
    SantoBottomWritePicker.show(
      context,
      title: '这里是标题',
      hintText: '请输入',
      cancelDismiss: true,
      confirmDismiss: false,
      onConfirm: (context, string) {
        SantoToast.show(string ?? '', context);
        return;
      },
      onCancel: (_) {
        Navigator.of(context).pop();
        return;
      },
      defaultText: "",
    );
  }

  void _showRangePicker(
      BuildContext context, List<SantoPickerEntity> _selectionData) {
    _selectionData.forEach((f) => f.configChild());
    var selectionMenuView = SantoMultiColumnPicker(
      entity: _selectionData[3],
      defaultFocusedIndexes: [0, -1, -1],
      onConfirm: (Map<String, List<SantoPickerEntity>> result, int? firstIndex,
          int? secondIndex, int? thirdIndex) {
        List<String> pickResult = [];
        result.forEach((key, val) {
          List<String> tmp = [];
          val.forEach((item) {
            tmp.add(item.name);
          });
          pickResult.add(tmp.toString());
        });
        SantoToast.show(pickResult.toString(), context);
      },
      onEntityTap: (int columnIndex, int rowIndex, SantoPickerEntity entity) {
        SantoToast.show('$columnIndex + $rowIndex + ${entity.name}', context);
      },
    );
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext dialogContext) {
        return selectionMenuView;
      },
    );
  }

  void _showRangePicker1(
      BuildContext context, List<SantoPickerEntity> _selectionData) {
    _selectionData.forEach((f) => f.configChild());
    String titleName = "测试标题";
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(builder: (context, setState) {
        return SantoMultiColumnPicker(
          pickerTitleConfig: SantoPickerTitleConfig(titleContent: titleName),
          entity: _selectionData[3],
          defaultFocusedIndexes: [0, -1, -1],
          onConfirm: (Map<String, List<SantoPickerEntity>> result,
              int? firstIndex, int? secondIndex, int? thirdIndex) {
            List<String> pickResult = [];
            result.forEach((key, val) {
              List<String> tmp = [];
              val.forEach((item) {
                tmp.add(item.name);
              });
              pickResult.add(tmp.toString());
            });
            SantoToast.show(pickResult.toString(), context);
          },
          onEntityTap: (int columnIndex, int rowIndex, SantoPickerEntity entity) {
            titleName = entity.name;
            setState(() {});
            SantoToast.show('$columnIndex + $rowIndex + ${entity.name}', context);
          },
        );
      }),
    );
  }

  ///标签选择弹框
  void _showTagsPicker(BuildContext context) {
    List<String> tags = [
      '洗衣机池',
      '机池',
      '电冰池',
      '双人床池',
      '电茶池池',
      '洗手池池',
      '电池',
      '洗手池',
      '挖掘池机',
      '抽风机池',
      '可爱多池',
    ];

    SantoTagsPicker(
      context: context,
      tags: tags,
      //排列样式 默认 平均分配排序
      layoutStyle: SantoTagsPickerLayoutStyle.average,
      //一行多少个 默认4个
      crossAxisCount: 4,
      //最大选中数目 - 不设置 或者设置为0 则可以全选
      maxSelectItemCount: 5,
      onItemClick: (int index, bool isSelect) {
        SantoToast.show('$index -> $isSelect', context);
      },
      onMaxSelectClick: () {
        SantoToast.show('最大数值不能超过5个', context);
      },
      pickerTitleConfig: SantoPickerTitleConfig(
        titleContent: '多选标题',
      ),
      tagTextStyle: const TextStyle(color: Color(0xFF515A6E)),
      selectedTagTextStyle: const TextStyle(
          color: Color(0xFF1677FF), fontWeight: FontWeight.w500),
      tagBackgroundColor: const Color(0xffF8F8F8),
      selectedTagBackgroundColor: const Color(0x141677FF),
      onConfirm: (List<int> indexes, String text) {
        SantoToast.show('选中 ${indexes.length} 个标签', context);
      },
      onCancel: () {
        SantoToast.show('点击了取消按钮', context);
      },
    ).show();
  }

  ///标签选择弹框(单选 + 输入框)
  void _showTagsPickerWithInput(BuildContext context) {
    List<String> tags = [
      '我',
      '我是可选择',
      '我是可选择的标签',
      '我是文案特别长独自占一行的样式哦',
      '我是可选择的标签1',
      '我是可选择的标签1',
      '我是可选择的标签1',
    ];

    SantoTagsPicker(
      context: context,
      tags: tags,
      // 单选 + 带输入框
      multiSelect: false,
      showTextInput: true,
      hintText: '请输入',
      maxLength: 100,
      layoutStyle: SantoTagsPickerLayoutStyle.auto,
      pickerTitleConfig: SantoPickerTitleConfig(
        titleContent: '这里是标题文字',
      ),
      tagTextStyle: const TextStyle(color: Color(0xff222222)),
      selectedTagTextStyle: const TextStyle(
          color: Color(0xFF1677FF), fontWeight: FontWeight.w500),
      tagBackgroundColor: const Color(0xffF8F8F8),
      selectedTagBackgroundColor: const Color(0x141677FF),
      onConfirm: (List<int> indexes, String text) {
        SantoToast.show('选中 ${indexes.length} 个标签，输入：$text', context);
      },
    ).show();
  }

  ///底部多级弹框
  void _showMultiDataPicker(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) {
        return MultiPickerExamplePage();
      },
    ));
  }

  ///日期选择控件
  void _showDatePicker(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) {
        return DatePickerExamplePage('日期选择示例');
      },
    ));
  }
}
