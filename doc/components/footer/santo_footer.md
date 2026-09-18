---
title: SantoFooter
group:
  title: 页脚
  order: 1
---

# SantoFooter

用于页面底部区域,支持显示文字、链接和 logo,内容居中排列。

## 一、效果总览

- 支持版权信息等文字展示
- 支持多个链接横向排列
- 支持自定义 logo
- 内容自动居中对齐

## 二、描述

### 适用场景
1. 页面底部版权信息
2. 友情链接区域
3. 品牌 logo 展示
4. 法律条款链接

### 使用规范
- 文字通常使用较小字号和次要颜色
- 链接之间会自动添加间距
- logo 会显示在文字上方
- 上下内边距默认较大,确保视觉平衡

## 三、构造函数及参数说明

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| text | String? | 底部文字,如版权信息 | 否 | null |
| links | List\<SantoFooterLink\>? | 链接列表 | 否 | null |
| logo | Widget? | 自定义 logo 组件 | 否 | null |
| textStyle | TextStyle? | 文字样式 | 否 | null |
| linkStyle | TextStyle? | 链接文字样式 | 否 | null |
| spacing | double | 各部分之间的间距 | 否 | 12 |
| topPadding | double | 上边距 | 否 | 24 |
| bottomPadding | double | 下边距 | 否 | 24 |

### SantoFooterLink

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| text | String | 链接文字 | 是 | - |
| onTap | VoidCallback? | 点击回调 | 否 | null |

## 四、示例代码

### 基础用法

```dart
SantoFooter(text: '© 2024 Santo UI. All rights reserved.')
```

### 带链接

```dart
SantoFooter(
  text: '© 2024 Santo UI',
  links: [
    SantoFooterLink(text: '隐私政策', onTap: () {}),
    SantoFooterLink(text: '用户协议', onTap: () {}),
  ],
)
```

### 带 Logo

```dart
SantoFooter(
  logo: Image.asset('assets/logo.png', height: 32),
  text: 'Powered by Santo',
)
```

### 自定义样式

```dart
SantoFooter(
  text: 'Copyright © 2024',
  textStyle: const TextStyle(fontSize: 12, color: Colors.grey),
  linkStyle: const TextStyle(fontSize: 12, color: Colors.blue),
  spacing: 8,
)
```
