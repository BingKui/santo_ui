---
title: SantoCell / SantoCellGroup
group:
  title: 单元格
  order: 1
---

# SantoCell / SantoCellGroup

标准列表行布局,支持左图标 + 标题 + 描述 + 右侧内容/箭头,适用于设置页面、列表展示等场景。

## 一、效果总览

- 左侧支持图标或自定义组件
- 中间支持标题 + 描述文字两行布局
- 右侧支持备注文字、图标、箭头或自定义组件
- `SantoCellGroup` 将多个 Cell 组合在一起,自带背景和标题

## 二、描述

### 适用场景
1. 设置页面的选项列表
2. 信息展示列表
3. 表单输入项容器
4. 导航跳转列表

### 使用规范
- 右侧同时设置 `note`、`rightIcon`、`showArrow` 时,优先级为: `rightWidget` > `note/rightIcon/showArrow`
- 左侧同时设置 `leftIcon` 和 `leftWidget` 时,`leftWidget` 优先级更高
- 可通过 `topLine`/`bottomLine` 控制分割线显示
- `minHeight` 确保统一的高度对齐

## 三、构造函数及参数说明

### SantoCell

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| title | String? | 标题 | 否 | null |
| description | String? | 标题下方的描述文字 | 否 | null |
| note | String? | 右侧备注文字 | 否 | null |
| leftIcon | IconData? | 左侧图标 | 否 | null |
| leftWidget | Widget? | 左侧自定义组件 | 否 | null |
| rightIcon | IconData? | 右侧图标 | 否 | null |
| showArrow | bool | 是否显示右侧箭头 | 否 | true |
| onTap | VoidCallback? | 点击回调 | 否 | null |
| topLine | bool | 是否显示上分割线 | 否 | false |
| bottomLine | bool | 是否显示下分割线 | 否 | true |
| rightWidget | Widget? | 右侧自定义组件 | 否 | null |
| titleStyle | TextStyle? | 标题文字样式 | 否 | null |
| descriptionStyle | TextStyle? | 描述文字样式 | 否 | null |
| padding | EdgeInsetsGeometry? | 内边距 | 否 | null |
| minHeight | double | 最小高度 | 否 | 56 |

### SantoCellGroup

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| children | List\<Widget\> | 子组件列表 | 是 | - |
| title | String? | 组标题 | 否 | null |
| titleStyle | TextStyle? | 组标题样式 | 否 | null |
| backgroundColor | Color? | 背景颜色 | 否 | null(白色) |

## 四、示例代码

### 基础用法

```dart
SantoCell(
  title: '账号与安全',
  showArrow: true,
  onTap: () {},
)
```

### 带图标和描述

```dart
SantoCell(
  leftIcon: Icons.person,
  title: '个人资料',
  description: '编辑你的个人信息',
  note: '已完成',
)
```

### 右侧自定义组件

```dart
SantoCell(
  title: '夜间模式',
  rightWidget: Switch(value: true, onChanged: (v) {}),
  showArrow: false,
)
```

### 单元格组

```dart
SantoCellGroup(
  title: '通用设置',
  children: [
    SantoCell(title: '语言', note: '简体中文'),
    SantoCell(title: '字体大小', note: '标准'),
    SantoCell(title: '清除缓存', bottomLine: false),
  ],
)
```
