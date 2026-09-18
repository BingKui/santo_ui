---
title: SantoSwiper
group:
  title: 轮播图
  order: 1
---

# SantoSwiper

支持自动播放、指示器(圆点/数字)、无限循环的轮播图组件。

## 一、效果总览

- 支持自动播放和手动滑动
- 支持圆点和数字两种指示器
- 支持无限循环播放
- 可自定义高度和子组件间距

## 二、描述

### 适用场景
1. Banner 广告轮播
2. 图片画廊展示
3. 引导页/新手引导
4. 推荐内容轮播

### 使用规范
- children 建议至少 2 个子组件,单个子组件时轮播无意义
- autoPlay 为 true 时用户滑动会重置自动播放计时器
- loop 为 true 时可实现无缝循环,为 false 时滑到尽头会停止
- 指示器可通过 `indicator` 参数关闭

## 三、构造函数及参数说明

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| children | List\<Widget\> | 子组件列表 | 是 | - |
| autoPlay | bool | 是否自动播放 | 否 | true |
| interval | int | 自动播放间隔(毫秒) | 否 | 3000 |
| indicator | bool | 是否显示指示器 | 否 | true |
| indicatorType | SantoSwiperIndicatorType | 指示器类型(dot/number) | 否 | dot |
| loop | bool | 是否无限循环 | 否 | true |
| height | double | 轮播高度 | 否 | 200.0 |
| onPageChanged | ValueChanged\<int\>? | 页面切换回调 | 否 | null |
| currentIndex | int | 当前页索引 | 否 | 0 |
| spacing | double | 子组件之间的间距 | 否 | 0.0 |
| enableSwipe | bool | 是否启用滑动切换 | 否 | true |

## 四、示例代码

### 基础用法

```dart
SantoSwiper(
  height: 200,
  children: [
    Image.network('https://example.com/banner1.jpg', fit: BoxFit.cover),
    Image.network('https://example.com/banner2.jpg', fit: BoxFit.cover),
    Image.network('https://example.com/banner3.jpg', fit: BoxFit.cover),
  ],
)
```

### 数字指示器

```dart
SantoSwiper(
  height: 180,
  indicatorType: SantoSwiperIndicatorType.number,
  children: [
    Container(color: Colors.red),
    Container(color: Colors.blue),
    Container(color: Colors.green),
  ],
)
```

### 关闭自动播放和循环

```dart
SantoSwiper(
  autoPlay: false,
  loop: false,
  height: 160,
  children: [
    // ... items
  ],
)
```

### 带页面切换回调

```dart
SantoSwiper(
  height: 200,
  onPageChanged: (index) {
    print('Current page: $index');
  },
  children: [
    // ... items
  ],
)
```

### 卡片式轮播(带间距)

```dart
SantoSwiper(
  height: 180,
  spacing: 12,
  indicator: false,
  children: [
    Card(child: Center(child: Text('Card 1'))),
    Card(child: Center(child: Text('Card 2'))),
    Card(child: Center(child: Text('Card 3'))),
  ],
)
```
