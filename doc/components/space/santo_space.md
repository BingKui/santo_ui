---
title: SantoSpace
group:
  title: 布局
  order: 2
---

# SantoSpace

间距组件:为多个元素之间统一增加水平/垂直 gap,参考 Ant Design 的 Space。

## 一、效果总览

支持三档预设间距(小 8 / 中 16 / 大 24)、自定义间距、自动换行。

## 二、描述

### 适用场景
1. 同组按钮/标签/文字之间统一留白。
2. 替代手写 `SizedBox` 序列,保证间距一致性。

### 使用规范
- 页面内同层级的间距建议统一使用同一档位。
- 仅需要一个固定空隙时可使用 `SantoSpace.gap(24)`。

## 三、构造函数及参数说明

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| direction | SantoSpaceDirection | 排列方向 horizontal/vertical | 否 | horizontal |
| size | SantoSpaceSize | 间距档位 small/middle/large | 否 | middle |
| customSize | double? | 自定义间距值,优先于 size | 否 | null |
| wrap | bool | 是否自动换行(仅水平方向) | 否 | false |
| children | List&lt;Widget&gt; | 子组件列表 | 是 | 无 |
| mainAxisAlignment | MainAxisAlignment | 主轴对齐 | 否 | start |
| crossAxisAlignment | CrossAxisAlignment | 交叉轴对齐 | 否 | start |

`SantoSpace.gap(double gap, {direction})`:生成一个固定间距的空隙,等效 SizedBox。

## 四、示例代码

```dart
SantoSpace(
  direction: SantoSpaceDirection.horizontal,
  size: SantoSpaceSize.middle,
  children: [Text('A'), Text('B')],
)

SantoSpace(
  wrap: true,
  size: SantoSpaceSize.small,
  children: [/* 大量标签 */],
)

const SantoSpace.gap(24, direction: SantoSpaceDirection.vertical)
```
