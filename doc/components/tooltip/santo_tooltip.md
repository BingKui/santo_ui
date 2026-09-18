---
title: SantoTooltip / SantoPopupListWindow
group:
  title: 悬浮窗
  order: 2
---

# SantoTooltip / SantoPopupListWindow

通用 Tooltip 文字提示,带三角箭头。支持上/下方向弹出,自动计算位置避免超出屏幕。

## 一、效果总览

- 从锚点位置弹出文字提示
- 带三角箭头指向锚点
- 自动计算位置避免超出屏幕
- 支持自定义文本样式、背景色、边框
- 提供 `SantoTooltip.show()` 静态方法
- `SantoPopupListWindow` 用于弹窗列表

## 二、描述

### 适用场景
1. 按钮的功能说明
2. 表单项的帮助提示
3. 图表数据点的详细说明
4. 任何需要轻量级文字提示的场景

### 使用规范
- 必须为锚点组件创建 GlobalKey 并传入 popKey
- text 和 widget 二选一,widget 优先级更高用于自定义内容
- popDirection 决定优先弹出方向,组件会自动调整避免超出屏幕
- hasCloseIcon 为 true 时显示关闭图标,用户需手动关闭
- turnOverFromBottom 控制距底部小于此值时自动切换到上方弹出

## 三、构造函数及参数说明

### SantoTooltip.show()

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| context | dynamic | 上下文 | 是 | - |
| text | String? | 显示的文本 | 是 | - |
| popKey | GlobalKey | 共享的 GlobalKey | 是 | - |
| popDirection | SantoPopupDirection | 弹出方向(top/bottom) | 否 | bottom |
| arrowHeight | double | 箭头高度 | 否 | 6.0 |
| textStyle | TextStyle? | 文本样式 | 否 | 白色16号 |
| backgroundColor | Color? | 背景颜色 | 否 | #1A1A1A |
| hasCloseIcon | bool | 是否显示关闭图标 | 否 | false |
| offset | double | 垂直偏移量 | 否 | 0 |
| widget | Widget? | 自定义 pop 视图 | 否 | null |
| paddingInsets | EdgeInsets | 容器内边距 | 否 | L20 T15 R20 B15 |
| radius | double | 容器圆角 | 否 | 12 |
| borderColor | Color? | 边框颜色 | 否 | transparent |
| borderWidth | double | 边框宽度 | 否 | 1 |
| canWrap | bool | 是否多行显示 | 否 | false |
| spaceMargin | double | 距离边线距离 | 否 | 20 |
| arrowOffset | double? | 箭头水平偏移 | 否 | null(自动) |
| dismissCallback | VoidCallback? | 消失回调 | 否 | null |
| turnOverFromBottom | double | 距底部小于此值时自动在上方弹出 | 否 | 50.0 |

## 四、示例代码

### 基础用法

```dart
final key = GlobalKey();

ElevatedButton(
  key: key,
  onPressed: () {
    SantoTooltip.show(
      context: context,
      text: '这是提示信息',
      popKey: key,
    );
  },
  child: const Text('显示提示'),
)
```

### 上方弹出

```dart
SantoTooltip.show(
  context: context,
  text: '重要提示',
  popKey: key,
  popDirection: SantoPopupDirection.top,
)
```

### 自定义样式

```dart
SantoTooltip.show(
  context: context,
  text: '自定义样式的提示',
  popKey: key,
  backgroundColor: Colors.white,
  textStyle: const TextStyle(color: Colors.black),
  borderColor: Colors.grey,
  borderWidth: 1,
)
```

### 多行文本

```dart
SantoTooltip.show(
  context: context,
  text: '这是一段很长的提示文本\n可以包含多行内容',
  popKey: key,
  canWrap: true,
)
```

### 带关闭图标

```dart
SantoTooltip.show(
  context: context,
  text: '请阅读后关闭',
  popKey: key,
  hasCloseIcon: true,
)
```
