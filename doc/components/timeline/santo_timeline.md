---
title: SantoTimeline
group:
  title: 时间轴
  order: 1
---

# SantoTimeline

时间轴按时间顺序展示一系列节点,对标 antd Timeline。

## 一、效果总览

- 纵向三种排布:轴线在左(`start`)、轴线在右(`end`)、内容左右交替(`alternate`)
- 横向三种排布:内容在轴线下方(`start`)、上方(`end`)、上下交替(`alternate`)
- 节点可带标题(`title`),标题与内容分列轴线两侧,标题列宽度可用 `titleSpan` 固定
- 节点色取主题语义色(`color`:blue / red / green / gray),也可传任意色值(`dotColor`)
- 节点样式可选空心描边(`outlined`,默认)与实心填充(`filled`)
- 节点可用任意组件替换(`icon`),或以加载中状态展示(`loading`)
- 支持整体倒序(`reverse`)、单节点侧位覆盖(`placement`)

## 二、描述

### 适用场景

1. 把一组信息按时间先后排成一条视觉连线(操作记录、物流轨迹、审批流转)
2. 需要突出「当前进行到哪一步」,并让进行中的节点持续转圈
3. 需要标题与内容分列轴线两侧,形成时间对照

### 使用规范

- 与 antd 的差异:
  - `titleSpan` 只接受逻辑像素值;antd 还支持百分比与 24 栅格数。不传时标题列与内容列各占一半(轴线居中),与 antd 默认的 `head-span: 12` 一致
  - antd 的 `pending` / `pendingDot` 与 `Timeline.Item` 子组件写法均已废弃,这里只保留 `SantoTimelineItem` 列表写法,幽灵节点用 `item.loading`、自定义节点用 `item.icon`
  - 横向时间轴的节点等分整行宽度,内容建议单行展示;`alternate` 下上下两侧均分可用高度
- 侧位规则:不传 `placement` 时由 `mode` 决定;`alternate` 按传入顺序奇偶交替,`reverse` 只改渲染顺序、不改每个节点的侧位
- 只有存在 `title` 时(或 `mode` 为 `alternate`)轴线才居中、节点分列两侧;否则轴线贴在内容一侧
- 标题取次要文字色、内容取正文色,节点圆心的纵向位置与首行文字中线对齐
- 加载中的节点(`loading`)会让「指向它」的那段轴线变成虚线,与 antd 一致
- 时间轴不处理滚动,放进可滚动页面即可;节点内容过长时自行换行,由内容组件决定
- 纵向时间轴需要按每行内容的高度贯通轴线(内部用 `IntrinsicHeight`),节点内容请放支持固有尺寸的组件(文本、图片、卡片、`Row` 等);`ListView` / `GridView` 这类无固有高度的滚动组件不适合直接作为节点内容

## 三、构造函数及参数说明

### SantoTimeline

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| items | List<SantoTimelineItem> | 节点列表,按传入顺序排布 | 是 | - |
| mode | SantoTimelineMode | 排布模式 start / alternate / end | 否 | start |
| orientation | SantoTimelineOrientation | 排布方向 vertical / horizontal | 否 | vertical |
| variant | SantoTimelineVariant | 节点样式 outlined(空心)/ filled(实心) | 否 | outlined |
| reverse | bool | 是否倒序渲染节点 | 否 | false |
| titleSpan | double? | 标题列宽度(逻辑像素),仅纵向且存在标题时生效;为 null 时标题与内容各占一半 | 否 | null |

### SantoTimelineItem

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| title | String? | 标题/时间文案 | 否 | null |
| titleWidget | Widget? | 自定义标题,优先级高于 title | 否 | null |
| content | Widget? | 节点内容 | 否 | null |
| color | SantoTimelineColor? | 节点色预设 blue / red / green / gray | 否 | blue |
| dotColor | Color? | 自定义节点色,优先级高于 color | 否 | null |
| icon | Widget? | 自定义节点,优先级高于 color / dotColor | 否 | null |
| loading | bool | 进行中的幽灵节点:展示加载指示器,指向它的轴线转虚线 | 否 | false |
| placement | SantoTimelinePlacement? | 覆盖该节点的侧位 start / end | 否 | null |

### 枚举

