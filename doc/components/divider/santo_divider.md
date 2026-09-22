---
title: SantoDivider
group:
  title: 单元格
  order: 2
---

# SantoDivider

区隔内容的分割线,支持水平/垂直方向、实线/虚线、带标题文本。

## 一、效果总览

- 支持水平和垂直两种方向
- 支持实线和虚线两种样式
- 可带标题文本,标题位置支持左/中/右
- 支持多种尺寸档位(small/medium/large)
- 支持用 `spacing` 自定义上下间距(优先于 size,传 0 去掉留白)

## 二、描述

### 适用场景
1. 内容区块之间的分隔
2. 表单字段之间的分组
3. 列表项之间的视觉分隔
4. 垂直方向的元素分隔(如按钮之间)

### 使用规范
- 水平分割线默认上下间距为 medium 档,可根据内容重要性调整
- 带标题时标题会自动应用弱化样式(plain 模式更明显)
- 垂直分割线常用于按钮、标签等行内元素的分隔
- 虚线(dashed)用于表示可选或次要的分隔

## 三、构造函数及参数说明

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| orientation | SantoDividerOrientation | 分割线方向(horizontal/vertical) | 否 | horizontal |
| dashed | bool | 是否为虚线 | 否 | false |
| child | Widget? | 标题内容,为 null 时渲染整条分割线 | 否 | null |
| titlePlacement | SantoDividerTitlePlacement | 标题位置(start/center/end) | 否 | center |
| plain | bool | 标题是否使用弱化样式 | 否 | false |
| titleMargin | double? | start/end 位置时标题与边缘的距离 | 否 | null(12) |
| size | SantoDividerSize | 水平分割线的上下间距 | 否 | medium |
| spacing | double? | 自定义上下间距,优先于 `size`;传 0 可完全去掉上下留白 | 否 | null |
| color | Color? | 分割线颜色 | 否 | null(主题分割线颜色) |
| thickness | double | 分割线粗细 | 否 | 1 |
| verticalHeight | double | 垂直分割线的高度 | 否 | 16 |
| verticalMargin | double | 垂直分割线的左右间距 | 否 | 8 |

## 四、示例代码

### 基础分割线

```dart
SantoDivider()
```

### 带居中标题

```dart
SantoDivider(child: const Text('更多推荐'))
```

### 虚线分割线

```dart
SantoDivider(dashed: true)
```

### 左侧标题

```dart
SantoDivider(
  child: const Text('注意事项'),
  titlePlacement: SantoDividerTitlePlacement.start,
)
```

### 垂直分割线

```dart
Row(
  children: [
    ElevatedButton(onPressed: () {}, child: const Text('确认')),
    SantoDivider(orientation: SantoDividerOrientation.vertical),
    TextButton(onPressed: () {}, child: const Text('取消')),
  ],
)
```

### 大间距分割线

```dart
SantoDivider(size: SantoDividerSize.large)
```

### 自定义间距

```dart
// 上下各留 30
SantoDivider(spacing: 30)

// 去掉上下留白,线紧贴上下内容(外层行内边距已足够时用)
SantoDivider(spacing: 0)

// spacing 优先于 size:实际间距为 6,而不是 large 档的 20
SantoDivider(size: SantoDividerSize.large, spacing: 6)
```

## 五、版本变更

### v1.3.0

- **新增**: `spacing` 参数,自定义水平分割线的上下间距,优先于 `size`;传 0 可完全去掉上下留白
