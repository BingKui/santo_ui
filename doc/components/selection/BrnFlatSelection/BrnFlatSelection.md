---
title: SantoFlatSelection
group:
  title: Selection
  order: 28
---


# SantoFlatSelection

区间+输入混合一级筛选。

## 一、效果总览

<img src="./img/SantoFlatSelectionIntro.png" style="zoom:67%;" />


## 二、描述

### 适用场景

一级平铺筛选，目前应用pad上。

## 三、构造函数及参数说明

### 构造函数


```dart
SantoFlatSelection(
  {Key? key,
  this.entityDataList,
  this.confirmCallback,
  this.onCustomFloatingLayerClick,
  this.preLineTagSize = 3,
  this.isNeedConfigChild = true,
  this.controller,
  this.themeData}) {
  this.themeData ??= SantoSelectionConfig();
  this.themeData = SantoThemeConfigurator.instance
    .getConfig(configId: themeData.configId)
    .selectionConfig
    .merge(themeData);
}
```


### 参数说明

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| entityDataList | `List<SantoSelectionEntity>` | 筛选原始数据 | 是 | 无 |
| confirmCallback | `Function(Map<String, String>)?` | 确定回调 | 否 | 无 |
| preLineTagSize | int | 每行展示tag数 | 是 | 3 |
| onCustomFloatingLayerClick | SantoOnCustomFloatingLayerClick? | 自定义事件处理 | 否 | 无 |
| isNeedConfigChild | bool | 是否需要配置子选项 | 是 | true |
| controller | SantoFlatSelectionController? | 自定义controller | 否 | 无 |
| themeData | SantoSelectionConfig? | 筛选项主题配置，配置详见SantoSelectionConfig | 否 | |

## 四、代码演示

### 效果1

<img src="./img/SantoFlatSelectionDemo1.png" style="zoom:50%;" />

```dart
SantoFlatSelection(  
  entityDataList: widget._filterData,  
  confirmCallback: (data) {  
    String str = '';  
    data.forEach((k, v) => str=str +" "+'${k}: ${v}');  
    SantoToast.show(str, context);  
  },  
  controller: controller)
```
### 效果2

<img src="./img/SantoFlatSelectionDemo2.png" style="zoom:50%;" />

```dart
SantoFlatSelection(  
  preLineTagSize: 4,  
  entityDataList: widget._filterData,  
  confirmCallback: (data) {  
    String str = '';  
    data.forEach((k, v) => str=str +" "+'${k}: ${v}');  
    SantoToast.show(str, context);  
  },  
  controller: controller)
```

