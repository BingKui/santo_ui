---
title: SantoGrid
group:
  title: 布局
  order: 2
---

# SantoGrid

24 等分栅格布局组件,参考 Ant Design 的 Grid(Row / Col)。

## 一、效果总览

`SantoRow` 行内放置 `SantoCol` 列,span 总和超出 24 时整列换行;支持列间距、左右偏移、排序、视觉位移、伸缩与对齐。

## 二、描述

### 适用场景
1. 信息区域内按比例分栏(三等分 `span: 8`、四等分 `span: 6`、两等分 `span: 12`)。
2. 需要换行、偏移、排序的栅格化排版。

### 使用规范
- 只能把 `SantoCol` 直接放进 `SantoRow`,内容放在 `SantoCol` 内。
- antd 的响应式断点参数(xs/sm/md/lg/xl/xxl,基于 CSS 媒体查询)为 Web 专属,未移植;如需分栏宽度自适应请用 `flex`。

## 三、构造函数及参数说明

### SantoRow

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| children | List&lt;SantoCol&gt; | 行内的列 | 是 | 无 |
| gutter | double | 列间距(横向),相邻列间距 = gutter,首尾列内容与行边缘齐平 | 否 | 0 |
| verticalGutter | double | 换行后的行间距(纵向) | 否 | 0 |
| wrap | bool | span 总和超出 24 时是否自动换行 | 否 | true |
| justify | MainAxisAlignment | 水平排布方式(参考 antd justify) | 否 | start |
| align | CrossAxisAlignment | 垂直对齐方式(参考 antd align: top/middle/bottom/stretch) | 否 | start |

### SantoCol

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| child | Widget | 列内容 | 是 | 无 |
| span | int? | 占据的栅格数 0~24;为 null 时宽度由内容自适应;为 0 时不渲染 | 否 | null |
| offset | int? | 左侧偏移的栅格数,参与换行计算 | 否 | null |
| order | int? | 排序权重,小的在前;相同 order 保持声明顺序 | 否 | null |
| push | int? | 右移的栅格数(仅视觉位移,不影响兄弟元素布局) | 否 | null |
| pull | int? | 左移的栅格数(仅视觉位移,不影响兄弟元素布局) | 否 | null |
| flex | int? | 伸缩值,非 null 时以 `Expanded(flex: flex)` 参与布局并忽略 span | 否 | null |

## 四、示例代码

```dart
SantoRow(
  gutter: 15,
  children: [
    SantoCol(span: 12, child: A()),
    SantoCol(span: 12, child: B()),
  ],
)

// 偏移居中
SantoRow(children: [
  SantoCol(span: 12, offset: 6, child: C()),
])

// 伸缩列与固定列混排
SantoRow(children: [
  SantoCol(flex: 1, child: D()),
  SantoCol(span: 8, child: E()),
])
```

## 版本变更

### v2.0.0
- 初始版本发布
