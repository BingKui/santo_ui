---
title: SantoSwipeCell
group:
  title: 数据展示
  order: 6
---

# SantoSwipeCell

滑动单元格:列表项左滑/右滑出操作面板。API 参考 TDesign Flutter 的 SwipeCell。

## 一、效果总览

支持左右操作面板、禁用滑动、默认展开、组内互斥展开、点击关闭。

## 二、描述

### 适用场景
1. 列表项的快捷操作(删除/置顶/编辑等)。
2. 同组列表项同时只允许一个展开的场景。

### 使用规范
- 操作面板宽度由 `extentRatio`(占单元格宽度比例)控制,建议 0.2 ~ 0.4。
- 操作按钮建议 2 ~ 3 个,超出时配合 `wrap` 换行场景慎用。

## 三、构造函数及参数说明

### SantoSwipeCell

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| cell | Widget | 单元格内容 | 是 | 无 |
| left | SantoSwipeCellPanel? | 左侧操作面板 | 否 | null |
| right | SantoSwipeCellPanel? | 右侧操作面板 | 否 | null |
| disabled | bool | 是否禁用滑动 | 否 | false |
| opened | List&lt;bool&gt; | 默认展开状态 [左, 右] | 否 | [false, false] |
| onChange | Function(SantoSwipeDirection, bool)? | 展开/收起回调 | 否 | null |
| groupTag | Object? | 组标签,同组互斥展开 | 否 | null |
| closeWhenTapped | bool | 点击内容时关闭全组 | 否 | true |
| duration | Duration | 动画时长 | 否 | 200ms |
| controller | SantoSwipeCellController? | 外部控制器(close) | 否 | null |

### SantoSwipeCellPanel

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| actions | List&lt;SantoSwipeCellAction&gt; | 操作按钮列表 | 是 | 无 |
| extentRatio | double | 操作区总宽占单元格比例 | 否 | 0.25 |

### SantoSwipeCellAction

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| label | String | 按钮文案 | 是 | 无 |
| onPressed | VoidCallback? | 点击回调 | 否 | null |
| backgroundColor | Color? | 背景色 | 否 | 灰色 |
| textColor | Color? | 文字颜色 | 否 | 白色 |
| child | Widget? | 自定义内容,设置后 label 失效 | 否 | null |
| width | double | 按钮宽度 | 否 | 72 |

## 四、示例代码

```dart
SantoSwipeCell(
  groupTag: 'demo',
  right: SantoSwipeCellPanel(
    extentRatio: 0.3,
    actions: [
      SantoSwipeCellAction(
        label: '删除',
        backgroundColor: Colors.red,
        onPressed: () {},
      ),
    ],
  ),
  cell: ListTile(title: Text('列表项')),
)
```
