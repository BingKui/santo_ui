---
title: SantoMultiSelectListPicker
group:
  title: Picker
  order: 23
---

# SantoMultiSelectListPicker

多选底部弹框 ，适用于从页面底部弹出，存在多选列表的情况。

相似组件有：

[SantoMultiSelectTagsPicker](../widgets/santo-multi-select-tags-picker)从底部弹出的 Tag 样式多选。

[SantoMultiSelectDialog](../widgets/santo-multi-select-dialog) 从页面中部弹出多选弹窗。

## 一、效果总览

<img src="./img/SantoMultiSelectListPicker.png" style="zoom: 33%;" />

## 二、描述

### 适用场景

1. 多选列表，适用于从底部弹出的情况，属于 Picker
2. 可设置默认选中状态

## 三、构造函数及参数配置

### 构造函数

```dart
SantoMultiSelectListPicker({
    Key? key,
    this.title,
    required this.items,
    this.pickerTitleConfig = SantoPickerTitleConfig.Default,
    this.onSubmit,
    this.onCancel,
    this.onItemClick,
  }) : super(key: key);
```

### 参数说明

| 参数名            | 参数类型                                                     | 作用                                                         | 是否必填 | 默认值                       |
| ----------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | -------- | ---------------------------- |
| items             | `List<SantoMultiSelectBottomPickerItem>`                       | 数据源                                                       | 是       |                              |
| pickerTitleConfig | SantoPickerTitleConfig                                         | 设置 Picker 主题                                             | 否       | SantoPickerTitleConfig.Default |
| onSubmit          | `SantoMultiSelectListPickerSubmit = bool Function(List<SantoMultiSelectBottomPickerItem> checkedItems)?` | 点击【完成】时回调给外部选中的数据                           | 否       |                              |
| onItemClick       | `SantoMultiSelectListPickerItemClick = void Function(BuildContext context, int index)?` | Item 被点击的回调                                            | 否       |                              |
| isDismissible     | bool                                                         | 是否可电机外部关闭弹窗，true 点击外部关闭弹窗。只在`show`方法里才有 | 否       | true                         |
| onCancel          | VoidCallback?                                                | 点击取消时的回调                                             | 否       |                              |

### 其它数据结构

`SantoMultiSelectBottomPickerItem` 多选 Item 数据结构

```dart
class SantoMultiSelectBottomPickerItem{
 String code; //选项编号
 String content; //选项内容
 bool isChecked; //是否选中
 MultiSelectBottomPickerItem(this.code, this.content,{ this.isChecked:false});
}
```

`SantoPickerTitleConfig` 数据配置

```dart
SantoPickerTitleConfig({
  this.cancel,
  this.confirm,
  this.title,
  this.showTitle: PICKER_SHOW_TITLE_DEFAULT,
  this.titleContent,
});
```

## 四、效果及代码展示

### 效果 1: 页面底部 Picker 多选

<img src="./img/SantoMultiSelectListPicker.png" style="zoom: 33%;" />

```dart
List<SantoMultiSelectBottomPickerItem> items = [];
items.add(new SantoMultiSelectBottomPickerItem("100", "这里是标题1"));
items.add(new SantoMultiSelectBottomPickerItem("101", "这里是标题2"));
items.add(new SantoMultiSelectBottomPickerItem("102", "这里是标题3", isChecked: true));
items.add(new SantoMultiSelectBottomPickerItem("103", "这里是标题4", isChecked: true));
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
```

### 效果 2：页面底部 Picker 多选，限制多选数目，并手动触发 UI 更新

<img src="./img/SantoMultiSelectListPicker.png" style="zoom: 33%;" />

```dart
List<SantoMultiSelectBottomPickerItem> items = [];
items.add(new SantoMultiSelectBottomPickerItem("100", "这里是标题1"));
items.add(new SantoMultiSelectBottomPickerItem("101", "这里是标题2"));
items.add(new SantoMultiSelectBottomPickerItem("102", "这里是标题3", isChecked: true));
items.add(new SantoMultiSelectBottomPickerItem("103", "这里是标题4", isChecked: true));
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
            SantoToast.showAutoGravity("选择数目超过了 3 个", context);
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
```

### 效果 3：页面底部 Picker 多选，自定义数据协议

<img src="./img/SantoMultiSelectListPicker.png" style="zoom: 33%;" />

```dart
List<ExpendMultiSelectBottomPickerItem> items = [];
items.add(new ExpendMultiSelectBottomPickerItem("100", "这里是标题1",attribute1: "第一条自定义参数1"));
items.add(new ExpendMultiSelectBottomPickerItem("101", "这里是标题2",attribute1: "第二条自定义参数2"));
items.add(new ExpendMultiSelectBottomPickerItem("102", "这里是标题3", isChecked: true,attribute1: "第三条自定义参数3"));
items.add(new ExpendMultiSelectBottomPickerItem("103", "这里是标题4", isChecked: true));
items.add(new ExpendMultiSelectBottomPickerItem("104", "这里是标题5"));
items.add(new ExpendMultiSelectBottomPickerItem("104", "这里是标题6"));
SantoMultiSelectListPicker.show<ExpendMultiSelectBottomPickerItem>(
  context,
  items: items,
  pickerTitleConfig: SantoPickerTitleConfig(titleContent: "多选 Picker"),
  onSubmit: (List<ExpendMultiSelectBottomPickerItem> data) {
    var str = "";
    data.forEach((item) {
      String attribute = item.attribute1 ?? ""; //处理自定义字段
      str = str + attribute;
    });
    SantoToast.show(str, context);
    Navigator.of(context).pop();
  },
);
```



自定义数据协议（继承基类：SantoMultiSelectBottomPickerItem）

```dart
class ExpendMultiSelectBottomPickerItem extends SantoMultiSelectBottomPickerItem {
  final String? attribute1;
  final String? attribute2;
  final String? attribute3;
  String code; //选项编号
  String content; //选项内容
  bool isChecked; //是否选中

  ExpendMultiSelectBottomPickerItem(
    this.code,
    this.content, {
    this.attribute1,
    this.attribute2,
    this.attribute3,
    this.isChecked = false,
  }) : super(code, content, isChecked: isChecked);
}
```
