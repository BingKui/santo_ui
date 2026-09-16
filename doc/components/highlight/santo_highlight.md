---
title: SantoHighlight
group:
  title: 数据展示
  order: 6
---

# SantoHighlight

关键词高亮文本:在源文本中检索关键词并高亮命中的片段,参考 Vant Highlight。

## 一、效果总览

命中关键词的片段使用品牌主题色展示,其余片段保持基础文字色;支持多个关键词、
大小写敏感、自定义高亮样式与自定义片段内容。

## 二、描述

### 适用场景
1. 搜索结果中标记用户输入的关键词。
2. 文本中突出显示需要关注的字段名、地名、机构名等。

### 使用规范
- 关键词为空字符串时忽略,不产生空的高亮片段。
- 多个关键词的命中区间按位置合并,重叠部分合并为一个高亮片段。
- 整段文本使用同一个 Text 渲染,关键词之间不会因为拼接而断开。

### 与 Vant 的对应关系
Vant 面向 HTML 的 `tag`、`highlight-tag`、`unhighlight-tag`、`highlight-class`、
`unhighlight-class`、`auto-escape` 在 Flutter 中没有对应物,分别由 `textStyle`、
`highlightStyle`、`unhighlightStyle` 与 `highlightBuilder` 承担。

## 三、构造函数及参数说明

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| sourceString | String | 源文本,即被检索的整段文本 | 否 | '' |
| keywords | List&lt;String&gt; | 需要高亮的关键词 | 是 | 无 |
| caseSensitive | bool | 是否区分大小写 | 否 | false |
| textStyle | TextStyle? | 文本基础样式 | 否 | 字号 14、基础文字色 |
| highlightStyle | TextStyle? | 高亮片段样式,优先级低于 highlightBuilder | 否 | 品牌主题色 |
| unhighlightStyle | TextStyle? | 非高亮片段样式 | 否 | 继承 textStyle |
| highlightBuilder | InlineSpan Function(BuildContext, String)? | 自定义高亮片段 | 否 | null |
| unhighlightBuilder | InlineSpan Function(BuildContext, String)? | 自定义非高亮片段 | 否 | null |

## 四、示例代码

```dart
SantoHighlight(
  sourceString: '慢慢来，比较快',
  keywords: ['慢慢来'],
)

SantoHighlight(
  sourceString: '1 慢慢来 2 比较快 3',
  keywords: ['慢慢来', '比较快'],
)

SantoHighlight(
  sourceString: 'Flutter 是跨端框架，flutter 生态完善',
  keywords: ['Flutter'],
  caseSensitive: true,
  highlightStyle: TextStyle(color: Color(0xFFFF5722), fontWeight: FontWeight.w500),
)

SantoHighlight(
  sourceString: '慢慢来，比较快',
  keywords: ['比较快'],
  highlightBuilder: (context, text) => TextSpan(
    text: ' $text ',
    style: TextStyle(color: Colors.white, backgroundColor: Color(0xFF1677FF)),
  ),
)
```
