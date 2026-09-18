---
title: SantoSegmented
group:
  title: 分段选择器
  order: 1
---

# SantoSegmented

在多个选项中选择一个,切换时白色滑块在选项间滑动。参考 antd Segmented。支持受控/非受控用法。

## 一、效果总览

- 多个选项水平或垂直排列
- 切换时滑块平滑过渡
- 支持横向和纵向两种排列方向
- 支持矩形和圆角两种形状
- 支持禁用单个选项

## 二、描述

### 适用场景
1. 视图模式切换(列表/网格/地图)
2. 筛选条件切换(全部/进行中/已完成)
3. Tab 切换的替代方案
4. 任何需要在多个互斥选项中选择的场景

### 使用规范
- value 为受控用法,defaultValue 为非受控用法,两者二选一
- onChanged 为 null 时整个组件不可交互
- block 为 true 时组件会撑满父容器宽度
- disabled 为 true 时所有选项都不可点击
- tooltip 可为选项添加悬停提示(移动端表现为长按提示)

## 三、构造函数及参数说明

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| options | List\<SantoSegmentedOption\<T\>\> | 选项列表 | 是 | - |
| value | T? | 当前选中值(受控用法) | 否 | null |
| defaultValue | T? | 默认选中值(非受控用法) | 否 | null(第一个未禁用项) |
| onChanged | ValueChanged\<T\>? | 选中值变更回调 | 否 | null |
| block | bool | 是否撑满父容器宽度 | 否 | false |
| disabled | bool | 是否禁用整个组件 | 否 | false |
| size | SantoSegmentedSize | 尺寸(large/medium/small) | 否 | medium |
| orientation | SantoSegmentedOrientation | 排列方向(horizontal/vertical) | 否 | horizontal |
| shape | SantoSegmentedShape | 形状(rect/round) | 否 | rect |
| animationDuration | Duration | 滑块滑动动画时长 | 否 | 300ms |

### SantoSegmentedOption

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| value | T | 选项值 | 是 | - |
| label | String? | 显示文本 | 否 | null |
| labelWidget | Widget? | 自定义标签组件 | 否 | null |
| icon | IconData? | 图标 | 否 | null |
| disabled | bool | 是否禁用该选项 | 否 | false |
| tooltip | String? | 提示文本 | 否 | null |

## 四、示例代码

### 基础用法

```dart
SantoSegmented<String>(
  options: const [
    SantoSegmentedOption(value: 'list', label: '列表'),
    SantoSegmentedOption(value: 'grid', label: '网格'),
    SantoSegmentedOption(value: 'map', label: '地图'),
  ],
  value: currentView,
  onChanged: (value) {
    setState(() => currentView = value);
  },
)
```

### 带图标

```dart
SantoSegmented<String>(
  options: const [
    SantoSegmentedOption(value: 'day', label: '日', icon: Icons.calendar_today),
    SantoSegmentedOption(value: 'week', label: '周', icon: Icons.view_week),
    SantoSegmentedOption(value: 'month', label: '月', icon: Icons.calendar_month),
  ],
  onChanged: (value) {},
)
```

### 垂直排列

```dart
SantoSegmented<String>(
  orientation: SantoSegmentedOrientation.vertical,
  options: const [
    SantoSegmentedOption(value: 'all', label: '全部'),
    SantoSegmentedOption(value: 'active', label: '进行中'),
    SantoSegmentedOption(value: 'done', label: '已完成'),
  ],
  onChanged: (value) {},
)
```

### 圆角形状

```dart
SantoSegmented<String>(
  shape: SantoSegmentedShape.round,
  options: const [...],
  onChanged: (value) {},
)
```

### 禁用某个选项

```dart
SantoSegmented<String>(
  options: const [
    SantoSegmentedOption(value: 'free', label: '免费版'),
    SantoSegmentedOption(value: 'pro', label: '专业版', disabled: true),
    SantoSegmentedOption(value: 'enterprise', label: '企业版'),
  ],
  onChanged: (value) {},
)
```
