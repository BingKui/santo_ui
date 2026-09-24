---
title: SantoAnchor
group:
  title: 锚点
  order: 1
---

# SantoAnchor

锚点:长内容按分区纵向排布,顶部标签与内容双向联动。

## 一、效果总览

- 顶部标签栏复用 `SantoTabBar`,点击标签滚动到对应分区
- 滚动内容时选中标签自动跟随当前分区切换
- 标签与内容之间可选一条分割线(`tabDivider`)
- 分区内容由 `widgetIndexedBuilder` 按索引构建,各分区高度任意、无需等高

## 二、描述

### 适用场景
1. 页面内容很长且天然分成若干区块(商品详情、账单明细、设置分组)。
2. 需要「标签 ↔ 内容」双向联动的快速定位。

### 使用规范
- 组件**自带滚动**且内部含 `Expanded`,因此**必须给它一个有界高度**:整页使用时用 `SantoPageLayout(scrollable: false)` 配合 `Expanded` 包裹(见下),不要直接放进 `ListView` / `SingleChildScrollView` 等高度不受限的容器。
- `itemCount` 必须与两个 builder 能返回的条目数一致;运行中增减条目会被同步处理(标签控制器按新数量重建)。
- 分区偏移量以滚动视口(标签栏下方)顶部为基准实测,分区高度变化(图片加载完成、展开收起)后会重新测量并刷新映射。
- 点击标签的滚动动画固定 100ms 线性;滚动内容时标签只做联动选中,不回写滚动位置。

## 三、构造函数及参数说明

### SantoAnchor

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| widgetIndexedBuilder | AnchorWidgetIndexedBuilder? | 构建指定索引的分区内容 | 是 | 无 |
| tabIndexedBuilder | AnchorIndexedTabBuilder | 构建指定索引的标签(返回 `BadgeTab`) | 是 | 无 |
| itemCount | int | 标签与分区的个数 | 是 | 无 |
| tabBarStyle | SantoAnchorBarStyle | 标签栏样式 | 否 | const SantoAnchorBarStyle() |
| tabDivider | Widget? | 标签与内容之间的分割线 | 否 | null(不占位) |

### SantoAnchorBarStyle

字段全部透传给内部 `SantoTabBar`,留空时由 `SantoTabBar` 按主题决定。

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| indicatorColor | Color? | 指示器颜色 | 否 | null |
| indicatorWeight | double | 指示器粗细 | 否 | 2.0 |
| labelColor | Color? | 选中标签颜色 | 否 | null |
| unselectedLabelColor | Color? | 未选中标签颜色 | 否 | null |
| labelStyle | TextStyle? | 选中标签文字样式 | 否 | null |
| unselectedLabelStyle | TextStyle? | 未选中标签文字样式 | 否 | null |
| labelPadding | EdgeInsetsGeometry? | 标签内边距 | 否 | null(按 `EdgeInsets.zero` 透传) |
| dragStartBehavior | DragStartBehavior | 拖拽手势起始行为 | 否 | DragStartBehavior.start |

### 类型别名

| 名称 | 签名 | 说明 |
| --- | --- | --- |
| AnchorWidgetIndexedBuilder | Widget Function(BuildContext context, int index) | 构建指定索引的分区内容 |
| AnchorIndexedTabBuilder | BadgeTab Function(BuildContext context, int index) | 构建指定索引的标签 |

## 四、示例代码

```dart
SantoAnchor(
  itemCount: 3,
  tabIndexedBuilder: (context, index) => BadgeTab(text: '分区 $index'),
  widgetIndexedBuilder: (context, index) =>
      SizedBox(height: 240, child: Center(child: Text('$index'))),
  tabDivider: const Divider(height: 1),
  tabBarStyle: const SantoAnchorBarStyle(indicatorWeight: 2),
)
```

整页用法:组件自带滚动,用 `Expanded` 给它一个有界高度。

```dart
SantoPageLayout(
  title: 'Anchor 锚点',
  scrollable: false,
  children: <Widget>[
    Expanded(
      child: SantoAnchor(
        itemCount: items.length,
        tabIndexedBuilder: (context, index) => BadgeTab(text: items[index].title),
        widgetIndexedBuilder: (context, index) => items[index].content,
      ),
    ),
  ],
)
```

## 版本变更

### v2.0.0
- **改名**: `SantoAnchorTab` → `SantoAnchor`,`SantoAnchorTabBarStyle` → `SantoAnchorBarStyle`,`AnchorTabWidgetIndexedBuilder` → `AnchorWidgetIndexedBuilder`,`AnchorTabIndexedBuilder` → `AnchorIndexedTabBuilder`;组件迁移到 `lib/src/components/anchor/santo_anchor.dart`
- **组件位置**: `lib/src/components/scroll_anchor/santo_scroll_anchor_tab.dart` → `lib/src/components/anchor/santo_anchor.dart`

### v1.2.0
- **删除**: `indicatorPadding` 参数(随 `SantoTabBar.indicatorWidth` / `SantoTabBar.indicatorPadding` 一起移除);指示器粗细与颜色由 `indicatorWeight` / `indicatorColor` 控制

### v1.0.0
- 初始版本发布
