---
title: SantoBadge
group:
  title: 徽标
  order: 1
---

# SantoBadge

在组件右上角显示数字或红点徽标,常用于消息通知计数场景。

## 一、效果总览

- 支持数字模式和红点模式两种展示方式
- 可自定义最大数字阈值,超过后显示 "maxCount+"
- 支持完全自定义徽标内容
- 通过 Stack 叠加在子组件右上角

## 二、描述

### 适用场景
1. 消息通知数量提示(如未读消息数)
2. 状态标记(如红点提醒)
3. 需要轻量级数字提示的场景

### 使用规范
- count 为 0 且非红点模式时默认不显示,可通过 `showZero` 强制显示
- 数字超过 `maxCount` 时自动显示为 "maxCount+"
- 可通过 `offset` 微调徽标位置以适应不同场景
- `badgeContent` 优先级高于 `count` 和 `isDot`,用于完全自定义徽标内容

## 三、构造函数及参数说明

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| count | int? | 显示的数字 | 否 | null |
| isDot | bool | 是否为红点模式 | 否 | false |
| color | Color? | 徽标背景颜色 | 否 | null(主题错误色) |
| textColor | Color? | 文字颜色 | 否 | null(白色) |
| maxCount | int | 最大数字,超过后显示 "maxCount+" | 否 | 99 |
| badgeSize | double | 徽标尺寸 | 否 | 18 |
| offset | Offset? | 徽标偏移量 | 否 | null |
| child | Widget? | 被包裹的子组件 | 否 | null |
| badgeContent | Widget? | 自定义徽标内容 | 否 | null |
| showZero | bool | count 为 0 时是否显示 | 否 | false |

## 四、示例代码

### 基础用法

```dart
SantoBadge(count: 5, child: Icon(Icons.mail))
```

### 红点模式

```dart
SantoBadge(isDot: true, child: Icon(Icons.notifications))
```

### 自定义最大值

```dart
SantoBadge(count: 120, maxCount: 99, child: Icon(Icons.message))
// 显示 "99+"
```

### 始终显示零

```dart
SantoBadge(count: 0, showZero: true, child: Icon(Icons.chat))
```

### 自定义内容

```dart
SantoBadge(
  badgeContent: const Text('新'),
  child: Icon(Icons.shopping_cart),
)
```

### 自定义位置和颜色

```dart
SantoBadge(
  count: 3,
  color: Colors.orange,
  offset: const Offset(4, -4),
  child: const Icon(Icons.favorite),
)
```
