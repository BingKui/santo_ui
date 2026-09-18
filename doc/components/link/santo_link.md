---
title: SantoLink
group:
  title: 链接
  order: 1
---

# SantoLink

文字链接组件,支持不同状态、下划线显示/隐藏、前置/后置图标、多种尺寸。

## 一、效果总览

- 支持正常、激活、禁用、已访问四种状态
- 可显示或隐藏下划线
- 支持前置和后置图标
- 三种尺寸档位(small/medium/large)

## 二、描述

### 适用场景
1. 文本中的超链接
2. 导航跳转链接
3. 帮助文档链接
4. 操作入口提示

### 使用规范
- 禁用状态下链接不可点击且颜色变灰
- 已访问状态用于标记用户已点击过的链接
- 下划线默认关闭,需要时显式开启以增强可识别性
- 前后图标用于补充链接含义的视觉提示

## 三、构造函数及参数说明

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| text | String | 链接文字 | 是 | - |
| href | String? | 链接地址(仅用于语义) | 否 | null |
| state | SantoLinkState | 链接状态(normal/active/disabled/visited) | 否 | normal |
| underline | bool | 是否显示下划线 | 否 | false |
| prefixIcon | IconData? | 前置图标 | 否 | null |
| suffixIcon | IconData? | 后置图标 | 否 | null |
| size | SantoLinkSize | 链接尺寸(small/medium/large) | 否 | medium |
| color | Color? | 链接颜色 | 否 | null(主题色) |
| onTap | VoidCallback? | 点击回调 | 否 | null |
| textStyle | TextStyle? | 文字样式 | 否 | null |

## 四、示例代码

### 基础用法

```dart
SantoLink(
  text: '查看详情',
  onTap: () {},
)
```

### 带下划线

```dart
SantoLink(
  text: '了解更多',
  underline: true,
  onTap: () {},
)
```

### 禁用状态

```dart
SantoLink(
  text: '暂不可用',
  state: SantoLinkState.disabled,
)
```

### 带图标

```dart
SantoLink(
  text: '外部链接',
  prefixIcon: Icons.link,
  suffixIcon: Icons.open_in_new,
  onTap: () {},
)
```

### 小尺寸链接

```dart
SantoLink(
  text: '帮助',
  size: SantoLinkSize.small,
  onTap: () {},
)
```
