---
title: SantoStepper
group:
  title: 步进器
  order: 1
---

# SantoStepper

数量增减控件,支持最小值/最大值限制、步长设置、禁用状态,以及 small/normal/large 三档尺寸。

## 一、效果总览

- 支持减号和加号按钮控制数值
- 可设置最小值、最大值和步长
- 支持禁用状态
- 三种尺寸档位(small/normal/large)

## 二、描述

### 适用场景
1. 购物车商品数量调整
2. 表单中的数字输入(如年龄、数量)
3. 规格选择(如尺寸、份数)
4. 需要精确控制数字增减的场景

### 使用规范
- 当前值为 min 时减号自动禁用,为 max 时加号自动禁用
- enabled 为 false 时整个控件禁用,两个按钮都不可点击
- 小尺寸适合紧凑列表,大尺寸适合主要操作区域
- step 默认为 1,可设置为其他正整数实现跳跃增减

## 三、构造函数及参数说明

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| value | int | 当前值 | 是 | - |
| min | int | 最小值 | 否 | 0 |
| max | int | 最大值 | 否 | 99 |
| step | int | 步长 | 否 | 1 |
| enabled | bool | 是否启用 | 否 | true |
| onChanged | ValueChanged\<int\> | 值变化回调 | 是 | - |
| size | SantoStepperSize | 尺寸档位(small/normal/large) | 否 | normal |
| inputWidth | double? | 数值区宽度 | 否 | null(预设值) |
| inputHeight | double? | 控件高度 | 否 | null(预设值) |
| buttonColor | Color? | 按钮颜色 | 否 | null |
| disabledColor | Color? | 按钮禁用颜色 | 否 | null |
| textColor | Color? | 文字颜色 | 否 | null |

## 四、示例代码

### 基础用法

```dart
SantoStepper(
  value: 5,
  min: 1,
  max: 10,
  onChanged: (value) {},
)
```

### 小尺寸(适合列表项)

```dart
SantoStepper(
  value: 2,
  size: SantoStepperSize.small,
  onChanged: (value) {},
)
```

### 大尺寸(适合主要操作)

```dart
SantoStepper(
  value: 1,
  min: 1,
  max: 5,
  size: SantoStepperSize.large,
  onChanged: (value) {},
)
```

### 自定义步长

```dart
SantoStepper(
  value: 100,
  step: 10,
  min: 0,
  max: 1000,
  onChanged: (value) {},
)
```

### 禁用状态

```dart
SantoStepper(
  value: 3,
  enabled: false,
  onChanged: (value) {},
)
```
