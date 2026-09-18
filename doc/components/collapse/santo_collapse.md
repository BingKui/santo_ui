---
title: SantoCollapse / SantoCollapsePanel
group:
  title: 折叠面板
  order: 1
---

# SantoCollapse / SantoCollapsePanel

折叠面板列表组件,支持多个面板同时展开或手风琴模式,支持通栏/卡片两种视觉形态。

## 一、效果总览

- 支持多面板同时展开(multiple)或手风琴模式(accordion)
- 支持通栏(block)和卡片(card)两种视觉形态
- 支持内容在标题上方/下方展开
- 可自定义标题左右区域和展开图标
- 支持禁用单个面板

## 二、描述

### 适用场景
1. FAQ 常见问题
2. 设置页面的分组展示
3. 长篇内容的分段展开
4. 表单字段的条件显示

### 使用规范
- multiple 模式下可同时展开多个面板,accordion 模式下只能展开一个
- card 形态自带圆角和阴影,适合独立展示
- 通过 `headerBuilder` 完全自定义标题区域
- `bodyHeight` 固定时可避免内容高度变化导致的布局抖动
- disabled 的面板不可交互但仍可见

## 三、构造函数及参数说明

### SantoCollapse

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| children | List\<SantoCollapsePanel\<T\>\> | 面板列表 | 是 | - |
| value | List\<T\> | 当前展开面板的值列表 | 是 | - |
| mode | SantoCollapseMode | 展开模式(multiple/accordion) | 否 | multiple |
| variant | SantoCollapseVariant? | 视觉形态(block/card) | 否 | null(block) |
| animationDuration | Duration? | 动画时长 | 否 | null(kThemeAnimationDuration) |
| elevation | double? | 阴影 | 否 | null(0) |
| onChanged | ValueChanged\<List\<T\>\>? | 展开值变更回调 | 否 | null |

### SantoCollapsePanel

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| value | T | 面板唯一标识 | 是 | - |
| headerBuilder | SantoCollapsePanelBuilder | 构建标题的回调 (context, isExpanded) => Widget | 是 | - |
| body | Widget | 折叠面板的内容组件 | 是 | - |
| bodyHeight | double? | 内容区域的固定高度 | 否 | null |
| disabled | bool | 是否禁用面板交互 | 否 | false |
| placement | SantoCollapsePlacement | 内容展开方向(bottom/top) | 否 | bottom |
| semanticsLabel | String? | 无障碍标签 | 否 | null |
| backgroundColor | Color? | 背景色 | 否 | null |
| leadingBuilder | SantoCollapsePanelBuilder? | 构建标题左侧区域 | 否 | null |
| trailingBuilder | SantoCollapsePanelBuilder? | 构建标题右侧、展开图标之前 | 否 | null |
| expandIconBuilder | SantoCollapsePanelBuilder? | 构建展开图标 | 否 | 默认箭头 |

## 四、示例代码

### 基础用法(多面板)

```dart
SantoCollapse<String>(
  value: ['panel1'],
  children: [
    SantoCollapsePanel(
      value: 'panel1',
      headerBuilder: (context, isExpanded) => const Text('面板1'),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text('这是面板1的内容'),
      ),
    ),
    SantoCollapsePanel(
      value: 'panel2',
      headerBuilder: (context, isExpanded) => const Text('面板2'),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text('这是面板2的内容'),
      ),
    ),
  ],
  onChanged: (values) {},
)
```

### 手风琴模式

```dart
SantoCollapse<String>(
  mode: SantoCollapseMode.accordion,
  value: [],
  children: [
    // ... panels
  ],
)
```

### 卡片形态

```dart
SantoCollapse<String>(
  variant: SantoCollapseVariant.card,
  elevation: 2,
  value: [],
  children: [
    // ... panels
  ],
)
```

### 自定义标题和图标

```dart
SantoCollapsePanel(
  value: 'custom',
  headerBuilder: (context, isExpanded) => Row(
    children: [
      Icon(isExpanded ? Icons.expand_more : Icons.chevron_right),
      const SizedBox(width: 8),
      Text(isExpanded ? '展开状态' : '收起状态'),
    ],
  ),
  leadingBuilder: (context, isExpanded) => const Icon(Icons.info),
  body: const Text('自定义内容'),
)
```
