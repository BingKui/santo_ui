---
title: SantoIcon
group:
  title: 图标
  order: 1
---

# SantoIcon

统一图标入口。图标数据源为开源的 [Iconoir](https://iconoir.com) 图标库(MIT 协议),
SVG 资源全量内置在 `assets/icons/iconoir/`,组件按**名称**取用。

## 一、效果总览

- 图标 SVG 全量内置,共 **1383** 个常规图标,不依赖运行时网络与三方图标包
- 按名称取用,名称即 SVG 文件名;`SantoIcons` 提供全部名称常量,有补全与拼写检查
- 尺寸默认跟随主题 `iconSizeMd`,颜色默认跟随主题正文色
- 支持 `iconSizeXxs / Xs / Sm / Md / Lg` 五档尺寸语义
- 支持无障碍语义标签

## 二、描述

### 适用场景

1. 操作按钮、导航栏、列表项中的功能图标
2. 状态提示(成功 / 警告 / 错误 / 加载)
3. 输入框、搜索框的前后缀图标
4. 与文本组合的行内图标

### 使用规范

- 图标为**单色描边**风格,颜色统一由 `color` 决定,无法保留多色;需要多色插画请继续使用图片资源
- 尺寸统一走主题档位,不要为单个图标写魔法数字,避免同页面图标大小不一致
- 图标本身不带交互,点击场景请配合 `GestureDetector` / `InkWell` 使用
- 纯装饰性图标不要传 `semanticLabel`,避免读屏重复播报

### 图标名称与资源

- 名称即 `assets/icons/iconoir/<名称>.svg` 的文件名(不带 `.svg`),例如 `search`、`nav-arrow-right`
- `SantoIcons` 常量与文件名一一对应,`SantoIcons.navArrowRight` 即 `'nav-arrow-right'`
- 需要新增图标时,把 Iconoir 的 SVG 放入 `assets/icons/iconoir/` 并在 `SantoIcons` 中补一条常量即可
- Iconoir 原始协议文本随资源一并存放于 `assets/icons/iconoir/LICENSE`

## 三、构造函数及参数说明

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| name | String | 图标名称,取值见 `SantoIcons` | 是 | - |
| size | double? | 图标边长 | 否 | null(主题 `iconSizeMd`,16) |
| color | Color? | 图标颜色 | 否 | null(主题正文色) |
| semanticLabel | String? | 无障碍语义标签,为 null 时对读屏不可见 | 否 | null |

## 四、示例代码

### 基础用法

```dart
SantoIcon(SantoIcons.search)
```

### 按名称直接使用

```dart
SantoIcon('nav-arrow-right')
```

### 指定尺寸

```dart
SantoIcon(SantoIcons.star, size: 32)
```

### 指定颜色

```dart
SantoIcon(SantoIcons.checkCircle, size: 16, color: Colors.green)
```

### 与文字并排

```dart
Row(
  children: [
    SantoIcon(SantoIcons.infoCircle, size: 14),
    SantoSpace.gap(4),
    Text('资料提交后 1 个工作日内完成审核'),
  ],
)
```

### 可点击图标

```dart
GestureDetector(
  onTap: () {},
  child: SantoIcon(SantoIcons.star, size: 20, color: Colors.orange),
)
```

### 无障碍标签

```dart
SantoIcon(SantoIcons.search, semanticLabel: '搜索')
```

## 五、版本变更

### v2.0.0

- **新增**: `SantoIcon` 组件与 `SantoIcons` 图标名称常量
- **新增**: 内置 Iconoir 常规图标 SVG 资源(`assets/icons/iconoir/`,1383 个)
