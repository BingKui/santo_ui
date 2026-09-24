---
title: SantoTag
group:
  title: 标签
  order: 1
---

# SantoTag

标签组件用于标记和分类,是库内**唯一的标签入口**:单标签、标签组、可选择、可删除全部通过参数实现,参考 antd Tag。

## 一、效果总览

按数据形态分两种模式:

- **单标签**:`text` 传一个文案,与 `bordered` / `state` / 自定义配色组合出普通、描边、状态、多彩四种形态
- **标签组**:`tags` 传文案列表(或传 `controller`),排成一组标签,支持流式换行与横向滑动

按交互能力分两个开关(都不开就是纯展示标签):

- **可选择** `selectable`:点击切换选中态
- **可删除** `deletable`:标签右侧展示删除图标

默认外观取主题 `SantoTagConfig`:高度 32、字号 12、圆角 `tagRadius`、左右内边距 `hSpacingSm`;单标签在不开选择/删除时为主题色底反白文字的经典样式。

自适应内容宽度,`maxWidth` 限制最大宽度并省略。

## 二、描述

### 适用场景
1. 分类标记(如商品标签、内容分类)
2. 状态标识(如进行中、已完成、失败)
3. 筛选条件展示与点选(`selectable`)
4. 可移除的关键词(`deletable`)

### 使用规范
- 不要在外部包 alignment,让标签自适应内容宽度
- 状态选择应符合语义:running 进行中、succeed 成功、failed 失败、waiting 等待、invalidate 失效
- 标签文字不宜过长,建议简短明了;标签固定单行省略
- 多个独立标签之间保持适当间距(可用 `SantoSpace` 或 `Wrap` 的 spacing);成组的标签直接传 `tags`

### 与旧组件的关系
v1.5.0 起 `SantoSelectTag`、`SantoDeleteTag`、`SantoDeleteTagController` 删除,能力全部并入 `SantoTag`:

| 旧用法 | 新写法 |
| --- | --- |
| `SantoSelectTag(tags: [...], onChanged: ...)` | `SantoTag(tags: [...], selectable: true, onChanged: ...)` |
| `SantoDeleteTag(controller: c, onTagDelete: ...)` | `SantoTag(controller: c, deletable: true, onTagDelete: ...)` |
| `SantoDeleteTagController` | `SantoTagController`(方法不变) |
| `SantoDeleteTag(backgroundColor: ...)` | `SantoTag(tagBackgroundColor: ...)` |
| `SantoDeleteTag(horizontalSpacing: ...)` | `SantoTag(spacing: ...)` |
| `SantoDeleteTag(padding: ...)`、`SantoDeleteTag` 的白色外底 | 删除,由外部容器控制 |

## 三、构造函数及参数说明

### 单标签

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| text | String? | 标签文案,与 `tags` / `controller` 二选一 | 否 | null |
| state | SantoTagState? | 状态 waiting/invalidate/running/failed/succeed,按状态取预设配色 | 否 | null |
| backgroundColor | Color? | 背景色,优先级高于状态预设配色与模式默认配色 | 否 | null |
| textColor | Color? | 文字颜色,优先级同上 | 否 | null |
| bordered | bool | 是否为描边标签 | 否 | false |
| borderColor | Color? | 边框颜色,默认取状态色或主题品牌色 | 否 | null |
| borderWidth | double | 边框宽度 | 否 | 1 |
| borderRadius | BorderRadius? | 标签圆角 | 否 | 主题 tagRadius(12) |
| padding | EdgeInsetsGeometry? | 内边距 | 否 | 横 hSpacingSm(10)、纵 2 |
| height | double? | 标签高度,文字在高度内垂直居中 | 否 | 主题 tagHeight(32) |
| fontSize | double? | 文字大小 | 否 | 主题 tagTextStyle 字号(12) |
| fontWeight | FontWeight | 文字粗细 | 否 | normal |
| maxWidth | double? | 最大宽度,超出省略 | 否 | null |
| initSelected | bool | 初始选中态,`selectable` 为 true 时生效 | 否 | false |
| onSelectedChange | ValueChanged\<bool\>? | 选中态变化回调 | 否 | null |
| onDelete | VoidCallback? | 删除回调,`deletable` 为 true 时生效 | 否 | null |

### 交互开关(单标签 / 标签组共用)

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| selectable | bool | 是否可选择,开启后点击切换选中态 | 否 | false |
| deletable | bool | 是否可删除,开启后右侧展示删除图标 | 否 | false |

