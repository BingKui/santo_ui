---
title: SantoRadio
group:
  title: 选择
  order: 2
---

# SantoRadio

单选框:在一组选项中执行单项选择,组内互斥;默认严格模式下选中后不可取消,只能切换。

## 一、效果总览

- 四种勾选样式:圆形(circle,默认)、方形(square)、无背景对号(check)、镂空圆点(hollowCircle)
- 两种尺寸:small 行高 48、large 行高 56
- 主标题 + 副标题,内容可置于指示器左侧或右侧
- 卡片模式:选中显示品牌色边框与实心 check-circle 图标(与边框同色,占卡片高度 40%)
- 横向排列可显示下划线,支持自定义下划线
- 单向/横向换行排列由 `SantoRadioGroup` 统一配置

## 二、描述

### 适用场景
1. 表单中的单项选择(如性别、证件类型)。
2. 少量选项的行内切换(横向排列)。

### 使用规范
- 单选框通常配合 `SantoRadioGroup` 使用,由分组保证组内互斥;分组时需设置 `id`。
- `strictMode` 默认 true:已选中项再次点击不会取消勾选,只能切换到其他项。
- 分组可通过 `radioCheckStyle` 统一样式,覆盖单选框自身 `radioStyle`。
- 字段含义与 `SantoCheckbox` 一致,`titleMaxLine` 默认 1 行。

## 三、构造函数及参数说明

### SantoRadio

继承 `SantoCheckbox`,参数含义一致(无 `style`),额外支持:

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| radioStyle | SantoRadioStyle | 单选框样式 circle/square/check/hollowCircle | 否 | circle |
| titleMaxLine | int? | 主标题最大行数 | 否 | 1 |
| id | String? | 标识,嵌入分组时必填 | 否 | null |
| title | String? | 主标题 | 否 | null |
| subTitle | String? | 副标题 | 否 | null |
| enable | bool | 是否可用,false 时置灰不可点 | 否 | true |
| checked | bool | 选中状态,分组内表示初始状态 | 否 | false |
| cardMode | bool | 卡片模式 | 否 | false |
| showDivider | bool | 是否显示底部分割线 | 否 | true |
| contentDirection | SantoContentDirection | 内容相对指示器的方位 | 否 | right |
| selectColor | Color? | 选中颜色 | 否 | null(品牌色) |
| disableColor | Color? | 禁用选中颜色 | 否 | null |
| onChanged | SantoCheckboxValueChanged? | 选中状态变化回调 | 否 | null |

### SantoRadioGroup

继承 `SantoCheckboxGroup`,额外支持横/纵排列与严格模式。

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| child | Widget? | 自定义布局内容,与 direction 二选一 | 否 | null |
| direction | Axis? | 排列方向 horizontal/vertical | 否 | null |
| directionalRadios | List&lt;SantoRadio&gt;? | direction 下的单选框列表 | 否 | null |
| selectId | String? | 默认选中的 id | 否 | null |
| strictMode | bool | 严格模式:选中后不可取消,只能切换 | 否 | true |
| radioCheckStyle | SantoRadioStyle? | 统一勾选样式,覆盖组内单选框样式 | 否 | null |
| showDivider | bool | 横向排列时是否显示下划线 | 否 | false |
| divider | Widget? | 自定义下划线 | 否 | null |
| rowCount | int | 横向排列时每行个数 | 否 | 1 |
| passThrough | bool? | 非通栏样式,裁切圆角并留出左右外边距 | 否 | false |
| cardMode | bool | 卡片模式 | 否 | false |
| onRadioGroupChange | SantoRadioGroupChange? | 选中变化回调,返回选中的 id | 否 | null |
| controller | SantoCheckboxGroupController? | 分组控制器 | 否 | null |

## 四、示例代码

### 基础用法

```dart
SantoRadioGroup(
  selectId: '1',
  direction: Axis.horizontal,
  directionalRadios: const [
    SantoRadio(id: '0', title: '单选标题', showDivider: false),
    SantoRadio(id: '1', title: '单选标题', showDivider: false),
  ],
)
```

### 自定义布局 + 外部受控

```dart
SantoRadioGroup(
  selectId: _selectedId,
  onRadioGroupChange: (id) => setState(() => _selectedId = id),
  child: const Column(children: [
    SantoRadio(id: '0', title: '选项一'),
    SantoRadio(id: '1', title: '选项二'),
  ]),
)
```

### 卡片模式

```dart
SantoRadioGroup(
  selectId: '0',
  cardMode: true,
  direction: Axis.vertical,
  directionalRadios: const [
    SantoRadio(id: '0', title: '单选', subTitle: '描述信息', cardMode: true),
    SantoRadio(id: '1', title: '单选', subTitle: '描述信息', cardMode: true),
  ],
)
```

## 版本变更

### v1.2.0
- **变更**: 卡片模式(`cardMode`)选中态由左上角品牌色三角 + 白色对号改为右侧实心 `check-circle` 图标(与卡片描边同色,边长取卡片高度的 50%)
- **修复**: 卡片描述(`subTitle`)与主标题左对齐,此前多缩进了一份 `insetSpacing`
