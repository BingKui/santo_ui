---
title: SantoPortraitRadioGroup
group:
  title: Form
  order: 12
---

# SantoPortraitRadioGroup

垂直单选列表 表单项

## 一、效果总览

![](./img/SantoPortraitRadioGroupDemo1.png)
<img src="./img/SantoPortraitRadioGroupDemo2.png" style="zoom:67%;" />

## 二、描述

### 适用场景

用于数据录入、选择场景。

## 三、构造函数及参数说明

### 构造函数

#### 简单列表构造函数


```dart
SantoPortraitRadioGroup.withSimpleList({
  Key? key,
  this.isEdit = true,
  String selectedOption = "",
  required List<String> options,
  this.enableList,
  this.onChanged,
  this.themeData,
  this.isCollapseContent = false,
})  : this.options = options
          .map((item) => SantoPortraitRadioGroupOption(title: item))
          .toList(),
      this.selectedOption = options.indexOf(selectedOption) > -1
          ? SantoPortraitRadioGroupOption(
              title: options[options.indexOf(selectedOption)])
          : SantoPortraitRadioGroupOption(),
      super(key: key) {
  this.themeData ??= SantoFormItemConfig();
  this.themeData = SantoThemeConfigurator.instance
      .getConfig(configId: this.themeData!.configId)
      .formItemConfig
      .merge(this.themeData);
}
```
### 参数说明

| **参数名** | **参数类型** | **描述** | **是否必填** | **默认值** |
| --- | --- | --- | --- | --- |
| isEdit | bool | 组件是否可编辑 | 否 | 无 |
| selectedOption | String | 默认选中的选项，与 options 中数据匹配 | 否 | '' |
| options | `List<String>` | 数据源 | 否 | 是 |
| enableList | `List<bool> `| 是否可用的状态 | 否 | 否 |
| onChanged | void Function(SantoRadioChoiceOption oldStr, SantoRadioChoiceOption newStr) | 返回选中未选中的数据格式 | 否 | 无 |
| isCollapseContent |  bool | options 中 title subTitle 是否换行展示。false: 换行展示true: 只展示一行，一行展示不下末尾[...]省略展示**默认值为 false：换行展示；** | 否 |  false |
| themeData | SantoFormItemConfig? | 表单项配置类，具体配置详见SantoFormItemConfig | 否 |  |

#### 带数据格式的构造函数


```dart
SantoPortraitRadioGroup.withOptions({
  Key? key,
  this.isEdit = true,
  this.selectedOption,
  this.options,
  this.enableList,
  this.onChanged,
  this.isCollapseContent = false,
  this.themeData,
}) :super(key: key){
  this.themeData ??= SantoFormItemConfig();
  this.themeData = SantoThemeConfigurator.instance
      .getConfig(configId: this.themeData!.configId)
      .formItemConfig
      .merge(this.themeData);
}
```
### 参数说明

| **参数名** | **参数类型** | **描述** | **是否必填** | **默认值** |
| --- | --- | --- | --- | --- |
| isEdit | bool | 组件是否可编辑 | 否 | True |
| selectedOption | SantoRadioChoiceOption? | 默认选中的选项，与 options 中数据匹配 | 否 | 无 |
| options | `List<SantoRadioChoiceOption>?` | 数据源 | 否 | 否 |
| enableList | `List<bool>?` | 是否可用的状态 | 否 | 否 |
| onChanged | void Function(SantoRadioChoiceOption oldStr, SantoRadioChoiceOption newStr) | 返回选中未选中的数据格式 | 否 | 无 |
| isCollapseContent | bool | options 中 title subTitle 是否换行展示。false: 换行展示true: 只展示一行，一行展示不下末尾[...]省略展示默认值为 false：换行展示； | 否 | false |
| themeData | SantoFormItemConfig? | 表单项配置类，具体配置详见SantoFormItemConfig | 否 |  |

#### 组件内部数据 Item 的结构（支持 subTitle 的展示）


```dart
class SantoPortraitRadioGroupOption {
  String? title;
  String? subTitle;
  SantoPortraitRadioGroupOption({this.title, this.subTitle});
}
```
## 四、代码演示

### 效果1

![](./img/SantoPortraitRadioGroupDemo1.png)
```dart
SantoPortraitRadioGroupOption selectedValue;

SantoPortraitRadioGroup.withSimpleList(
  options: [
    '用户报修项错误',
    '有同时段其他地址订单',
    '不在我服务范围',
    '其他'
  ],
  selectedOption: selectedValue?.title,
  onChanged: (SantoPortraitRadioGroupOption old,
      SantoPortraitRadioGroupOption newList) {
    SantoToast.show(newList.title, context);
    selectedValue = newList;
    commentStr = '';
    setState(() {});
  },
)
```
### 效果2: 标题子标题 换行展示

![](./img/SantoPortraitRadioGroupDemo2.png)
```dart
SantoPortraitRadioGroup.withOptions(
  isCollapseContent: false,
  options: List.generate(3, (index) {
    return SantoPortraitRadioGroupOption(
        title:
            '$index esubtn你好  哈哈哈哈哈哈啊哈哈哈哈哈哈哈哈 子标题esubtn你好  哈哈哈哈哈哈啊哈哈哈哈哈哈哈哈 子标题',
        subTitle: 'subtitlesubtn你好  哈哈哈哈哈哈啊哈哈哈哈哈子标题哈哈哈 子标题子标题');
  }),
  selectedOption: selectedValue,
  onChanged: (SantoPortraitRadioGroupOption old,
      SantoPortraitRadioGroupOption newList) {
    SantoToast.show(newList.title, context);
    selectedValue = newList;
    commentStr = '';
    setState(() {});
  },
)
```

