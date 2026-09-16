---
title: SantoSkeleton
group:
  title: 反馈
  order: 7
---

# SantoSkeleton

骨架屏:内容加载前的占位反馈。API 参考 TDesign Flutter 的 Skeleton。

## 一、效果总览

支持文本/头像/图片/宫格四种预设主题,自定义行列结构,渐变扫光/闪烁/无动画,延迟显示。

## 二、描述

### 适用场景
1. 列表、详情页等网络数据加载前的占位。
2. 避免加载过程中页面跳动。

### 使用规范
- 骨架屏结构应与真实内容布局近似。
- 快速加载(<300ms)场景建议配合 `delay` 避免闪烁。

## 三、构造函数及参数说明

### SantoSkeleton

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| theme | SantoSkeletonTheme | 预设主题 text/avatar/image/grid | 否 | text |
| animation | SantoSkeletonAnimation | 动画 none/gradient/flashed | 否 | gradient |
| delay | int | 延迟显示毫秒数 | 否 | 0 |

### SantoSkeleton.fromRowCol

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| rowCol | SantoSkeletonRowCol | 自定义行列结构 | 是 | 无 |
| animation / delay | 同上 | 同上 | 否 | 同上 |

### SantoSkeletonRowCol

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| objects | List&lt;List&lt;SantoSkeletonRowColObj&gt;&gt; | 行列对象,外层为行 | 是 | 无 |
| rowSpacing | double | 行间距 | 否 | 16 |

### SantoSkeletonRowColObj

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| flex | int? | 弹性因子,null 时按 width 固定 | 否 | 1 |
| width | double? | 固定宽度 | 否 | null |
| height | double | 高度 | 否 | 16 |
| margin | EdgeInsetsGeometry | 外边距 | 否 | zero |
| style | SantoSkeletonObjStyle | 样式(text/circle/rect/spacer) | 否 | text |

工厂构造:`circle(size)` / `rect(width,height)` / `spacer(flex)` / `text(flex,width,height)`。

## 四、示例代码

```dart
SantoSkeleton(theme: SantoSkeletonTheme.avatar)

SantoSkeleton.fromRowCol(
  rowCol: SantoSkeletonRowCol(objects: [
    [SantoSkeletonRowColObj.rect(width: 48, height: 48)],
    [SantoSkeletonRowColObj(), SantoSkeletonRowColObj.spacer()],
  ]),
)
```
