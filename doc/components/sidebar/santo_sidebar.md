---
title: SantoSidebar
group:
  title: 侧边栏
  order: 1
---

# SantoSidebar

垂直排列的标签列表,常用于分类页面左侧导航(如外卖分类页)。

## 一、效果总览

- 垂直排列的标签列表
- 选中项高亮显示并带指示条
- 支持选中回调
- 可自定义宽度、颜色、高度等样式

## 二、描述

### 适用场景
1. 外卖/电商分类页左侧导航
2. 设置页面分组导航
3. 通讯录字母索引
4. 任何需要垂直导航的场景

### 使用规范
- items 为字符串列表,每项代表一个标签
- selectedIndex 控制当前选中项,配合 onChanged 实现受控用法
- 宽度默认 90,可根据标签文字长度调整
- 选中指示条在左侧,宽度可通过 indicatorWidth 调整

## 三、构造函数及参数说明

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| items | List\<String\> | 标签列表 | 是 | - |
| selectedIndex | int | 当前选中的索引 | 否 | 0 |
| onChanged | SantoSidebarItemSelectedCallback? | 选中回调 (index, label) | 否 | null |
| width | double | 侧边栏宽度 | 否 | 90 |
| activeColor | Color? | 选中状态颜色 | 否 | null(brandPrimary) |
| inactiveColor | Color? | 未选中状态颜色 | 否 | null(#515A6E) |
| backgroundColor | Color? | 背景颜色 | 否 | null(#F5F5F5) |
| indicatorWidth | double | 选中指示条宽度 | 否 | 3 |
| itemHeight | double | 每项高度 | 否 | 56 |
| textStyle | TextStyle? | 文字样式 | 否 | null |
| activeTextStyle | TextStyle? | 选中文字样式 | 否 | null |

## 四、示例代码

### 基础用法

```dart
SantoSidebar(
  items: const ['推荐', '美食', '饮品', '甜点', '水果', '蔬菜'],
  selectedIndex: 0,
  onChanged: (index, label) {
    print('Selected: $label at index $index');
  },
)
```

### 自定义样式

```dart
SantoSidebar(
  items: const ['全部', '进行中', '已完成', '已取消'],
  width: 100,
  itemHeight: 48,
  activeColor: Colors.blue,
  indicatorWidth: 4,
  activeTextStyle: const TextStyle(fontWeight: FontWeight.bold),
  onChanged: (index, label) {},
)
```

### 配合右侧内容区

```dart
Row(
  children: [
    SantoSidebar(
      items: categories,
      selectedIndex: currentCategory,
      onChanged: (index, label) {
        setState(() => currentCategory = index);
      },
    ),
    Expanded(
      child: ListView.builder(
        itemCount: items[currentCategory].length,
        itemBuilder: (context, index) {
          return ListTile(title: Text(items[currentCategory][index]));
        },
      ),
    ),
  ],
)
```
