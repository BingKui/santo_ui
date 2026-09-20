---
title: SantoDescriptions
group:
  title: 描述列表
  order: 1
---

# SantoDescriptions

描述列表成对展示 label 与内容,常用于详情页,对标 antd Descriptions。

## 一、效果总览

- 键值成对展示,支持单列与多列(`column`)
- 支持水平(标签在左)与纵向(标签在上)两种布局(`layout`)
- 标签列可固定宽度左对齐(`labelWidth`),也可紧随内容
- 可开启单元格边框(`bordered`),配合多列呈现网格线
- 尺寸分 small / medium / large 三档(`size`)
- 冒号可开关(`colon`)
- 每项可自定义标签(`labelWidget`)与内容(`child`),支持跨列(`span`)与占满剩余列(`filled`)

## 二、描述

### 适用场景

1. 详情页里成对展示字段名与字段值
2. 需要标签对齐、便于纵向对照的键值信息
3. 同一份数据在移动端单列、宽屏多列两种排布
4. 需要边框网格线的信息区块

### 使用规范

- 与 antd 的差异:`column` 默认 **1**(移动端单列,antd 默认 3);`size` 默认 **medium**(antd 默认 large)
- 移动端优先单列;字段较多且屏宽足够时再用 `column`
- 标签长短不一时传 `labelWidth` 让内容左边界对齐;标签都很短时可不传,让标签紧随内容
- 纵向布局适合窄屏或内容较长的场景
- 间距与字号由 `size` 档位统一控制,内容里不要再写死字号
- 行间距:无边框时单元格只留横向内边距,行与行之间固定用最小档 `gapXs`(5),上下不会叠加留白;开启 `bordered` 后改为整格内边距,便于画网格线
- 内容较长需要换行时直接把 `Text` 交给 `child`,由列表控制换行

## 三、构造函数及参数说明

### SantoDescriptions

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| items | List<SantoDescriptionsItem> | 列表项 | 是 | - |
| title | String? | 标题文案 | 否 | null |
| titleWidget | Widget? | 自定义标题,优先级高于 title | 否 | null |
| extra | Widget? | 标题右侧操作区 | 否 | null |
| column | int | 每行放几项(对标 antd column,默认 1) | 否 | 1 |
| layout | SantoDescriptionsLayout | 布局方向 horizontal(标签在左)/ vertical(标签在上) | 否 | horizontal |
| bordered | bool | 是否显示单元格边框 | 否 | false |
| size | SantoDescriptionsSize | 尺寸档位 small / medium / large | 否 | medium |
| colon | bool | 标签后是否显示冒号 | 否 | true |
| labelWidth | double? | horizontal 布局下的标签列宽;为 null 时标签紧随内容 | 否 | null |

### SantoDescriptionsItem

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| label | String? | 标签文案 | 否 | null |
| labelWidget | Widget? | 自定义标签,优先级高于 label | 否 | null |
| child | Widget? | 内容 | 否 | null |
| span | int | 占几列 | 否 | 1 |
| filled | bool | 是否占满当前行剩余列数 | 否 | false |

## 四、示例代码

### 基础用法

```dart
SantoDescriptions(
  items: const [
    SantoDescriptionsItem(label: '姓名', child: Text('张三')),
    SantoDescriptionsItem(label: '电话', child: Text('1810000000')),
    SantoDescriptionsItem(label: '住址', child: Text('浙江省杭州市西湖区文一西路 969 号')),
  ],
)
```

### 多列(column)

```dart
SantoDescriptions(
  column: 2,
  items: const [
    SantoDescriptionsItem(label: '姓名', child: Text('张三')),
    SantoDescriptionsItem(label: '电话', child: Text('1810000000')),
    SantoDescriptionsItem(label: '住址', child: Text('浙江省杭州市'), span: 2),
  ],
)
```

### 标签左对齐(labelWidth)

```dart
SantoDescriptions(
  labelWidth: 92,
  items: const [
    SantoDescriptionsItem(label: '姓名', child: Text('张三')),
    SantoDescriptionsItem(label: '住址', child: Text('浙江省杭州市西湖区文一西路 969 号,内容较长时自动换行')),
  ],
)
```

### 纵向布局(layout)

```dart
SantoDescriptions(
  layout: SantoDescriptionsLayout.vertical,
  items: const [
    SantoDescriptionsItem(label: '姓名', child: Text('张三')),
    SantoDescriptionsItem(label: '住址', child: Text('浙江省杭州市西湖区文一西路 969 号 5 号楼')),
  ],
)
```

### 带边框(bordered)

```dart
SantoDescriptions(
  column: 2,
  bordered: true,
  items: const [
    SantoDescriptionsItem(label: '姓名', child: Text('张三')),
    SantoDescriptionsItem(label: '电话', child: Text('1810000000')),
    SantoDescriptionsItem(label: '状态', child: Text('在职')),
    SantoDescriptionsItem(label: '工号', child: Text('A0001')),
  ],
)
```

### 尺寸(size)

```dart
SantoDescriptions(size: SantoDescriptionsSize.small, items: items)
SantoDescriptions(items: items) // medium(默认)
SantoDescriptions(size: SantoDescriptionsSize.large, items: items)
```

### 关闭冒号(colon)

```dart
SantoDescriptions(
  colon: false,
  items: const [
    SantoDescriptionsItem(label: '姓名', child: Text('张三')),
    SantoDescriptionsItem(label: '电话', child: Text('1810000000')),
  ],
)
```

### 跨列(span / filled)

```dart
SantoDescriptions(
  column: 2,
  items: const [
    SantoDescriptionsItem(label: '地址', child: Text('杭州市'), span: 2),
    SantoDescriptionsItem(label: '备注', child: Text('无'), filled: true),
  ],
)
```

### 自定义标签与内容

```dart
SantoDescriptions(
  items: [
    SantoDescriptionsItem(
      labelWidget: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('月租'),
          SantoSpace.gap(4),
          GestureDetector(
            onTap: () => SantoTooltip.show(context, '月租为含税价格', key),
            child: SantoIcon(SantoIcons.helpCircle, size: 14),
          ),
        ],
      ),
      child: const Text('¥ 3,800.00'),
    ),
    const SantoDescriptionsItem(
      label: '合同',
      child: Row(
        children: [
          Expanded(child: Text('查看合同详情')),
          SantoIcon(SantoIcons.navArrowRight, size: 16),
        ],
      ),
    ),
  ],
)
```

### 标题与操作

```dart
SantoDescriptions(
  title: '用户信息',
  extra: SantoIcon(SantoIcons.moreHoriz),
  items: const [
    SantoDescriptionsItem(label: '姓名', child: Text('张三')),
    SantoDescriptionsItem(label: '电话', child: Text('1810000000')),
  ],
)
```

## 五、版本变更

### v4.0.0

- **新增**: `SantoDescriptions` 描述列表组件,对标 antd Descriptions
- **新增**: `SantoDescriptionsItem` 列表项,支持 `span` 跨列与 `filled` 占满剩余列
- **新增**: `SantoDescriptionsLayout`(horizontal / vertical)、`SantoDescriptionsSize`(small / medium / large)枚举
- **新增**: `column` / `bordered` / `colon` / `labelWidth` 参数
- 与 antd 的差异:`column` 默认 1(antd 为 3),`size` 默认 medium(antd 为 large)
