---
title: SantoMasonry
group:
  title: 布局
  order: 2
---

# SantoMasonry

瀑布流组件:多列布局,子项按"最短列优先"规则依次排布。API 对齐 Ant Design 6 的 Masonry。

## 一、效果总览

支持自定义列数与水平/垂直间距,子项宽度按列均分,高度自适应内容。

## 二、描述

### 适用场景
1. 高度不一的卡片列表(图片墙、内容流)。
2. 需要多列自适应排布的场景。

### 使用规范
- 组件宽度取父容器约束宽度;外层需要滚动时用 `SingleChildScrollView` 包裹。
- 子项会按列均分宽度,不要在子项内指定宽度。

## 三、构造函数及参数说明

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| columns | int | 列数 | 否 | 3 |
| gutter | double | 水平间距 | 否 | 0 |
| verticalGutter | double? | 垂直间距,默认与 gutter 相同 | 否 | null |
| items | List&lt;Widget&gt; | 子项列表 | 是 | 无 |

> 对齐 antd Masonry 的 columns / gutter(number 或 [水平, 垂直]) / items;
> antd 的 fresh 属性用于 web 局部刷新优化,Flutter 版无需此参数。

## 四、示例代码

```dart
SantoMasonry(
  columns: 3,
  gutter: 16,
  items: [
    Container(height: 100, color: Colors.red),
    Container(height: 60, color: Colors.blue),
  ],
)
```
