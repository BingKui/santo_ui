---
title: SantoTable
group:
  title: 表格
  order: 1
---

# SantoTable

数据表格组件,API 参考 Ant Design Table,支持自定义渲染、横向/纵向合并、单选/多选、排序、展开折叠、分页、固定高度滚动、固定列和边框控制。

## 一、能力概览

- 默认使用浅灰表头和深色文字,也可通过 `headerColor` / `headerTextColor` 覆盖
- `cellBuilder` / `headerBuilder` 支持任意 Widget
- `spanBuilder` 支持 `rowSpan` 和 `colSpan`
- `selection` 支持单选、多选、全选、禁选和受控状态
- `sorter` 支持本地升序、降序和取消排序
- `expandable` 支持展开/折叠自定义行内容
- `pagination` 支持分页及切换每页条数
- `height` 支持固定表头和内容区纵向滚动
- `border` 控制外框及单元格分割线
- 列宽超出容器时自动横向滚动,`fixed` 可固定左右列

## 二、使用规范

- `columns` 定义列,`data` 使用二维数组;缺失的单元格按空字符串展示。
- 启用选择或展开时建议提供稳定的 `rowKey`;未提供时使用原始数据下标。
- `spanBuilder` 的 `rowIndex` 基于排序、分页后的当前页数据;超出当前页或列范围的合并会自动裁剪。
- 合并单元格时,起始单元格返回大于 1 的跨度即可,被覆盖单元格会自动隐藏;返回 0 可主动隐藏当前单元格。
- `height` 只限制内容区高度,表头和分页区不计入该高度。
- 列宽和超出容器宽度,或任一列配置 `fixed` 时,表格进入横向滚动模式;未定宽列按 120 展示。
- 合并单元格与固定列都可独立使用;当前合并布局不启用固定列吸附,请勿让 `spanBuilder` 与 `fixed` 同时配置。

## 三、API 参考

### SantoTable

| 参数名 | 参数类型 | 描述 | 必填 | 默认值 |
| --- | --- | --- | --- | --- |
| columns | List\<SantoTableColumn\> | 列配置 | 是 | - |
| data | List\<List\<dynamic\>\> | 二维数组数据源 | 是 | - |
| border | bool | 是否展示外框和单元格分割线 | 否 | true |
| borderColor | Color? | 边框颜色 | 否 | 主题分割线色 |
| borderWidth | double | 边框宽度 | 否 | 0.5 |
| headerColor | Color? | 表头背景色 | 否 | `commonConfig.fillBody` |
| headerTextColor | Color? | 表头文字颜色 | 否 | `commonConfig.colorTextBase` |
| headerTextStyle | TextStyle? | 表头文字样式 | 否 | null |
| cellTextStyle | TextStyle? | 单元格文字样式 | 否 | null |
| cellTextColor | Color? | 单元格文字颜色 | 否 | 主题主文字色 |
| rowHeight | double | 数据行高度 | 否 | 48 |
| headerHeight | double | 表头高度 | 否 | 48 |
| cellPadding | EdgeInsets? | 单元格内边距 | 否 | 水平 `hSpacingMd` |
| oddRowColor | Color? | 奇数行背景色 | 否 | 白色 |
| evenRowColor | Color? | 偶数行背景色 | 否 | `commonConfig.fillBody` |
| striped | bool | 是否展示斑马纹 | 否 | false |
| height | double? | 内容区固定高度,超出后滚动 | 否 | null |
| tableWidth | double? | 表格总宽度 | 否 | 自适应父容器 |
| empty | Widget? | 空数据占位 | 否 | “暂无数据” |
| rowKey | SantoTableRowKeyBuilder? | 生成稳定行标识 | 否 | 原始数据下标 |
| selection | SantoTableSelection? | 行选择配置 | 否 | null |
| expandable | SantoTableExpandable? | 展开行配置 | 否 | null |
| pagination | SantoTablePagination? | 分页配置 | 否 | null |
| onSortChanged | ValueChanged\<SantoTableSortState\>? | 排序变化回调 | 否 | null |

### SantoTableColumn

| 参数名 | 参数类型 | 描述 | 必填 | 默认值 |
| --- | --- | --- | --- | --- |
| title | String | 列标题 | 是 | - |
| width | double? | 列宽 | 否 | null(均分) |
| align | SantoTableAlign | 对齐方式 | 否 | center |
| fixed | SantoTableColumnFixed? | 固定到左侧或右侧 | 否 | null |
| cellBuilder | Widget Function(dynamic, int, int)? | 自定义单元格 Widget | 否 | null |
| headerBuilder | Widget Function(String)? | 自定义表头 Widget | 否 | null |
| sorter | Comparator\<dynamic\>? | 单元格值比较器 | 否 | null |
| defaultSortOrder | SantoTableSortOrder? | 初始排序方向 | 否 | null |
| spanBuilder | SantoTableCellSpan Function(dynamic, int, int)? | 单元格合并范围 | 否 | null |

