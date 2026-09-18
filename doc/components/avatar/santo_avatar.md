---
title: SantoAvatar / SantoAvatarGroup
group:
  title: 头像
  order: 1
---

# SantoAvatar / SantoAvatarGroup

支持图片、文字、图标三种模式的头像组件,`SantoAvatarGroup` 将多个头像以重叠方式水平排列。

## 一、效果总览

- 支持图片、文字、图标三种展示模式
- 支持圆形和圆角方形两种形状
- `SantoAvatarGroup` 支持头像重叠排列
- 可自定义背景色、边框、圆角等样式

## 二、描述

### 适用场景
1. 用户个人信息展示
2. 联系人列表
3. 评论/消息中的用户标识
4. 团队成员展示(使用 Group)

### 使用规范
- 图片模式优先显示 `imageUrl`,文字模式显示 `text` 首字符,图标模式显示 `icon`
- 圆角方形(`round`)时通过 `radius` 控制圆角大小
- Group 中可通过 `maxCount` 限制显示数量,超出部分显示 "+N"

## 三、构造函数及参数说明

### SantoAvatar

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| imageUrl | String? | 图片地址 | 否 | null |
| text | String? | 显示的文字 | 否 | null |
| icon | IconData? | 显示的图标 | 否 | null |
| size | double | 头像尺寸(宽高) | 否 | 40 |
| shape | SantoAvatarShape | 头像形状(circle/round) | 否 | circle |
| backgroundColor | Color? | 背景颜色 | 否 | null(主题次要文字色) |
| borderColor | Color? | 边框颜色 | 否 | null |
| radius | double | 圆角大小(仅 round 形状生效) | 否 | 12 |
| textStyle | TextStyle? | 文字样式 | 否 | null |
| iconColor | Color? | 图标颜色 | 否 | null |

### SantoAvatarGroup

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| avatars | List\<SantoAvatar\> | 头像列表 | 是 | - |
| overlap | double | 头像之间的重叠距离 | 否 | 10 |
| size | double | 头像尺寸 | 否 | 36 |
| maxCount | int? | 最大显示数量,超出显示 "+N" | 否 | null |

## 四、示例代码

### 图片头像

```dart
SantoAvatar(
  imageUrl: 'https://example.com/avatar.png',
  size: 48,
)
```

### 文字头像

```dart
SantoAvatar(
  text: '张三',
  size: 40,
  backgroundColor: Colors.blue,
)
```

### 图标头像

```dart
SantoAvatar(
  icon: Icons.person,
  size: 40,
  shape: SantoAvatarShape.round,
  radius: 8,
)
```

### 头像组

```dart
SantoAvatarGroup(
  avatars: [
    SantoAvatar(text: 'A', size: 36),
    SantoAvatar(text: 'B', size: 36),
    SantoAvatar(text: 'C', size: 36),
  ],
  overlap: 12,
  maxCount: 5,
)
```
