---
title: SantoFloatingPanel
group:
  title: 悬浮窗
  order: 1
---

# SantoFloatingPanel

贴底停靠的可拖拽面板,对标 Vant FloatingPanel。拖动把手/标头或内容区域改变高度,松手后吸附到最近的锚点。

## 一、效果总览

- 贴底停靠的浮层面板
- 可拖拽改变高度
- 自动吸附到预设锚点
- 支持自定义标头和背景色
- 作为 Stack 的子节点使用

## 二、描述

### 适用场景
1. 底部弹出的筛选面板
2. 可展开的详情信息面板
3. 地图应用的地点列表面板
4. 任何需要从底部滑出的可交互面板

### 使用规范
- 必须在 Stack 中使用,以便自由定位
- anchors 定义吸附锚点(像素值),默认 [100, 可用高度*0.6]
- draggable 为 false 时不可拖拽,但仍可通过 height 受控
- contentDraggable 控制是否可通过拖拽内容区改变高度
- magnetic 为 false 时不吸附,面板会停在释放位置
- 首个锚点(最小高度)须不小于标头整体高度(把手条 + header/title/desc + headerBottom),否则内容区被压成 0 会报 RenderFlex overflow

## 三、构造函数及参数说明

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| child | Widget | 面板内容 | 是 | - |
| header | Widget? | 面板标头,传入时优先于 title/desc | 否 | null |
| title | String? | 标头标题,未传 header 且 title/desc 非空时渲染默认标头 | 否 | null |
| desc | String? | 标题下方的描述文案,仅在默认标头下生效 | 否 | null |
| headerBottom | Widget? | 标头底部插槽,展示在标头之下、内容区之上,用法同 PageLayout 的 header | 否 | null |
| height | double? | 受控高度(px) | 否 | null(内部维护) |
| anchors | List\<double\>? | 锚点高度列表 | 否 | null([100, 可用高度*0.6]) |
| duration | Duration | 高度变化动画时长 | 否 | 300ms |
| magnetic | bool | 是否吸附到最近锚点 | 否 | true |
| draggable | bool | 是否允许拖拽 | 否 | true |
| contentDraggable | bool | 是否允许拖拽内容区域改变高度 | 否 | true |
| onHeightChange | ValueChanged\<double\>? | 拖动结束后的高度回调 | 否 | null |
| backgroundColor | Color? | 面板背景色 | 否 | null(fillBase) |
| radius | double? | 面板顶部圆角 | 否 | null(radiusLg=12) |

## 四、示例代码

### 基础用法

```dart
Stack(
  children: [
    MapWidget(),
    SantoFloatingPanel(
      header: const Center(child: Text('地点列表')),
      child: ListView.builder(
        itemCount: places.length,
        itemBuilder: (context, index) => ListTile(title: Text(places[index])),
      ),
    ),
  ],
)
```

### 自定义锚点

```dart
SantoFloatingPanel(
  anchors: const [80, 300, 600], // 三个吸附位置
  child: YourContent(),
)
```

### 受控高度

```dart
SantoFloatingPanel(
  height: panelHeight,
  onHeightChange: (height) {
    setState(() => panelHeight = height);
  },
  child: YourContent(),
)
```

### 禁用拖拽

```dart
SantoFloatingPanel(
  draggable: false,
  contentDraggable: false,
  height: 400,
  child: FixedContent(),
)
```

### 不吸附

```dart
SantoFloatingPanel(
  magnetic: false,
  child: FreeDragContent(),
)
```

### 标题与描述

```dart
SantoFloatingPanel(
  title: '筛选条件',
  desc: '按更新时间排序',
  child: FilterList(),
)
```

传入 `header` 时以 header 为准,title/desc 不生效。

### 标头底部插槽

```dart
SantoFloatingPanel(
  title: '筛选条件',
  desc: '按标签筛选下方内容',
  headerBottom: Wrap( // 筛选标签、TabBar 等任意组件
    children: [/* ... */],
  ),
  child: FilterList(),
)
```

`headerBottom` 不做内边距、撑满宽度,与把手条/标头同属拖拽区域。

## 版本变更

### v2.2.3
- **新增**: `title` / `desc` 参数,未传 `header` 且 title/desc 非空时渲染默认标头(标题 + 描述),样式与 SantoBottomDrawer 一致
- **新增**: `headerBottom` 插槽,展示在标头之下、内容区之上,可放 TabBar、筛选标签等任意组件(用法同 PageLayout 的 header)
