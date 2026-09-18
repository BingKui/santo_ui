---
title: SantoProgress / SantoCircularProgress
group:
  title: 进度条
  order: 1
---

# SantoProgress / SantoCircularProgress

线性进度条和环形进度条,用于展示操作的完成进度。

## 一、效果总览

**SantoProgress(线性)**:
- 水平方向的进度条
- 可选显示百分比标签
- 支持动画过渡

**SantoCircularProgress(环形)**:
- 环形进度指示器
- 默认显示百分比标签
- 可自定义半径和线宽

## 二、描述

### 适用场景
1. 文件上传/下载进度
2. 任务完成度展示
3. 加载状态提示
4. 数据统计可视化(如完成率)

### 使用规范
- value 范围为 0.0~1.0,超出范围会被截断
- 线性进度条适合长条形容器,环形适合紧凑空间
- 环形进度条默认显示标签,线性默认不显示
- 动画效果可通过 `animated` 参数关闭

## 三、构造函数及参数说明

### SantoProgress

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| value | double | 进度值,范围 0.0~1.0 | 是 | - |
| color | Color? | 进度条颜色 | 否 | null(brandPrimary) |
| backgroundColor | Color? | 背景色 | 否 | null(灰色) |
| strokeWidth | double | 进度条高度 | 否 | 8.0 |
| showLabel | bool | 是否显示百分比标签 | 否 | false |
| labelStyle | TextStyle? | 百分比标签样式 | 否 | null |
| animated | bool | 是否使用动画过渡 | 否 | true |

### SantoCircularProgress

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| radius | double | 环形半径 | 否 | 30.0 |
| strokeWidth | double | 环形线宽 | 否 | 6.0 |
| value | double | 进度值,范围 0.0~1.0 | 是 | - |
| color | Color? | 进度条颜色 | 否 | null(brandPrimary) |
| backgroundColor | Color? | 背景环颜色 | 否 | null |
| showLabel | bool | 是否显示百分比标签 | 否 | true |
| labelStyle | TextStyle? | 标签样式 | 否 | null |

## 四、示例代码

### 线性进度条基础用法

```dart
SantoProgress(value: 0.6)
```

### 带百分比标签

```dart
SantoProgress(
  value: 0.75,
  showLabel: true,
  strokeWidth: 12,
)
```

### 自定义颜色

```dart
SantoProgress(
  value: 0.5,
  color: Colors.green,
  backgroundColor: Colors.grey.shade200,
)
```

### 环形进度条

```dart
SantoCircularProgress(
  value: 0.8,
  radius: 40,
  strokeWidth: 8,
)
```

### 小尺寸环形进度

```dart
SantoCircularProgress(
  value: 0.45,
  radius: 20,
  strokeWidth: 4,
  showLabel: false,
)
```
