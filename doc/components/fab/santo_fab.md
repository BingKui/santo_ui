---
title: SantoFab
group:
  title: 悬浮按钮
  order: 1
---

# SantoFab

页面悬浮操作按钮,支持圆形和扩展形(带文字)两种形态。

## 一、效果总览

- 支持纯图标的圆形按钮
- 支持带文字的扩展形按钮
- 提供静态方法 `positioned()` 用于 Stack 中带定位
- 自带阴影效果

## 二、描述

### 适用场景
1. 主要操作入口(如新建、添加)
2. 快速返回顶部
3. 聊天/客服入口
4. 任何需要突出显示的核心操作

### 使用规范
- 设置 text 后自动切换为扩展形(圆角矩形)
- 可通过 shape 显式指定形状
- positioned() 方法用于在 Stack 中固定到某个角落
- elevation 控制阴影强度,影响视觉层次

## 三、构造函数及参数说明

### SantoFab

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| icon | IconData? | 按钮图标 | 否 | null |
| text | String? | 按钮文字 | 否 | null |
| onPressed | VoidCallback? | 点击回调 | 否 | null |
| backgroundColor | Color? | 背景色 | 否 | null(brandPrimary) |
| iconColor | Color? | 图标颜色 | 否 | null(白色) |
| textColor | Color? | 文字颜色 | 否 | null(白色) |
| size | double | 按钮大小(圆形时为直径) | 否 | 56 |
| shape | SantoFabShape? | 按钮形状(circle/extended) | 否 | null(有text时自动扩展形) |
| child | Widget? | 自定义子组件 | 否 | null |
| elevation | double | 阴影高度 | 否 | 2 |

### SantoFab.positioned()

额外参数:

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| position | SantoFabPosition | 位置(bottomRight/bottomLeft/topRight/topLeft) | 否 | bottomRight |
| edgeOffset | double | 距边缘的距离 | 否 | 16 |

## 四、示例代码

### 圆形按钮

```dart
SantoFab(
  icon: Icons.add,
  onPressed: () {},
)
```

### 扩展形按钮(带文字)

```dart
SantoFab(
  icon: Icons.edit,
  text: '编辑',
  onPressed: () {},
)
```

### 固定在右下角

```dart
Stack(
  children: [
    // 页面内容
    ListView(...),
    
    SantoFab.positioned(
      icon: Icons.chat,
      onPressed: () {},
      position: SantoFabPosition.bottomRight,
      edgeOffset: 20,
    ),
  ],
)
```

### 自定义颜色和尺寸

```dart
SantoFab(
  icon: Icons.favorite,
  backgroundColor: Colors.red,
  size: 64,
  elevation: 4,
  onPressed: () {},
)
```
