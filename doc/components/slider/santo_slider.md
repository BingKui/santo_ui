---
title: SantoSlider
group:
  title: 滑块
  order: 1
---

# SantoSlider

支持单值和双值(范围)模式的滑块,支持刻度标记和自定义颜色。

## 一、效果总览

- 支持单值模式和范围模式
- 可显示刻度标记
- 支持拖动时显示值标签
- 可自定义激活/未激活区域颜色

## 二、描述

### 适用场景
1. 价格区间筛选
2. 音量/亮度调节
3. 评分滑动选择
4. 数值范围选择(如年龄范围)

### 使用规范
- 单值模式使用 `value`,范围模式使用 `rangeValue`,两者二选一
- `divisions` 为 0 时不显示刻度,大于 0 时显示对应数量的刻度点
- 范围模式下 `rangeValue` 必须是长度为 2 的列表 [start, end]
- onChanged 回调在单值模式返回 double,范围模式返回 List<double>

## 三、构造函数及参数说明

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| min | double | 最小值 | 否 | 0 |
| max | double | 最大值 | 否 | 100 |
| value | double? | 单值模式的当前值 | 否 | null |
| rangeValue | List\<double\>? | 范围模式的当前值 [start, end] | 否 | null |
| divisions | int | 刻度数量,0 表示不显示刻度 | 否 | 0 |
| showLabel | bool | 是否显示当前值标签 | 否 | false |
| label | String? | 拖动时显示的标签文案 | 否 | null(当前值取整) |
| semanticFormatterCallback | String Function(double)? | 无障碍语义格式化回调 | 否 | null |
| activeColor | Color? | 激活区域颜色 | 否 | null(brandPrimary) |
| inactiveColor | Color? | 未激活区域颜色 | 否 | null |
| onChanged | ValueChanged\<dynamic\> | 值变化回调 | 是 | - |
| onChangeStart | ValueChanged\<dynamic\>? | 开始拖动回调 | 否 | null |
| onChangeEnd | ValueChanged\<dynamic\>? | 结束拖动回调 | 否 | null |

## 四、示例代码

### 单值模式基础用法

```dart
SantoSlider(
  value: 50,
  min: 0,
  max: 100,
  onChanged: (value) {},
)
```

### 范围模式

```dart
SantoSlider(
  rangeValue: const [20, 80],
  min: 0,
  max: 100,
  onChanged: (values) {
    print('Range: ${values[0]} - ${values[1]}');
  },
)
```

### 带刻度和标签

```dart
SantoSlider(
  value: 60,
  divisions: 10,
  showLabel: true,
  onChanged: (value) {},
)
```

### 自定义颜色

```dart
SantoSlider(
  value: 75,
  activeColor: Colors.blue,
  inactiveColor: Colors.grey.shade300,
  onChanged: (value) {},
)
```

### 价格区间选择

```dart
SantoSlider(
  rangeValue: const [100, 500],
  min: 0,
  max: 1000,
  divisions: 20,
  showLabel: true,
  label: '¥${value.toInt()}',
  onChanged: (values) {},
)
```
