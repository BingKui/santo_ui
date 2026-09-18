---
title: SantoImage
group:
  title: 增强图片
  order: 1
---

# SantoImage

支持圆角、占位图、加载失败态的图片组件,支持网络图片和本地图片。

## 一、效果总览

- 支持网络图片和本地资源
- 可设置圆角半径
- 支持加载中占位图
- 支持加载失败时的错误提示
- 支持多种图片缩放模式

## 二、描述

### 适用场景
1. 列表中的缩略图
2. 详情页大图展示
3. 头像背景图
4. Banner 轮播图
5. 需要圆角展示的图片

### 使用规范
- 网络图片 `isNetwork` 默认为 true,本地图片需设置为 false
- `fit` 默认使用 cover,确保填满容器
- 建议为重要图片提供有意义的 `placeholder` 和 `errorWidget`
- 圆角 `radius` 为 0 时无圆角效果

## 三、构造函数及参数说明

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| imageUrl | String | 图片地址(网络 URL 或本地资源路径) | 是 | - |
| width | double? | 图片宽度 | 否 | null |
| height | double? | 图片高度 | 否 | null |
| radius | double | 圆角半径 | 否 | 0 |
| fit | BoxFit | 图片缩放模式 | 否 | cover |
| placeholder | Widget? | 加载中的占位组件 | 否 | null |
| errorWidget | Widget? | 加载失败的组件 | 否 | null |
| isNetwork | bool | 是否为网络图片 | 否 | true |

## 四、示例代码

### 网络图片

```dart
SantoImage(
  imageUrl: 'https://example.com/image.jpg',
  width: 200,
  height: 150,
)
```

### 圆角图片

```dart
SantoImage(
  imageUrl: 'https://example.com/avatar.jpg',
  width: 100,
  height: 100,
  radius: 12,
)
```

### 带占位图和错误提示

```dart
SantoImage(
  imageUrl: 'https://example.com/photo.jpg',
  placeholder: const Center(child: CircularProgressIndicator()),
  errorWidget: const Icon(Icons.broken_image, size: 48),
  width: 300,
  height: 200,
)
```

### 本地图片

```dart
SantoImage(
  imageUrl: 'assets/images/logo.png',
  isNetwork: false,
  width: 120,
  height: 60,
)
```

### 圆形头像

```dart
SantoImage(
  imageUrl: 'https://example.com/user.jpg',
  width: 80,
  height: 80,
  radius: 40,
  fit: BoxFit.cover,
)
```
