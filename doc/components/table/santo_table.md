---
title: SantoTable
group:
  title: 表格
  order: 1
---

# SantoTable

数据表格组件,支持自定义列配置、表头固定、单元格自定义内容、边框、斑马纹、空数据占位。

## 一、效果总览

- 支持自定义列配置
- 表头可固定(吸顶)
- 支持边框和斑马纹样式
- 单元格支持自定义内容
- 空数据自动显示占位提示

## 二、描述

### 适用场景
1. 数据列表展示(如订单列表、用户列表)
2. 统计报表展示
3. 对比数据表格
4. 需要行列对齐的数据展示

### 使用规范
- columns 定义列的数量和属性,data 为二维数组
- data 中每个子数组的长度应与 columns 长度一致
- cellBuilder 可自定义单元格的渲染逻辑
- pinnedHeader 为 true 时表头会固定在顶部
- striped 为 true 时奇偶行显示不同背景色

## 三、构造函数及参数说明

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| columns | List\<SantoTableColumn\> | 列配置列表 | 是 | - |
| data | List\<List\<dynamic\>\> | 表格数据 | 是 | - |
| border | bool | 是否显示边框 | 否 | true |
| borderColor | Color? | 边框颜色 | 否 | null(分割线颜色) |
| borderWidth | double | 边框宽度 | 否 | 0.5 |
| headerColor | Color? | 表头背景色 | 否 | null(brandPrimary) |
| headerTextColor | Color? | 表头文字颜色 | 否 | null(白色) |
| headerTextStyle | TextStyle? | 表头文字样式 | 否 | null |
| cellTextStyle | TextStyle? | 单元格文字样式 | 否 | null |
| cellTextColor | Color? | 单元格文字颜色 | 否 | null |
| rowHeight | double | 行高 | 否 | 48 |
| headerHeight | double | 表头高度 | 否 | 48 |
| cellPadding | EdgeInsets? | 单元格内边距 | 否 | null |
| oddRowColor | Color? | 奇数行背景色 | 否 | null(白色) |
| evenRowColor | Color? | 偶数行背景色 | 否 | null(#F5F5F5) |
| striped | bool | 是否显示斑马纹 | 否 | false |
| pinnedHeader | bool | 是否固定表头 | 否 | false |
| tableWidth | double? | 表格总宽度 | 否 | null(自适应) |
| empty | Widget? | 数据为空时的占位内容 | 否 | null("暂无数据") |

### SantoTableColumn

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| title | String | 列标题 | 是 | - |
| width | double? | 列宽度 | 否 | null(均分) |
| align | SantoTableAlign | 对齐方式(left/center/right) | 否 | center |
| cellBuilder | Widget Function(dynamic)? | 自定义单元格内容 | 否 | null |
| headerBuilder | Widget Function()? | 自定义表头内容 | 否 | null |

## 四、示例代码

### 基础用法

```dart
SantoTable(
  columns: const [
    SantoTableColumn(title: '姓名', width: 100),
    SantoTableColumn(title: '年龄', width: 80),
    SantoTableColumn(title: '城市', width: 120),
  ],
  data: [
    ['张三', 25, '北京'],
    ['李四', 30, '上海'],
    ['王五', 28, '广州'],
  ],
)
```

### 自定义单元格内容

```dart
SantoTable(
  columns: [
    const SantoTableColumn(title: '商品', width: 150),
    const SantoTableColumn(title: '价格', width: 100, align: SantoTableAlign.right),
    SantoTableColumn(
      title: '操作',
      width: 120,
      cellBuilder: (value) => TextButton(
        onPressed: () {},
        child: const Text('删除'),
      ),
    ),
  ],
  data: [
    ['iPhone 15', '¥7999'],
    ['MacBook Pro', '¥12999'],
  ],
)
```

### 斑马纹样式

```dart
SantoTable(
  columns: const [...],
  data: [...],
  striped: true,
  oddRowColor: Colors.white,
  evenRowColor: const Color(0xFFF5F5F5),
)
```

### 固定表头

```dart
SantoTable(
  columns: const [...],
  data: largeData, // 大量数据
  pinnedHeader: true,
  rowHeight: 44,
)
```

### 自定义空数据提示

```dart
SantoTable(
  columns: const [...],
  data: [],
  empty: Column(
    children: [
      Icon(Icons.inbox, size: 48, color: Colors.grey),
      const SizedBox(height: 8),
      const Text('暂无数据', style: TextStyle(color: Colors.grey)),
    ],
  ),
)
```
