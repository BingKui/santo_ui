---
title: SantoTextEllipsis
group:
  title: 数据展示
  order: 6
---

# SantoTextEllipsis

多行文本省略:内容超出指定行数后折叠,并在省略号之后紧跟展开操作,参考 Vant TextEllipsis。

## 一、效果总览

超出 rows 行的文本折叠为「省略号 + 展开文案」,展开操作与正文同一行;点击操作可展开
完整内容并切换为收起文案;内容未超出时原样展示,不出现省略号与操作文案。

## 二、描述

### 适用场景
1. 列表或卡片中的长文本摘要,需要控制占用的行数。
2. 需要按需展开查看完整说明的场景。

### 使用规范
- 省略位置由 `position` 控制:start 省略开头、middle 省略中间、end 省略结尾(默认)。
- 折叠时通过 TextPainter 二分测量可用文本,保证省略号与展开操作都能放进 rows 行内。
- `expandText`、`collapseText` 默认空字符串,不传时只展示省略号。
- 需要通过外部按钮切换展开态时,用 GlobalKey 取到 `SantoTextEllipsisState` 后调用 `toggle`。
- 使用 `actionBuilder` 自定义操作内容时,返回的 span 需自行挂载 recognizer 处理点击。

## 三、构造函数及参数说明

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| content | String | 需要展示的文本内容 | 否 | '' |
| rows | int | 展示的行数,超出后折叠 | 否 | 1 |
| dots | String | 折叠时显示的省略文案 | 否 | '...' |
| expandText | String | 展开操作的文案 | 否 | '' |
| collapseText | String | 收起操作的文案 | 否 | '' |
| position | SantoTextEllipsisPosition | 省略位置 start/middle/end | 否 | end |
| textStyle | TextStyle? | 文本样式 | 否 | 字号 14、基础文字色、行高 1.6 |
| actionStyle | TextStyle? | 展开/收起操作的样式 | 否 | 品牌主题色 |
| actionBuilder | InlineSpan Function(BuildContext, bool)? | 自定义展开/收起操作 | 否 | null |
| onClickAction | ValueChanged&lt;bool&gt;? | 点击操作的回调,参数为点击后的展开状态 | 否 | null |

`SantoTextEllipsisState`:通过 GlobalKey 获取后,可调用 `toggle([bool? isExpanded])`
切换展开态(不传参数时取反),`expanded` 返回当前展开状态。

## 四、示例代码

```dart
SantoTextEllipsis(
  content: '慢慢来，比较快。这是一段用于演示文本省略的长文本。',
  rows: 2,
  expandText: '展开',
  collapseText: '收起',
)

SantoTextEllipsis(
  content: '慢慢来，比较快。这是一段用于演示文本省略的长文本。',
  rows: 2,
  position: SantoTextEllipsisPosition.middle,
  dots: '……',
  expandText: '展开',
  collapseText: '收起',
  onClickAction: (expanded) => debugPrint('$expanded'),
)

final GlobalKey<SantoTextEllipsisState> ellipsisKey = GlobalKey();
SantoTextEllipsis(
  key: ellipsisKey,
  content: '慢慢来，比较快。',
  expandText: '展开',
  collapseText: '收起',
);
ellipsisKey.currentState?.toggle();
```
