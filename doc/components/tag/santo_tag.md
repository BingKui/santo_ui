---
title: SantoTag
group:
  title: 标签
  order: 1
---

# SantoTag

标签组件用于标记和分类,是库内唯一的标签入口,不同形态全部通过参数实现,参考 antd Tag。

## 一、效果总览

- 普通标签:主题色底 + 反白文字
- 描边标签:`bordered` 为 true,透明底、文字与边框同色
- 状态标签:`state` 传五态之一,底色为状态色 10% 透明度、文字为状态色
- 多彩标签:`backgroundColor` / `textColor` / `borderColor` 自定义配色

自适应内容宽度,`maxWidth` 限制最大宽度并省略。

## 二、描述

### 适用场景
1. 分类标记(如商品标签、内容分类)
2. 状态标识(如进行中、已完成、失败)
3. 筛选条件展示
4. 关键词标签

### 使用规范
- 不要在外部包 alignment,让标签自适应内容宽度
- 状态选择应符合语义:running 进行中、succeed 成功、failed 失败、waiting 等待、invalidate 失效
- 标签文字不宜过长,建议简短明了
- 多个标签之间应保持适当间距(可用 SantoSpace 或 Wrap 的 spacing)

### 与旧组件的关系
v1.1.0 起 `SantoTagCustom`(含 `buildBorderTag` 命名构造)与 `SantoStateTag`(含 `TagState` 枚举)删除,统一由 `SantoTag` 参数承接。

## 三、构造函数及参数说明

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| text | String | 标签文本 | 是 | 无 |
| state | SantoTagState? | 标签状态 waiting/invalidate/running/failed/succeed,按状态取预设配色 | 否 | null |
| backgroundColor | Color? | 背景色,优先级高于 state 预设配色 | 否 | null |
| textColor | Color? | 文字颜色,优先级高于 state 预设配色与默认反白文字 | 否 | null |
| bordered | bool | 是否为描边标签 | 否 | false |
| borderColor | Color? | 边框颜色,默认取状态色或主题品牌色 | 否 | null |
| borderWidth | double | 边框宽度 | 否 | 1 |
| borderRadius | BorderRadius | 标签圆角 | 否 | 12 |
| padding | EdgeInsetsGeometry | 内边距 | 否 | 横 4 纵 2 |
| fontSize | double | 文字大小 | 否 | 11 |
| fontWeight | FontWeight | 文字粗细 | 否 | normal |
| maxWidth | double? | 最大宽度,超出省略 | 否 | null |

## 四、示例代码

```dart
// 普通标签
SantoTag(text: '标签')

// 描边标签
SantoTag(text: '已盘点', bordered: true)

// 状态标签
Wrap(
  spacing: 8,
  children: [
    SantoTag(text: '待进行', state: SantoTagState.waiting),
    SantoTag(text: '失效态', state: SantoTagState.invalidate),
    SantoTag(text: '进行中', state: SantoTagState.running),
    SantoTag(text: '失败态', state: SantoTagState.failed),
    SantoTag(text: '成功态', state: SantoTagState.succeed),
  ],
)

// 多彩标签与自定义配色
SantoTag(text: '红色标签', backgroundColor: Color(0xFFFF4D4F))
SantoTag(text: '描边彩色', bordered: true, textColor: Colors.red)

// 限制最大宽度
SantoTag(text: '限制最大宽度', maxWidth: 90)
```

## 版本变更

### v1.1.0
- **变更(破坏性)**: `SantoTagCustom`、`SantoStateTag` 收敛为唯一入口 `SantoTag`,不同形态(普通/描边/状态/多彩)全部通过参数实现
- **删除**: `SantoTagCustom`(含 `buildBorderTag` 命名构造)、`SantoStateTag`
- **变更**: `TagState` 枚举更名为 `SantoTagState`,成员不变(waiting/invalidate/running/failed/succeed)