### 标签组

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| tags | List\<String\>? | 标签文案列表,与 `text` 二选一 | 否 | null |
| controller | SantoTagController? | 标签控制器,外部主动增删标签 | 否 | null |
| isSingleSelect | bool | 是否单选 | 否 | true |
| initTagState | List\<bool\>? | 初始选中状态,与 `tags` 按下标对应 | 否 | null |
| onChanged | ValueChanged\<List\<int\>\>? | 选中变化回调,返回选中下标集合 | 否 | null |
| onTagDelete | Function(List\<String\>, String?, int)? | 删除回调,参数为剩余标签、被删标签内容、被删下标 | 否 | null |
| deleteIconSize | Size? | 删除图标大小,只取 width | 否 | 主题 iconSizeMd(16) |
| deleteIconColor | Color? | 删除图标颜色 | 否 | 标签文字颜色 |
| shape | OutlinedBorder? | 标签形状,只认 `RoundedRectangleBorder` 的圆角 | 否 | null |
| spacing | double | 水平间距 | 否 | 12 |
| verticalSpacing | double? | 纵向间距 | 否 | 10 |
| softWrap | bool | 是否流式换行,false 时横向滑动 | 否 | true |
| fixWidthMode | bool | 是否固定宽度,false 时按内容自适应;可删除时固定宽度不生效(删除图标会挤掉文案),需定宽请显式传 `tagWidth` | 否 | true |
| tagWidth | double? | 标签宽度,`fixWidthMode` 为 true 时生效;可删除时只有显式传入才生效 | 否 | 主题 tagWidth(75) |
| tagHeight | double? | 标签高度 | 否 | 主题 tagHeight(32) |
| tagTextStyle | TextStyle? | 标签文字样式 | 否 | 主题 tagTextStyle |
| selectedTagTextStyle | TextStyle? | 选中标签文字样式 | 否 | 主题 selectTagTextStyle |
| tagBackgroundColor | Color? | 标签背景色 | 否 | 主题 tagBackgroundColor |
| selectedTagBackgroundColor | Color? | 选中标签背景色,展示时取 12% 透明度 | 否 | 主题 selectedTagBackgroundColor |
| alignment | Alignment | 整组的对齐方式 | 否 | Alignment.centerLeft |
| themeData | SantoTagConfig? | 标签主题配置,覆盖主题里的配置 | 否 | null |

### SantoTagController

| 方法 | 描述 |
| --- | --- |
| `SantoTagController({initTags})` | 用初始标签集合构造 |
| `tags` | 当前标签集合(只读),变化后组件自动重建 |
| `setTags(List<String>)` | 重置全量标签 |
| `addTag(String)` / `addTags(List<String>)` | 追加标签 |
| `deleteForIndex(int)` | 删除指定下标,返回被删内容 |
| `deleteForTag(String)` | 删除指定内容,返回是否成功 |
| `clear()` | 清空标签 |

选中状态由组件内部掌管:用 `initTagState` 指定初始选中、`onChanged` 接收下标回调。

## 四、示例代码

```dart
// 单标签
SantoTag(text: '标签')
SantoTag(text: '已盘点', bordered: true)
SantoTag(text: '失败态', state: SantoTagState.failed)
SantoTag(text: '红色标签', backgroundColor: Color(0xFFFF4D4F))
SantoTag(text: '限制最大宽度', maxWidth: 90)

// 可选中 / 可删除的单标签
SantoTag(text: '可选中', selectable: true, onSelectedChange: (v) {})
SantoTag(text: '可删除', deletable: true, onDelete: () {})

// 标签组:单选 / 多选
SantoTag(
  tags: ['标签', '标签1', '标签2'],
  selectable: true,
  initTagState: [true],
  onChanged: (indexes) {},
)
SantoTag(
  tags: ['标签', '标签1', '标签2'],
  selectable: true,
  isSingleSelect: false,
)

// 标签组:可删除 + 控制器动态增删
final controller = SantoTagController(initTags: ['标签', '标签1']);
SantoTag(
  controller: controller,
  deletable: true,
  onTagDelete: (tags, tag, index) {},
);
controller.addTag('新增标签');
controller.deleteForIndex(0);

// 标签组:流式 / 横向滑动
SantoTag(tags: ['标签', '很长的标签文案'], selectable: true, fixWidthMode: false)
SantoTag(tags: ['标签', '标签1'], selectable: true, softWrap: false)
```

## 版本变更

### v1.5.0
- **变更(破坏性)**: 收敛 `SantoSelectTag`、`SantoDeleteTag`——删除两个组件与 `SantoDeleteTagController`,能力并入 `SantoTag`:新增 `tags` 标签组、`selectable` / `deletable` 开关、`initSelected` / `onSelectedChange`、`onDelete` 单标签回调,以及 `SantoTagController`
- **变更**: `SantoTag` 由 StatelessWidget 改为 StatefulWidget(仅供内部状态使用,API 不变)
- **变更**: `text` 由必填改为可空;单标签新增 `bordered` 之外的标签组形态,参数按模式生效
- **变更**: 默认值改为取主题 `SantoTagConfig` 与 `commonConfig`:`height` 默认 32、`fontSize` 默认 12、`borderRadius` 默认 `tagRadius`、左右内边距默认 `hSpacingSm`(10)
- **变更**: `SantoDeleteTag.backgroundColor` 映射为 `tagBackgroundColor`;`SantoDeleteTag.horizontalSpacing` 映射为 `spacing`;`SantoDeleteTag` 的外层白底与 `padding` 参数删除
- **变更**: 可删除的标签组固定宽度不生效(删除图标会把文案挤成省略号),按内容自适应;需要定宽请显式传 `tagWidth`
- **变更**: `SantoTagConfig.tagHeight` 默认值 34 → 32

### v1.1.0
- **变更(破坏性)**: `SantoTagCustom`、`SantoStateTag` 收敛为唯一入口 `SantoTag`,不同形态(普通/描边/状态/多彩)全部通过参数实现
- **删除**: `SantoTagCustom`(含 `buildBorderTag` 命名构造)、`SantoStateTag`
- **变更**: `TagState` 枚举更名为 `SantoTagState`,成员不变(waiting/invalidate/running/failed/succeed)
