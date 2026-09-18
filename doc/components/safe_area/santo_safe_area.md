---
title: SantoSafeArea
group:
  title: 安全区域
  order: 1
---

# SantoSafeArea

统一处理顶部与底部的安全区域(状态栏/刘海区域和 Home Indicator 区域),左右两侧不处理。

## 一、效果总览

- 自动适配设备的安全区域
- 可选择性处理顶部或底部
- 支持最小安全高度设置
- 支持键盘弹出时保持底部安全区域

## 二、描述

### 适用场景
1. 全屏页面的安全区域适配
2. 需要避开刘海屏的顶部内容
3. 底部固定操作栏的安全区域预留
4. 键盘弹出时的底部安全处理

### 使用规范
- 默认同时处理顶部和底部安全区域
- top/bottom 可单独控制是否处理某个方向
- minimum 可设置最小安全高度,确保即使系统安全区域很小也有足够的留白
- maintainBottomViewPadding 为 true 时键盘弹出仍保持底部安全距离

## 三、构造函数及参数说明

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| child | Widget | 子控件 | 是 | - |
| top | bool | 是否处理顶部安全区域 | 否 | true |
| bottom | bool | 是否处理底部安全区域 | 否 | true |
| minimum | EdgeInsets | 安全区域最小高度 | 否 | EdgeInsets.zero |
| maintainBottomViewPadding | bool | 键盘弹出时是否保持底部安全区域 | 否 | false |

## 四、示例代码

### 基础用法

```dart
SantoSafeArea(
  child: Scaffold(
    body: ListView(...),
  ),
)
```

### 只处理顶部

```dart
SantoSafeArea(
  top: true,
  bottom: false,
  child: YourContent(),
)
```

### 只处理底部

```dart
SantoSafeArea(
  top: false,
  bottom: true,
  child: BottomActionBar(),
)
```

### 设置最小安全高度

```dart
SantoSafeArea(
  minimum: const EdgeInsets.only(bottom: 20),
  child: YourContent(),
)
```

### 键盘弹出时保持底部安全区域

```dart
SantoSafeArea(
  maintainBottomViewPadding: true,
  child: Column(
    children: [
      Expanded(child: TextField()),
      BottomButtons(),
    ],
  ),
)
```
