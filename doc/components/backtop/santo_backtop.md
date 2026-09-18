---
title: SantoBackTop
group:
  title: 返回顶部
  order: 1
---

# SantoBackTop

用于长列表快速回到顶部。监听滚动位置,超过阈值时显示按钮,点击后平滑滚动回顶部。

## 一、效果总览

- 滚动超过阈值时自动显示
- 点击后平滑滚动到顶部
- 支持自定义按钮样式
- 需在 Stack 中使用

## 二、描述

### 适用场景
1. 长文章阅读页面
2. 商品列表页
3. 动态信息流
4. 任何需要快速回到顶部的长滚动页面

### 使用规范
- 必须在 Stack 中使用,以便定位到页面右下角
- `scrollController` 必须绑定到可滚动组件
- 默认按钮为圆形,可通过 `child` 自定义样式
- 滚动动画时长可根据页面内容长度调整

## 三、构造函数及参数说明

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| scrollController | ScrollController | 滚动控制器 | 是 | - |
| visibilityThreshold | double | 显示按钮的滚动阈值 | 否 | 400 |
| child | Widget? | 自定义按钮组件 | 否 | null(默认样式) |
| duration | Duration | 滚动回顶部的动画时长 | 否 | 300ms |

## 四、示例代码

### 基础用法

```dart
final scrollController = ScrollController();

Stack(
  children: [
    ListView.builder(
      controller: scrollController,
      itemCount: 100,
      itemBuilder: (context, index) => ListTile(title: Text('Item $index')),
    ),
    SantoBackTop(scrollController: scrollController),
  ],
)
```

### 自定义按钮样式

```dart
SantoBackTop(
  scrollController: scrollController,
  visibilityThreshold: 300,
  duration: const Duration(milliseconds: 500),
  child: Container(
    width: 48,
    height: 48,
    decoration: BoxDecoration(
      color: Colors.blue,
      shape: BoxShape.circle,
    ),
    child: const Icon(Icons.keyboard_arrow_up, color: Colors.white),
  ),
)
```
