---
title: SantoCheckbox
group:
  title: 选择
  order: 1
---

# SantoCheckbox

多选框:在一组选项中执行多项选择,支持分组统一管理勾选状态、全选与最大勾选数限制。

## 一、效果总览

- 三种勾选样式:圆形(circle,默认)、方形(square)、无背景对号(check)
- 两种尺寸:small 行高 48、large 行高 56
- 主标题 + 副标题,内容可置于指示器左侧或右侧
- 卡片模式:选中显示品牌色边框与实心 check-circle 图标(与边框同色,占卡片高度 40%)
- 普通模式默认显示底部分割线,可通过 `showDivider` 关闭
- 支持完全自定义指示器(`customIconBuilder`)与内容(`customContentBuilder`)

## 二、描述

### 适用场景
1. 表单中的多项选择(如兴趣标签、权限项)。
2. 需要"全选/半选"的批量操作场景(配合 `SantoCheckboxGroupController`)。

### 使用规范
- 嵌入 `SantoCheckboxGroup` / `SantoCheckboxGroupContainer` 时必须设置 `id`,否则不纳入分组管理。
- 分组内 `maxChecked` 限制超出时回调 `onOverloadChecked`,超出的项保持原状态。
- 卡片模式不显示指示器与分割线,选中态由品牌色边框与右侧同色实心 check-circle 图标表达;图标边长取卡片高度的 40%。
- 副标题左对齐标题:指示器在左侧时,副标题与主标题文字左边缘对齐。
- 半选态用 `customIconBuilder` 自行绘制(分组内根据已勾选数量计算)。

## 三、构造函数及参数说明

### SantoCheckbox

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| id | String? | 标识,嵌入分组时必填 | 否 | null |
| title | String? | 主标题 | 否 | null |
| subTitle | String? | 副标题 | 否 | null |
| titleStyle | TextStyle? | 主标题字体样式 | 否 | null |
| subTitleStyle | TextStyle? | 副标题字体样式 | 否 | null |
| enable | bool | 是否可用,false 时置灰不可点 | 否 | true |
| checked | bool | 选中状态,分组内表示初始状态 | 否 | false |
| titleMaxLine | int? | 主标题最大行数 | 否 | null |
| subTitleMaxLine | int | 副标题最大行数 | 否 | 1 |
| customIconBuilder | SantoCheckboxIconBuilder? | 自定义指示器 | 否 | null |
| customContentBuilder | SantoCheckboxContentBuilder? | 完全自定义内容 | 否 | null |
| insetSpacing | double? | 文字与组件边缘的距离 | 否 | null(16) |
| style | SantoCheckboxStyle? | 勾选样式 | 否 | null(圆形) |
| spacing | double? | 指示器与内容的距离 | 否 | null(8) |
| backgroundColor | Color? | 背景色 | 否 | null |
| selectColor | Color? | 选中颜色 | 否 | null(品牌色) |
| disableColor | Color? | 禁用选中颜色 | 否 | null |
| size | SantoCheckBoxSize | 尺寸 small/large | 否 | small |
| cardMode | bool | 卡片模式 | 否 | false |
| showDivider | bool | 是否显示底部分割线 | 否 | true |
| contentDirection | SantoContentDirection | 内容相对指示器的方位 | 否 | right |
| onChanged | SantoCheckboxValueChanged? | 勾选状态变化回调 | 否 | null |
| titleColor | Color? | 主标题颜色 | 否 | null |
| subTitleColor | Color? | 副标题颜色 | 否 | null |
| checkBoxLeftSpace | double? | 指示器额外左侧间距 | 否 | null(0) |
| customSpace | EdgeInsetsGeometry? | 自定义组件内边距,设置后不再施加默认行高 | 否 | null |

