---
title: SantoEmpty
group:
  title: 空页面
  order: 1
---

# SantoEmpty

异常页面展示,一般用于网络错误、数据为空的提示和引导。支持图片、标题、内容、操作区。

## 一、效果总览

- 支持自定义图片和文案
- 支持单按钮/双按钮/文本按钮三种操作区类型
- 内容区域可垂直居中
- 支持页面点击回调
- 可通过主题配置统一样式

## 二、描述

### 适用场景
1. 列表数据为空时的占位
2. 网络请求失败的提示
3. 搜索无结果的展示
4. 权限不足的提示
5. 任何需要友好提示的空状态场景

### 使用规范
- operateAreaType 决定操作区布局:singleButton/doubleButton/textButton
- operateTexts 长度应与按钮数量匹配
- isCenterVertical 为 true 时内容垂直居中,适合短页面
- topPercent 控制内容距顶部的百分比位置
- enablePageTap 开启后整个页面可点击,常用于点击空白处重试

## 三、构造函数及参数说明

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| imageType | SantoEmptyImageType? | 内置插画类型 noData / networkError,配置不同类型展示不同插画 | 否 | null(不展示图片) |
| img | Image? | 自定义图片,优先级高于 imageType;两者都不传时不展示图片 | 否 | null |
| title | String? | 标题 | 否 | null |
| content | String? | 内容 | 否 | null |
| operateAreaType | OperateAreaType | 操作区类型(singleButton/doubleButton/textButton) | 否 | textButton |
| operateTexts | List\<String\>? | 操作区文案 | 否 | null |
| action | SantoEmptyStatusIndexedActionClickCallback? | 点击事件回调 (index) | 否 | null |
| enablePageTap | bool | 是否可点击页面 | 否 | false |
| topOffset | double? | 顶部距离 | 否 | null(父视图8%) |
| backgroundColor | Color | 背景色 | 否 | white |
| isCenterVertical | bool | 内容垂直居中 | 否 | false |
| topPercent | double | 距顶部高度百分比 | 否 | 0.08 |
| themeData | SantoAbnormalStateConfig? | 主题配置 | 否 | null |

## 四、示例代码

### 基础空状态

```dart
SantoEmpty(
  title: '暂无数据',
  content: '当前分类下还没有内容',
)
```

### 带单个操作按钮

```dart
SantoEmpty(
  title: '加载失败',
  content: '网络连接异常,请检查网络后重试',
  operateAreaType: OperateAreaType.singleButton,
  operateTexts: const ['重新加载'],
  action: (index) {
    if (index == 0) loadData();
  },
)
```

### 带两个操作按钮

```dart
SantoEmpty(
  title: '权限不足',
  content: '您需要登录才能查看此内容',
  operateAreaType: OperateAreaType.doubleButton,
  operateTexts: const ['取消', '去登录'],
  action: (index) {
    if (index == 1) navigateToLogin();
  },
)
```

### 垂直居中

```dart
SantoEmpty(
  title: '搜索无结果',
  content: '换个关键词试试',
  isCenterVertical: true,
)
```

### 自定义图片

```dart
SantoEmpty(
  img: Image.asset('assets/empty_box.png', width: 120),
  title: '购物车是空的',
  content: '快去挑选心仪的商品吧',
  operateAreaType: OperateAreaType.singleButton,
  operateTexts: const ['去逛逛'],
  action: (_) => navigateToShop(),
)
```

## 版本变更

### v1.1.1
- **新增**: `SantoEmptyImageType` 枚举与 `SantoEmpty.imageType` 参数,配置不同类型展示包内内置插画(noData / networkError)
- **变更**: 不配置 `imageType` 与 `img` 时默认不展示图片,只展示文字
- **变更**: `SantoAbnormalStateUtils` 内部改用 `imageType` 提供预设插画,`img` 自定义参数继续生效且优先级最高
