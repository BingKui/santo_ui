---
title: SantoDrawer / SantoBottomDrawer
group:
  title: 抽屉
  order: 1
---

# SantoDrawer / SantoBottomDrawer

侧边滑出面板和底部弹出抽屉,用于展示辅助内容或操作选项。

## 一、效果总览

**SantoDrawer**:
- 支持左/右/上/下四个方向滑出
- 带遮罩层,可点击关闭
- 通过静态方法 `show()` 打开

**SantoBottomDrawer**:
- 从底部弹出的抽屉面板
- 带标题/描述 Header 和关闭按钮
- 支持自适应内容高度或固定高度
- 顶部圆角设计

## 二、描述

### 适用场景

**SantoDrawer**:
1. 侧边导航菜单
2. 筛选条件面板
3. 详细信息展示

**SantoBottomDrawer**:
1. 底部操作选项
2. 分享面板
3. 快捷设置
4. 表单输入弹窗

### 使用规范
- SantoDrawer 需指定方向,左右方向用 width,上下方向用 height
- SantoBottomDrawer 默认处理底部安全区域
- barrierDismissible 为 false 时需显式提供关闭方式
- 内容区**自动可滚动**:高度自适应时最多顶到 `maxHeight`(默认屏幕 85%),超出后内容区滚动,长内容不会溢出,调用方无需自己套滚动控件

## 三、构造函数及参数说明

### SantoDrawer.show()

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| context | BuildContext | 上下文 | 是 | - |
| direction | SantoDrawerDirection | 抽屉方向(left/right/top/bottom) | 否 | right |
| width | double | 抽屉宽度(左右方向) | 否 | 300 |
| height | double | 抽屉高度(上下方向) | 否 | 300 |
| maskColor | Color? | 遮罩层颜色 | 否 | null(半透明黑色) |
| child | Widget | 抽屉内容 | 是 | - |
| barrierDismissible | bool | 点击遮罩是否可关闭 | 否 | true |

### SantoBottomDrawer.show()

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| context | BuildContext | 上下文 | 是 | - |
| title | String? | 标题文案 | 否 | null |
| titleWidget | Widget? | 自定义标题控件 | 否 | null |
| desc | String? | 描述文案 | 否 | null |
| titleAlign | SantoBottomDrawerTitleAlign | 标题对齐(left/center) | 否 | left |
| showCloseButton | bool | 是否显示关闭按钮 | 否 | true |
| onClose | VoidCallback? | 关闭回调 | 否 | null |
| barrierDismissible | bool | 点击遮罩是否关闭 | 否 | true |
| maskColor | Color? | 遮罩层颜色 | 否 | null |
| height | double? | 固定高度 | 否 | null(自适应) |
| maxHeight | double? | 自适应时最大高度 | 否 | null(屏幕85%) |
| radius | double | 顶部圆角 | 否 | 12 |
| backgroundColor | Color? | 背景色 | 否 | null(白色) |
| bottomSafeArea | bool | 是否处理底部安全区域 | 否 | true |
| contentPadding | EdgeInsets | 内容区内边距 | 否 | all(20) |
| child | Widget | 内容区控件 | 是 | - |

## 四、示例代码

### SantoDrawer 基础用法

```dart
SantoDrawer.show(
  context: context,
  direction: SantoDrawerDirection.right,
  width: 280,
  child: ListView(
    children: const [
      ListTile(title: Text('选项1')),
      ListTile(title: Text('选项2')),
    ],
  ),
)
```

### SantoBottomDrawer 基础用法

```dart
SantoBottomDrawer.show(
  context: context,
  title: '选择操作',
  desc: '请选择要执行的操作',
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      ListTile(
        leading: const Icon(Icons.share),
        title: const Text('分享'),
        onTap: () {},
      ),
      ListTile(
        leading: const Icon(Icons.download),
        title: const Text('下载'),
        onTap: () {},
      ),
    ],
  ),
)
```

### 固定高度的底部抽屉

```dart
SantoBottomDrawer.show(
  context: context,
  title: '筛选条件',
  height: 400,
  child: SingleChildScrollView(
    child: Column(
      children: [
        // 筛选内容
      ],
    ),
  ),
)
```