### SantoTableSelection

| 参数名 | 参数类型 | 描述 | 默认值 |
| --- | --- | --- | --- |
| mode | SantoTableSelectionMode | `multiple` / `single` | multiple |
| selectedRowKeys | Set\<Object\>? | 受控选中项 | null |
| defaultSelectedRowKeys | Set\<Object\> | 非受控初始选中项 | 空集合 |
| rowSelectable | SantoTableRowSelectable? | 行是否可选 | null |
| onChanged | SantoTableSelectionChanged? | 返回选中 key 与数据行 | null |
| showSelectAll | bool | 多选时展示全选 | true |
| columnWidth | double | 选择列宽度 | 48 |

### SantoTableExpandable

| 参数名 | 参数类型 | 描述 | 默认值 |
| --- | --- | --- | --- |
| builder | SantoTableExpandedBuilder | 展开内容构建器 | 必填 |
| expandedRowKeys | Set\<Object\>? | 受控展开项 | null |
| defaultExpandedRowKeys | Set\<Object\> | 非受控初始展开项 | 空集合 |
| rowExpandable | SantoTableRowSelectable? | 行是否允许展开 | null |
| onChanged | ValueChanged\<Set\<Object\>\>? | 展开项变化 | null |
| expandedHeight | double | 展开区域高度 | 96 |

### SantoTablePagination

| 参数名 | 参数类型 | 描述 | 默认值 |
| --- | --- | --- | --- |
| currentPage | int | 初始/外部同步页码 | 1 |
| pageSize | int | 每页条数 | 10 |
| pageSizeOptions | List\<int\> | 每页条数选项 | [10, 20, 50] |
| showPageSizeSelector | bool | 是否展示每页条数选择 | true |
| onPageChanged | ValueChanged\<int\>? | 页码变化 | null |
| onPageSizeChanged | ValueChanged\<int\>? | 每页条数变化 | null |

## 四、示例

### 自定义单元格与排序

```dart
SantoTable(
  columns: [
    const SantoTableColumn(title: '商品'),
    SantoTableColumn(
      title: '价格',
      sorter: (left, right) => (left as num).compareTo(right as num),
      cellBuilder: (value, rowIndex, colIndex) => Text('¥$value'),
    ),
  ],
  data: const [
    ['手机', 6999],
    ['电脑', 12999],
  ],
)
```

### 横向与纵向合并

```dart
SantoTable(
  columns: [
    SantoTableColumn(
      title: '部门',
      spanBuilder: (value, row, col) => row == 0
          ? const SantoTableCellSpan(rowSpan: 2)
          : const SantoTableCellSpan(),
    ),
    SantoTableColumn(
      title: '项目',
      spanBuilder: (value, row, col) => row == 2
          ? const SantoTableCellSpan(colSpan: 2)
          : const SantoTableCellSpan(),
    ),
    const SantoTableColumn(title: '金额'),
  ],
  data: const [
    ['研发部', '客户端', '32万'],
    ['研发部', '服务端', '28万'],
    ['市场部', '全年汇总', '46万'],
  ],
)
```

### 选择、展开与分页

```dart
SantoTable(
  rowKey: (row, sourceIndex) => row.first,
  selection: SantoTableSelection(
    mode: SantoTableSelectionMode.multiple,
    onChanged: (keys, rows) {},
  ),
  expandable: SantoTableExpandable(
    builder: (context, row, rowIndex) => Text('详情: ${row.first}'),
  ),
  pagination: const SantoTablePagination(
    pageSize: 10,
    pageSizeOptions: [10, 20, 50],
  ),
  height: 300,
  columns: const [
    SantoTableColumn(title: '名称'),
    SantoTableColumn(title: '状态'),
  ],
  data: rows,
)
```

## 版本变更

### v1.4.0

- **新增**: `SantoTableColumn.sorter` / `defaultSortOrder`,支持升序、降序和取消排序
- **新增**: `SantoTableColumn.spanBuilder` 与 `SantoTableCellSpan`,支持横向/纵向合并
- **新增**: `selection`,支持单选、多选、全选、禁选和受控状态
- **新增**: `expandable`,支持展开/折叠自定义行内容
- **新增**: `pagination`,支持分页及每页条数切换
- **新增**: `rowKey` 和 `onSortChanged`
- **变更**: 默认表头背景由品牌色改为 `commonConfig.fillBody`,文字由反色改为主文字色
- **变更**: 默认单元格水平内边距统一使用 `commonConfig.hSpacingMd`

### v1.1.0

- **新增**: `height` 内容区高度,数据超出时纵向滚动且表头固定
- **新增**: 横向滚动,列宽和超出容器宽度时自动开启
- **新增**: `SantoTableColumn.fixed` 固定列(left / right)
- **删除**: `pinnedHeader` 参数,由 `height` 取代
- **变更**: 全部列定宽且列宽和超出容器时改为横向滚动
