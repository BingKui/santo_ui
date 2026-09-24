---
title: SantoFlex
group:
  title: 布局
  order: 2
---

# SantoFlex

弹性布局组件,参考 Ant Design 的 Flex。

## 一、效果总览

水平/垂直排列、换行、主轴/交叉轴对齐、子元素统一伸缩、三档预设或自定义间距(取主题间距 token)。

## 二、描述

### 适用场景
1. 块级内容的水平/垂直布局,需要统一间距与对齐控制。
2. 等分剩余空间(flex)。

### 与 SantoSpace 的区别
- `SantoSpace` 用于行内元素的等间距排列,会为每个子元素包一层包装节点。
- `SantoFlex` 用于块级元素布局,不增加额外包装节点,并提供对齐与伸缩能力。

### 使用规范
- 间距档位复用 `SantoSpaceSize`,三档取主题间距 token(默认 10/15/20)。
- antd 的 `vertical` 布尔参数已由 `orientation` 取代,不再单独保留;`component`(自定义元素类型)为 Web 专属,不适用。

## 三、构造函数及参数说明

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| orientation | SantoFlexOrientation | 排列方向 horizontal/vertical | 否 | horizontal |
| wrap | bool | 是否换行 | 否 | false |
| justify | MainAxisAlignment | 主轴对齐方式(参考 antd justify) | 否 | start |
| align | CrossAxisAlignment? | 交叉轴对齐方式(参考 antd align);为 null 时水平方向 start、垂直方向 stretch | 否 | null |
| flex | int? | 子元素统一伸缩值,非 null 时每个子元素包一层 `Expanded(flex: flex)` | 否 | null |
| gapSize | SantoSpaceSize? | 间距档位 small/middle/large,取主题间距 token | 否 | null |
| gap | double? | 自定义间距值,优先于 gapSize | 否 | null |
| children | List&lt;Widget&gt; | 子组件列表 | 是 | 无 |

## 四、示例代码

```dart
SantoFlex(
  gapSize: SantoSpaceSize.middle,
  children: [Text('A'), Text('B')],
)

// 垂直排列,交叉轴拉伸
SantoFlex(
  orientation: SantoFlexOrientation.vertical,
  align: CrossAxisAlignment.stretch,
  children: [...],
)

// 换行 + 间距
SantoFlex(wrap: true, gapSize: SantoSpaceSize.middle, children: [...])

// 等分
SantoFlex(flex: 1, gapSize: SantoSpaceSize.small, children: [...])
```

## 版本变更

### v2.0.0
- 初始版本发布