### SantoCheckboxGroup

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| child | Widget | 分组容器,内部放置若干 SantoCheckbox | 是 | 无 |
| onChangeGroup | SantoCheckboxGroupChange? | 勾选变化回调,返回已勾选 id 列表 | 否 | null |
| controller | SantoCheckboxGroupController? | 分组控制器 | 否 | null |
| checkedIds | List&lt;String&gt;? | 初始勾选的 id 列表 | 否 | null |
| maxChecked | int? | 最多可勾选数量 | 否 | null |
| onOverloadChecked | VoidCallback? | 超出最大勾选数时回调 | 否 | null |
| titleMaxLine | int? | 组内复选框标题最大行数 | 否 | null |
| customContentBuilder | SantoCheckboxContentBuilder? | 组内复选框自定义内容 | 否 | null |
| contentDirection | SantoContentDirection? | 组内复选框内容方位 | 否 | null |
| style | SantoCheckboxStyle? | 组内复选框勾选样式 | 否 | null |
| spacing | double? | 组内复选框指示器与内容距离 | 否 | null |
| customIconBuilder | SantoCheckboxIconBuilder? | 组内复选框自定义指示器 | 否 | null |

### SantoCheckboxGroupContainer

继承 `SantoCheckboxGroup`,额外支持横/纵排列与卡片模式。

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| child | Widget? | 自定义布局内容,与 direction 二选一 | 否 | null |
| direction | Axis? | 排列方向 horizontal/vertical | 否 | null |
| directionalCheckboxes | List&lt;SantoCheckbox&gt;? | direction 下的复选框列表 | 否 | null |
| selectIds | List&lt;String&gt;? | 初始勾选的 id 列表 | 否 | null |
| passThrough | bool? | 非通栏样式,裁切圆角并留出左右外边距 | 否 | false |
| cardMode | bool | 卡片模式 | 否 | false |
| rowCount | int? | 横向排列时每行个数 | 否 | null |
| maxSelected | int? | 最多可勾选数量 | 否 | null |
| onCheckBoxGroupChange | SantoCheckBoxGroupChange? | 勾选变化回调 | 否 | null |
| onOverloadChecked | VoidCallback? | 超出最大勾选数时回调 | 否 | null |
| controller | SantoCheckboxGroupController? | 分组控制器 | 否 | null |

### SantoCheckboxGroupController

| 方法 | 描述 |
| --- | --- |
| toggleAll(bool check) | 全选/全不选,忽略最大勾选数限制 |
| reverseAll() | 反选 |
| toggle(String id, bool check) | 设置某一项的勾选状态 |
| allChecked() | 已勾选的 id 列表 |
| checked(String id) | 某一项是否已勾选 |

## 四、示例代码

### 基础用法

```dart
SantoCheckboxGroup(
  checkedIds: const ['1'],
  onChangeGroup: (ids) {},
  child: const Column(children: [
    SantoCheckbox(id: '0', title: '选项一'),
    SantoCheckbox(id: '1', title: '选项二', subTitle: '描述信息'),
  ]),
)
```

### 横向排列

```dart
SantoCheckboxGroupContainer(
  direction: Axis.horizontal,
  selectIds: const ['0'],
  rowCount: 2,
  directionalCheckboxes: const [
    SantoCheckbox(id: '0', title: '选项一', showDivider: false),
    SantoCheckbox(id: '1', title: '选项二', showDivider: false),
  ],
)
```

### 全选(自定义半选图标)

```dart
final controller = SantoCheckboxGroupController();

SantoCheckboxGroupContainer(
  controller: controller,
  child: SizedBox(
    height: 56,
    child: SantoCheckbox(
      id: 'all',
      title: '全选',
      customIconBuilder: (context, checked) => Icon(
        checked ? Icons.check_circle : Icons.radio_button_unchecked,
        size: 24,
      ),
      onChanged: (checked) => controller.toggleAll(checked),
    ),
  ),
)
```

## 版本变更

### v1.2.0
- **变更**: 卡片模式(`cardMode`)选中态由左上角品牌色三角 + 白色对号改为右侧实心 `check-circle` 图标(与卡片描边同色,边长取卡片高度的 50%)
- **修复**: 卡片描述(`subTitle`)与主标题左对齐,此前多缩进了一份 `insetSpacing`
