---
title: SantoLine
group:
  title: 分割线
  order: 1
---

# SantoLine

用于分割页面组件元素的横向分割线。与 SantoDivider 的区别在于 SantoLine 更简单,基于系统 Divider 封装。

## 一、效果总览

- 简单的横向分割线
- 可自定义颜色和粗细
- 支持左右缩进
- 基于系统 Divider 封装

## 二、描述

### 适用场景
1. 列表项之间的简单分隔
2. 内容区块的视觉分隔
3. 表单字段的分隔线
4. 需要极简分割线的场景

### 使用规范
- SantoLine 比 SantoDivider 更轻量,不带标题、虚线等高级功能
- 需要复杂功能(如带标题、虚线、垂直方向)时使用 SantoDivider
- color 默认为主题分割线颜色,可根据设计需求调整
- leftInset/rightInset 用于控制分割线不与边缘对齐

## 三、构造函数及参数说明

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| color | Color? | 分割线颜色 | 否 | null(dividerColorBase) |
| height | double | 分割线高度/粗细 | 否 | 0.5 |
| leftInset | double | 左边缩进距离 | 否 | 0 |
| rightInset | double | 右边缩进距离 | 否 | 0 |

## 四、示例代码

### 基础用法

```dart
SantoLine()
```

### 自定义颜色

```dart
SantoLine(color: Colors.grey.shade300)
```

### 加粗分割线

```dart
SantoLine(height: 1)
```

### 带左右缩进

```dart
SantoLine(leftInset: 16, rightInset: 16)
```

### 在列表中使用

```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return Column(
      children: [
        ListTile(title: Text(items[index])),
        if (index < items.length - 1) SantoLine(),
      ],
    );
  },
)
```
