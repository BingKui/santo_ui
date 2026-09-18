---
title: SantoDropdownMenu / SantoDropdownMenuItem
group:
  title: 下拉菜单
  order: 1
---

# SantoDropdownMenu / SantoDropdownMenuItem

包含多个 SantoDropdownMenuItem 的横向菜单栏,点击后在下方展开对应的下拉内容。

## 一、效果总览

- 横向排列的多个菜单项
- 点击菜单项展开下拉选项列表
- 支持自定义下拉内容
- 选中项高亮显示

## 二、描述

### 适用场景
1. 表格筛选条件(如按状态、时间、类型筛选)
2. 排序选项切换
3. 视图模式切换
4. 多条件组合筛选

### 使用规范
- 每个 SantoDropdownMenuItem 代表一个筛选维度
- options 用于简单选项列表,customContentBuilder 用于复杂自定义内容
- selectedValue 用于控制当前选中项,配合 onChanged 实现受控用法
- 激活状态颜色可通过 activeColor 统一设置

## 三、构造函数及参数说明

### SantoDropdownMenu

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| children | List\<SantoDropdownMenuItem\> | 菜单项列表 | 是 | - |
| activeColor | Color? | 激活状态颜色 | 否 | null |

### SantoDropdownMenuItem

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| title | String | 菜单项标题 | 是 | - |
| options | List\<SantoDropdownMenuOption\> | 选项列表 | 是 | - |
| selectedValue | String? | 当前选中的值 | 否 | null |
| onChanged | SantoDropdownMenuChangedCallback? | 选中值变化回调 | 否 | null |
| activeColor | Color? | 激活状态颜色 | 否 | null |
| customContentBuilder | WidgetBuilder? | 自定义下拉内容 | 否 | null |

### SantoDropdownMenuOption

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| label | String | 显示文本 | 是 | - |
| value | String | 唯一标识 | 是 | - |

## 四、示例代码

### 基础用法

```dart
SantoDropdownMenu(
  children: [
    SantoDropdownMenuItem(
      title: '状态',
      options: const [
        SantoDropdownMenuOption(label: '全部', value: 'all'),
        SantoDropdownMenuOption(label: '进行中', value: 'active'),
        SantoDropdownMenuOption(label: '已完成', value: 'completed'),
      ],
      selectedValue: 'all',
      onChanged: (value) {},
    ),
    SantoDropdownMenuItem(
      title: '排序',
      options: const [
        SantoDropdownMenuOption(label: '时间倒序', value: 'time_desc'),
        SantoDropdownMenuOption(label: '时间正序', value: 'time_asc'),
      ],
      onChanged: (value) {},
    ),
  ],
)
```

### 自定义下拉内容

```dart
SantoDropdownMenuItem(
  title: '高级筛选',
  options: const [],
  customContentBuilder: (context) => Container(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 自定义筛选表单
      ],
    ),
  ),
)
```
