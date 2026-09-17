---
title: SantoPanel
group:
  title: 通用
  order: 1
---

# SantoPanel

面板组件:圆角容器 + Header(标题/操作区) + Content(内容区)。

## 一、效果总览

内容自适应高度;设置 maxHeight 后内容可滚动并显示滚动条。

## 二、描述

### 适用场景
1. 卡片式信息分组展示,带标题与操作按钮。
2. 内容较多的面板需要限制高度滚动展示。

### 使用规范
- Panel 自身不带外边距,页面里的间距(左右留白、面板之间)由页面容器提供,例如 `SantoPageLayout` 的 padding(主题 `commonConfig.pageGap`)或 `SantoSpace`。
- Header 不传 title/titleWidget/titleExtra/actions 时不渲染。
- 标题后需要放其他控件(如 Segmented)时用 titleExtra,它会紧跟标题展示并优先保留完整宽度,标题空间不足时收缩让位。

## 三、构造函数及参数说明

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| title | String? | Header 左侧标题文案 | 否 | null |
| titleWidget | Widget? | 自定义标题控件,设置后 title 失效 | 否 | null |
| titleExtra | Widget? | 标题后方的控件(如 Segmented),位于标题与 actions 之间 | 否 | null |
| actions | List&lt;Widget&gt;? | Header 右侧操作区 | 否 | null |
| child | Widget | 内容区控件 | 是 | 无 |
| contentPadding | bool | 内容区是否显示内边距 | 否 | true |
| maxHeight | double? | 内容区最大高度,超出可滚动 | 否 | null(自适应) |
| backgroundColor | Color? | 面板背景色 | 否 | 白色 |
| radius | double? | 面板圆角 | 否 | 12 |
| themeData | SantoPanelConfig? | 面板主题配置 | 否 | null |

## 四、示例代码

```dart
SantoPanel(
  title: '面板标题',
  actions: [SantoNormalButton.outline(text: '更多', onTap: () {})],
  child: Text('面板内容'),
)

// 限制高度滚动
SantoPanel(
  title: '可滚动面板',
  maxHeight: 120,
  child: Column(children: List.generate(20, (i) => Text('条目${i + 1}'))),
)
```

## 五、主题定制

通过 `SantoPanelConfig` 可定制:contentPadding、backgroundColor、radius、headerHeight、titleTextStyle,注册方式见 [主题定制](../../theme)。
