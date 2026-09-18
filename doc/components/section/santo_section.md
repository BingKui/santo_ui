---
title: SantoSection
group:
  title: 区块
  order: 1
---

# SantoSection

上方为演示内容,下方为标题 + 描述信息,整体圆角卡片。参考 antd 官网示例卡片排版。

## 一、效果总览

- 上方展示区可放置演示内容
- 下方展示标题和描述信息
- 整体圆角卡片样式
- 支持自定义标题和描述的 Widget
- 标题右侧可附加额外控件

## 二、描述

### 适用场景
1. 组件示例页面的分块展示
2. 功能特性的说明卡片
3. API 文档的演示区域
4. 任何需要"演示+说明"布局的场景

### 使用规范
- child 放置在上方展示区,通常为组件的实际使用代码
- title 和 description 提供文字说明
- titleWidget/descriptionWidget 优先级高于 title/description,用于完全自定义
- titleSuffix 可在标题右侧添加标签、开关等控件
- contentPadding 控制展示区内边距,footerPadding 控制标题区内边距

## 三、构造函数及参数说明

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| child | Widget? | 上方演示内容 | 否 | null |
| title | String? | 标题文案 | 否 | null |
| titleWidget | Widget? | 自定义标题控件 | 否 | null |
| titleSuffix | Widget? | 标题右侧附加控件 | 否 | null |
| description | String? | 描述文案 | 否 | null |
| descriptionWidget | Widget? | 自定义描述控件 | 否 | null |
| contentPadding | EdgeInsets? | 展示区内边距 | 否 | null(主题配置) |
| footerPadding | EdgeInsets? | 标题/描述区内边距 | 否 | null(主题配置) |
| backgroundColor | Color? | 背景色 | 否 | null(主题配置) |
| themeData | SantoSectionConfig? | 区块主题配置 | 否 | null |

## 四、示例代码

### 基础用法

```dart
SantoSection(
  title: '基础按钮',
  description: '展示不同类型的按钮组件',
  child: Row(
    children: [
      ElevatedButton(onPressed: () {}, child: const Text('主要按钮')),
      OutlinedButton(onPressed: () {}, child: const Text('次要按钮')),
    ],
  ),
)
```

### 带标题后缀

```dart
SantoSection(
  title: '实验性功能',
  titleSuffix: Chip(label: const Text('Beta'), padding: EdgeInsets.zero),
  description: '此功能仍在实验中,可能随时变更',
  child: ExperimentalWidget(),
)
```

### 自定义标题和描述

```dart
SantoSection(
  titleWidget: Row(
    children: [
      Icon(Icons.star, color: Colors.amber),
      const SizedBox(width: 8),
      const Text('推荐用法'),
    ],
  ),
  descriptionWidget: MarkdownBody(data: '**注意**: 此方式性能更好'),
  child: DemoContent(),
)
```

### 自定义内边距

```dart
SantoSection(
  title: '紧凑卡片',
  contentPadding: const EdgeInsets.all(12),
  footerPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  child: CompactDemo(),
)
```
