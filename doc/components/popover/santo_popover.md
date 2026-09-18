---
title: SantoPopover
group:
  title: 气泡弹出框
  order: 1
---

# SantoPopover

从锚点位置弹出的气泡内容框,支持多个方向弹出,支持自定义内容和三角箭头。

## 一、效果总览

- 从指定锚点位置弹出
- 支持上/下/左/右四个弹出方向
- 带三角箭头指向锚点
- 可自定义背景色、圆角、内边距
- 点击遮罩自动关闭

## 二、描述

### 适用场景
1. 按钮的功能说明或提示
2. 快捷操作菜单
3. 详细信息浮层
4. 上下文帮助提示

### 使用规范
- 必须为锚点组件创建 GlobalKey 并传入 target 参数
- direction 决定弹出方向,组件会自动计算位置避免超出屏幕
- showArrow 为 false 时不显示三角箭头
- 通过 onDismiss 回调可监听关闭事件

## 三、构造函数及参数说明

### SantoPopover.show()

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| context | BuildContext | 上下文 | 是 | - |
| target | GlobalKey | 锚点组件的 GlobalKey | 是 | - |
| content | Widget | 气泡内容 | 是 | - |
| direction | SantoPopoverDirection | 弹出方向(top/bottom/left/right) | 否 | bottom |
| showArrow | bool | 是否显示三角箭头 | 否 | true |
| backgroundColor | Color? | 气泡背景颜色 | 否 | null(#1A1A1A) |
| radius | double | 气泡圆角 | 否 | 12 |
| arrowSize | double | 箭头大小 | 否 | 8 |
| offset | double | 与锚点的偏移距离 | 否 | 4 |
| onDismiss | SantoPopoverDismissCallback? | 关闭回调 | 否 | null |
| barrierColor | Color | 遮罩颜色 | 否 | transparent |
| contentPadding | EdgeInsets? | 内容区域内边距 | 否 | null |

## 四、示例代码

### 基础用法

```dart
final key = GlobalKey();

ElevatedButton(
  key: key,
  onPressed: () {
    SantoPopover.show(
      context: context,
      target: key,
      content: const Text('这是提示信息'),
    );
  },
  child: const Text('显示提示'),
)
```

### 自定义样式

```dart
SantoPopover.show(
  context: context,
  target: key,
  direction: SantoPopoverDirection.top,
  backgroundColor: Colors.white,
  radius: 8,
  contentPadding: const EdgeInsets.all(12),
  content: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      ListTile(
        leading: const Icon(Icons.edit),
        title: const Text('编辑'),
        onTap: () {},
      ),
      ListTile(
        leading: const Icon(Icons.delete),
        title: const Text('删除'),
        onTap: () {},
      ),
    ],
  ),
)
```

### 不显示箭头

```dart
SantoPopover.show(
  context: context,
  target: key,
  showArrow: false,
  content: const Text('无边框提示'),
)
```
