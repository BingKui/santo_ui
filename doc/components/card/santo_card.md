---
title: SantoCard
group:
  title: 卡片
  order: 1
---

# SantoCard

卡片把一组相关信息组织成一块,带标题、右上角操作与元信息插槽,对标 antd Card。

## 一、效果总览

- 内容分三段自上而下:头部(`title` / `titleWidget` + `extra`)、元信息(`meta`,头像 + 标题 + 描述)、内容(`child`)
- 只传 `child` 时是一块纯阴影容器:白底、12 圆角、0.5 边框与柔和阴影
- 头部下方自动补一条分割线;有头部或元信息且未显式传 `padding` 时,内容区自动取主题内边距
- 背景色默认取主题 `fillBase`(白),也可换成任意语义底色
- 圆角、阴影颜色/模糊/扩散/偏移、边框宽度均可自定义

## 二、描述

### 适用场景

1. 页面内容需要分块呈现,用卡片把一组相关信息圈成一块
2. 列表项、详情块需要统一的边框与阴影容器
3. 需要头部标题 + 右上角操作的区块
4. 需要头像 + 标题 + 描述的元信息卡(对标 antd Card.Meta)

### 使用规范

- 本组件由旧的 `SantoShadowCard` 改名而来,只传 `child` 时渲染结果与旧组件完全一致;`title` / `titleWidget` / `extra` / `meta` 是本次新增的插槽
- 默认背景取主题 `fillBase`(白),普通卡片不要写死颜色;需要语义底色(如浅蓝)时用 `color` 传入
- `padding` 默认为 `EdgeInsets.zero`;有标题或元信息时内部会自动补主题 `hSpacingMd` / `vSpacingMd`,显式传过 `padding` 的调用方不受影响
- 头部与内容、元信息与内容之间的间距统一取主题 `vSpacingMd`,卡片外不要再叠一层间距
- 卡片阴影默认柔和(`blurRadius` 为 5);需要硬阴影时把 `blurRadius` 设为 0,再配合 `offset` / `spreadRadius`

## 三、构造函数及参数说明

### SantoCard

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| child | Widget | 卡片内容 | 是 | - |
| title | String? | 标题文案 | 否 | null |
| titleWidget | Widget? | 自定义标题,优先级高于 title | 否 | null |
| extra | Widget? | 头部右上角操作区(对应 antd Card 的 extra) | 否 | null |
| meta | SantoCardMeta? | 元信息区(对应 antd Card.Meta) | 否 | null |
| color | Color? | 背景色 | 否 | null(主题 fillBase,白) |
| shadowColor | Color | 阴影颜色 | 否 | Color(0xFFE8EAEC) |
| offset | Offset | 阴影偏移量 | 否 | Offset.zero |
| padding | EdgeInsetsGeometry | 内容内边距;有标题或元信息且未显式传时自动取主题 hSpacingMd / vSpacingMd | 否 | EdgeInsets.zero |
| circular | double | 圆角 | 否 | 12 |
| blurRadius | double | 阴影模糊程度 | 否 | 5 |
| spreadRadius | double | 阴影扩散程度 | 否 | 0 |
| borderWidth | double | 边框宽度,传 0 去掉边框 | 否 | 0.5 |

### SantoCardMeta

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| avatar | Widget? | 头像或图标 | 否 | null |
| title | String? | 标题文案 | 否 | null |
| description | String? | 描述文案,支持换行 | 否 | null |

## 四、示例代码

### 基础用法

```dart
SantoCard(
  padding: EdgeInsets.all(15),
  child: Text('基础卡片,这里放内容区域'),
)
```

### 标题与操作

```dart
SantoCard(
  title: '卡片标题',
  extra: SantoIcon(SantoIcons.moreHoriz),
  child: Text('头部由 title / extra 组成,内容紧跟其后'),
)
```

### 自定义标题

```dart
SantoCard(
  titleWidget: Row(
    children: [
      SantoIcon(SantoIcons.star, size: 16),
      SantoSpace.gap(4),
      Text('带图标的标题'),
    ],
  ),
  extra: SantoIcon(SantoIcons.arrowRight, size: 16),
  child: Text('标题与操作区都可以完全自定义'),
)
```

### 元信息

```dart
SantoCard(
  meta: const SantoCardMeta(
    avatar: SantoAvatar(
      text: 'S',
      size: 40,
      backgroundColor: Color(0xFF1677FF),
    ),
    title: 'Santo UI',
    description: '基于 Flutter 的企业级组件库,元信息区下面才是卡片内容。',
  ),
  child: Text('卡片内容'),
)
```

### 外观自定义:圆角 / 阴影 / 背景与边框

```dart
SantoCard(circular: 24, child: Text('大圆角'))

SantoCard(
  shadowColor: Color(0x331677FF),
  blurRadius: 12,
  child: Text('蓝色柔和阴影'),
)

SantoCard(
  color: Color(0xFFE8F3FF),
  borderWidth: 0,
  child: Text('浅蓝背景,无边框'),
)
```

## 五、版本变更

### v1.1.0

- **变更**: 由 `SantoShadowCard` 改名为 `SantoCard`
- **新增**: `title` / `titleWidget` / `extra` / `meta` 参数
- **新增**: `SantoCardMeta`(头像 + 标题 + 描述)
- **变更**: 默认背景改为主题 `fillBase`(白)
