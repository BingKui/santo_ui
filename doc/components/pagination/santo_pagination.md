---
title: SantoPagination
group:
  title: 分页
  order: 1
---

# SantoPagination

把大量数据分页展示。多页模式展示页码并支持省略号,简单模式展示"当前页/总页数"。受控组件。

## 一、效果总览

- 支持多页模式(multi)和简单模式(simple)
- 多页模式展示页码按钮,支持省略号
- 简单模式展示"当前页/总页数"
- 支持自定义上一页/下一页文案
- 可控制是否显示上下页按钮

## 二、描述

### 适用场景
1. 长列表数据分页展示
2. 表格数据分页
3. 搜索结果分页
4. 移动端简单分页提示

### 使用规范
- current 从 1 开始,不是从 0 开始
- totalItems 和 itemsPerPage 会自动计算 pageCount,也可直接设置 pageCount
- showPageSize 控制同时展示的页码数量,建议奇数(如 5 或 7)
- forceEllipses 为 true 时始终显示省略号,即使不需要
- onChanged 回调返回新的页码,需要在外部更新 current 实现受控

## 三、构造函数及参数说明

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| mode | SantoPaginationMode | 分页模式(multi/simple) | 否 | multi |
| current | int | 当前页码,从 1 开始 | 否 | 1 |
| onChanged | ValueChanged\<int\>? | 页码变化回调 | 否 | null |
| totalItems | int | 总条数 | 否 | 0 |
| itemsPerPage | int | 每页条数 | 否 | 10 |
| pageCount | int | 总页数(优先于 totalItems) | 否 | 0 |
| showPageSize | int | 多页模式下同时展示的页码数量 | 否 | 5 |
| forceEllipses | bool | 是否展示省略号 | 否 | false |
| showPrevButton | bool | 是否展示上一页按钮 | 否 | true |
| showNextButton | bool | 是否展示下一页按钮 | 否 | true |
| prevText | String? | 上一页文案 | 否 | null('上一页') |
| nextText | String? | 下一页文案 | 否 | null('下一页') |

## 四、示例代码

### 多页模式基础用法

```dart
SantoPagination(
  current: currentPage,
  totalItems: 100,
  itemsPerPage: 10,
  onChanged: (page) {
    setState(() => currentPage = page);
  },
)
```

### 简单模式

```dart
SantoPagination(
  mode: SantoPaginationMode.simple,
  current: 3,
  pageCount: 10,
)
// 显示: 3/10
```

### 自定义页码数量

```dart
SantoPagination(
  current: 5,
  pageCount: 20,
  showPageSize: 7, // 同时显示 7 个页码
  onChanged: (page) {},
)
```

### 自定义文案

```dart
SantoPagination(
  current: 2,
  pageCount: 10,
  prevText: '<',
  nextText: '>',
  showPrevButton: true,
  showNextButton: true,
  onChanged: (page) {},
)
```

### 隐藏上下页按钮

```dart
SantoPagination(
  current: 3,
  pageCount: 8,
  showPrevButton: false,
  showNextButton: false,
  onChanged: (page) {},
)
```