| 枚举 | 取值 | 说明 |
| --- | --- | --- |
| SantoTimelineMode | start / alternate / end | 纵向:内容在轴线右侧 / 左右交替 / 内容在轴线左侧;横向:内容在轴线下方 / 上下交替 / 内容在轴线上方 |
| SantoTimelineOrientation | vertical / horizontal | 纵向自上而下 / 横向自左向右 |
| SantoTimelineVariant | outlined / filled | 空心描边 / 实心填充 |
| SantoTimelinePlacement | start / end | 起始侧 / 结束侧 |
| SantoTimelineColor | blue / red / green / gray | 品牌色 / 失败色 / 成功色 / 失效文字色,均取主题令牌 |

## 四、示例代码

### 基础用法

```dart
SantoTimeline(
  items: const <SantoTimelineItem>[
    SantoTimelineItem(content: Text('创建服务站点 2015-09-01')),
    SantoTimelineItem(content: Text('解决初始网络问题 2015-09-01')),
    SantoTimelineItem(content: Text('技术测试 2015-09-01')),
    SantoTimelineItem(content: Text('网络问题已解决 2015-09-01')),
  ],
)
```

### 时间标题与标题列宽度

```dart
SantoTimeline(
  titleSpan: 100,
  items: const <SantoTimelineItem>[
    SantoTimelineItem(title: '2015-09-01', content: Text('创建服务')),
    SantoTimelineItem(title: '2015-09-01 09:12:11', content: Text('解决初始网络问题')),
    SantoTimelineItem(content: Text('技术测试')),
  ],
)
```

### 节点颜色与实心样式

```dart
SantoTimeline(
  variant: SantoTimelineVariant.filled,
  items: <SantoTimelineItem>[
    SantoTimelineItem(content: const Text('创建服务站点'), color: SantoTimelineColor.blue),
    SantoTimelineItem(content: const Text('网络异常'), color: SantoTimelineColor.red),
    SantoTimelineItem(content: const Text('自定义色值'), dotColor: const Color(0xFF722ED1)),
  ],
)
```

### 自定义节点

```dart
SantoTimeline(
  items: const <SantoTimelineItem>[
    SantoTimelineItem(content: Text('创建服务站点')),
    SantoTimelineItem(
      icon: SantoIcon(SantoIcons.clock, color: Color(0xFF1677FF)),
      content: Text('排期评审'),
    ),
    SantoTimelineItem(
      icon: SantoIcon(SantoIcons.checkCircle, color: Color(0xFF52C41A)),
      content: Text('技术测试'),
    ),
  ],
)
```

### 加载中与倒序

```dart
SantoTimeline(
  reverse: true,
  items: const <SantoTimelineItem>[
    SantoTimelineItem(content: Text('创建服务站点 2015-09-01')),
    SantoTimelineItem(content: Text('解决初始网络问题 2015-09-01')),
    SantoTimelineItem(loading: true, content: Text('录制中...')),
  ],
)
```

### 左右交替与右侧标题

```dart
SantoTimeline(mode: SantoTimelineMode.alternate, items: items)
SantoTimeline(mode: SantoTimelineMode.end, items: titledItems)
```

### 横向时间轴

```dart
SantoTimeline(
  orientation: SantoTimelineOrientation.horizontal,
  items: items,
)
SantoTimeline(
  orientation: SantoTimelineOrientation.horizontal,
  mode: SantoTimelineMode.end,
  items: items,
)
SantoTimeline(
  orientation: SantoTimelineOrientation.horizontal,
  mode: SantoTimelineMode.alternate,
  items: items,
)
```

### 单节点侧位覆盖

```dart
SantoTimeline(
  mode: SantoTimelineMode.alternate,
  items: const <SantoTimelineItem>[
    SantoTimelineItem(content: Text('默认排在起始侧')),
    SantoTimelineItem(
      content: Text('强制排在结束侧'),
      placement: SantoTimelinePlacement.end,
    ),
  ],
)
```

## 五、版本变更

### v2.3.0

- **新增**: `SantoTimeline` 时间轴组件,对标 antd Timeline
- **新增**: `SantoTimelineItem` 节点,支持 `title` / `titleWidget` / `content` / `color` / `dotColor` / `icon` / `loading` / `placement`
- **新增**: `SantoTimelineMode`(start / alternate / end)、`SantoTimelineOrientation`(vertical / horizontal)、`SantoTimelineVariant`(outlined / filled)、`SantoTimelinePlacement`(start / end)、`SantoTimelineColor`(blue / red / green / gray)枚举
- **新增**: `reverse` 倒序、`titleSpan` 标题列宽度
- 与 antd 的差异:`titleSpan` 只支持逻辑像素;不提供 `pending` / `pendingDot` 与 `Timeline.Item` 子组件写法(改用 `item.loading` 与 `item.icon`)
