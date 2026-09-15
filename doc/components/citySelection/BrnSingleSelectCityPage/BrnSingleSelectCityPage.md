---
title: SantoSingleSelectCityPage
group:
  title: SelectCity
  order: 27
---

# SantoSingleSelectCityPage

## 一、效果总览

![](./img/SantoSingleSelectCityPageIntro.png)

## 二、描述

### 适用场景

`SantoSingleSelectCityPage`是用于城市选择的单选页面，可以自定制导航栏文案，搜索文案信息，定位信息，右侧可快速滑动查看城市。

## 三、构造函数及参数说明

### 构造函数

```dart
SantoSingleSelectCityPage({
    this.appBarTitle = '',
    this.hotCityTitle = '',
    this.hotCityList,
    this.cityList,
    this.showSearchBar = true,
    this.locationText = '',
    this.onValueChanged,
    this.emptyImage,
  });
```



### 参数说明

| **参数名** | **参数类型** | **描述** | **是否必填** | **默认值** |
| --- | --- | --- | --- | --- |
| appBarTitle | String? | 导航栏标题 | 否 | "" |
| hotCityTitle | String? | 热门推荐标题 | 否 | "" |
| showSearchBar | bool | 是否展示searchBar | 否 |  |
| locationText | String | 当前定位城市文案 | 否 | "" |
| cityList | `List<SantoSelectCityModel>?` | 城市列表 | 否 |  |
| onValueChanged | ValueChanged<SantoSelectCityModel>? | 点击时间 | 否 |  |
| hotCityList | `List<SantoSelectCityModel>?` | 热门推荐城市列表 | 否 |  |
| emptyImage | `Image?` | 暂无搜索结果页面占位图 | 否 |  |

### 其它数据


```dart

/// 页面标题，默认空
final String? appBarTitle;

/// 热门推荐标题，默认空
final String? hotCityTitle;

/// 是否展示searchBar，默认 true
final bool showSearchBar;

/// 当前城市定位文案展示
final String locationText;

/// 城市列表
final List<SantoSelectCityModel>? cityList;

/// 热门推荐城市列表
final List<SantoSelectCityModel> hotCityList;

/// 单选项 点击的回调
final ValueChanged<SantoSelectCityModel>? onValueChanged;

/// 空页面中间展位图展示
final Image? emptyImage;
  
  ///城市信息  
SantoSelectCityModel {
  /// 城市名称
  String name = "";

  /// 城市名称前这是的标记符号 
  String tagIndex = "";

  /// 拼音
  String? namePinyin;

  String tag = "";

  /// 城市编码
  String cityCode = ""; 
}
```


## 四、代码展示

### 效果1

<img src="./img/SantoSingleSelectCityPageDemo1.png" style="zoom: 33%;" />

```dart
   List<SantoSelectCityModel> hotCityList = [];
    hotCityList.addAll([
      SantoSelectCityModel(name: "北京市"),
      SantoSelectCityModel(name: "广州市"),
      SantoSelectCityModel(name: "成都市"),
      SantoSelectCityModel(name: "深圳市"),
      SantoSelectCityModel(name: "杭州市"),
      SantoSelectCityModel(name: "武汉市"),
    ]);
    return SantoSingleSelectCityPage(
      appBarTitle: '城市单选',
      hotCityTitle: '这里是推荐城市',
      hotCityList: hotCityList,
    );
   			
```