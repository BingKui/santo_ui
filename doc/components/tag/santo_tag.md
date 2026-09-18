---
title: SantoTagCustom / SantoStateTag
group:
  title: 标签
  order: 1
---

# SantoTagCustom / SantoStateTag

标签组件用于标记和分类,`SantoTagCustom` 支持自定义样式,`SantoStateTag` 提供五种预设状态。

## 一、效果总览

**SantoTagCustom**:
- 自适应内容宽度
- 可自定义背景色、文字颜色、边框
- 支持圆角和不同尺寸

**SantoStateTag**:
- 五种预设状态:default/primary/success/warning/error
- 每种状态有默认配色
- 简洁统一的视觉风格

## 二、描述

### 适用场景
1. 分类标记(如商品标签、内容分类)
2. 状态标识(如进行中、已完成)
3. 筛选条件展示
4. 关键词标签

### 使用规范
- SantoTagCustom 不要设置 alignment,让标签自适应宽度
- SantoStateTag 的状态选择应符合语义:success成功、error错误、warning警告、primary主要、default默认
- 标签文字不宜过长,建议简短明了
- 多个标签之间应保持适当间距

## 三、构造函数及参数说明

### SantoTagCustom

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| text | String | 标签文本 | 是 | - |
| backgroundColor | Color? | 背景色 | 否 | null |
| textColor | Color? | 文字颜色 | 否 | null |
| borderColor | Color? | 边框颜色 | 否 | null |
| radius | double | 圆角半径 | 否 | 4 |
| padding | EdgeInsets? | 内边距 | 否 | null |
| textStyle | TextStyle? | 文字样式 | 否 | null |
| onTap | VoidCallback? | 点击回调 | 否 | null |

### SantoStateTag

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| text | String | 标签文本 | 是 | - |
| state | SantoTagState | 标签状态(default/primary/success/warning/error) | 否 | default |
| size | SantoTagSize | 标签尺寸(small/medium/large) | 否 | medium |
| onTap | VoidCallback? | 点击回调 | 否 | null |

## 四、示例代码

### SantoTagCustom 基础用法

```dart
SantoTagCustom(text: '新品')
```

### 自定义样式

```dart
SantoTagCustom(
  text: '自定义',
  backgroundColor: Colors.purple.shade50,
  textColor: Colors.purple,
  borderColor: Colors.purple,
  radius: 8,
)
```

### SantoStateTag 五种状态

```dart
Wrap(
  spacing: 8,
  children: [
    SantoStateTag(text: '默认', state: SantoTagState.default),
    SantoStateTag(text: '主要', state: SantoTagState.primary),
    SantoStateTag(text: '成功', state: SantoTagState.success),
    SantoStateTag(text: '警告', state: SantoTagState.warning),
    SantoStateTag(text: '错误', state: SantoTagState.error),
  ],
)
```

### 不同尺寸

```dart
SantoStateTag(
  text: '大标签',
  size: SantoTagSize.large,
)
```

### 可点击标签

```dart
SantoTagCustom(
  text: '点击我',
  onTap: () {
    print('Tag tapped');
  },
)
```
