---
title: SantoDialog
group:
  title: 反馈
  order: 14
---

# SantoDialog

弹窗是库内**唯一的弹窗入口**:图标、标题、辅助文案、输入框、底部两个按钮、右上角关闭六项
全部通过参数配置,强提示、长文本、单选列表、多选列表、分享渠道五种业务形态由命名构造承接,
不再提供 `SantoDialogManager`、`SantoEnhanceOperationDialog`、`SantoScrollableTextDialog`、
`SantoMiddleInputDialog`、`SantoSingleSelectDialog`、`SantoMultiSelectDialog`、
`SantoShareDialog`、`SantoSafeDialog` 等独立组件。

对标 [antd Modal](https://ant-design.antgroup.com/components/modal-cn):一次性的确认弹窗用静态方法
`SantoDialog.confirm` / `info` / `success` / `warning` / `error`,复杂弹窗用构造函数配合 `showDialog`。

## 一、效果总览

- **六项配置**:`icon` / `iconType`(图标,info / warning / error / success)、`title`(标题)、`message`(辅助文案)、
  `showInput`(输入框)、`okText` + `cancelText`(两个按钮)、`closable`(右上角关闭)
- **其他形态参数**:`warningText` / `warningWidget`(警示文案)、`footer`(自定义底部)、
  `messageMaxHeight`(辅助文案最大高度)、`width`、`dismissOnActionTap`
- **命名构造**:`SantoDialog.alert`(原 `SantoEnhanceOperationDialog`)、
  `SantoDialog.richText`(原 `SantoScrollableTextDialog`)、`SantoDialog.singleSelect`(原 `SantoSingleSelectDialog`)、
  `SantoDialog.multiSelect`(原 `SantoMultiSelectDialog`)、`SantoDialog.share`(原 `SantoShareDialog`)
- **静态方法**:`confirm` / `info` / `success` / `warning` / `error` 语义预设,
  以及按 tag 精确关闭的 `show` / `dismiss`(原 `SantoSafeDialog`)

## 二、描述

### 使用规范

1. 弹窗只有 `SantoDialog` 一个入口,不要再按业务场景自建弹窗组件;业务形态先用参数与命名构造表达
2. 六个组成部分都可省略,底部按钮只传 `okText` 或只传 `cancelText` 时按单按钮展示(主色实心)
3. 两个按钮以上的底部布局由调用方用 `footer` 自行拼装(`Row` / `Column` + `SantoButton`)
4. 弹窗内部内边距与块间距统一取主题间距 token,不要写魔法数字:
   横向与块间距取 `hSpacingMd` / `vSpacingMd`(默认 15);
   顶部留白单独一档 —— 图标距顶部 `vSpacingXxl`(40),无图标时(标题或正文顶在最上)`vSpacingXl`(20)
5. 辅助文案过长时用 `messageMaxHeight` 限定文案区高度,超出后在文案区内滚动,避免弹窗撑满屏幕
6. 输入框内部渲染 `SantoInput`,`input*` 一组参数直接透传,不要在 `messageWidget` 里再塞输入框

### 交互约定

- 底部按钮与右上角关闭默认在点击后关闭弹窗,再执行回调;`dismissOnActionTap: false` 时只执行回调,
  由调用方自己决定何时关闭
- 输入框的值从 `inputController.text` 读取,`onOk` 不带参数
- 辅助文案区超出可用高度时(屏幕高度扣掉安全区、键盘与上下留白)弹窗整体可滚动

## 三、构造函数及参数说明

### 六项配置

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `icon` | `Widget?` | - | 自定义头部图标,优先于 `iconType`,尺寸固定 36 |
| `iconType` | `SantoDialogIconType` | `none` | 预设图标,统一取 `SantoIcon` 的 **solid 实心**图标:info(info-circle,品牌色) / warning(warning-triangle,警示色) / error(xmark-circle,失败色) / success(check-circle,成功色) |
| `title` | `String?` | - | 标题文案,最多 3 行,超出省略 |
| `titleWidget` | `Widget?` | - | 自定义标题,优先于 `title` |
| `titleMaxLines` | `int` | `3` | 标题最大行数 |
| `message` | `String?` | - | 辅助文案 |
| `messageWidget` | `Widget?` | - | 自定义辅助文案,优先于 `message`,富文本用 `SantoCSS2Text.toTextView` |
| `messageTextAlign` | `TextAlign?` | 主题 `contentTextAlign` | 辅助文案对齐方式 |
| `messageMaxHeight` | `double?` | - | 辅助文案区最大高度,超出后文案区内滚动 |
| `showInput` | `bool` | `false` | 是否展示输入框 |
| `inputHintText` | `String?` | - | 输入框占位文案 |
| `inputController` | `TextEditingController?` | - | 输入控制器,`onOk` 时读它的 `text` |
| `inputFocusNode` | `FocusNode?` | - | 焦点控制 |
| `inputMaxLength` | `int?` | - | 最多可输入字符数,不传不限制 |
| `inputMaxLines` / `inputMinLines` | `int` / `int?` | `1` / - | 输入框行数 |
| `inputType` | `TextInputType` | `text` | 键盘类型 |
| `inputAction` | `TextInputAction?` | - | 键盘动作按钮类型 |
| `inputFormatters` | `List<TextInputFormatter>?` | - | 输入内容格式控制,如 `FilteringTextInputFormatter.digitsOnly` |
| `inputAutoFocus` | `bool` | `false` | 是否自动聚焦弹出键盘 |
| `onInputChanged` | `ValueChanged<String>?` | - | 输入内容变化回调 |
| `okText` | `String?` | - | 主按钮文案,不传则没有主按钮 |
| `onOk` | `VoidCallback?` | - | 主按钮回调 |
| `cancelText` | `String?` | - | 辅助按钮文案,不传则没有辅助按钮 |
| `onCancel` | `VoidCallback?` | - | 辅助按钮回调 |
| `dismissOnActionTap` | `bool` | `true` | 点击按钮/关闭后是否自动关闭弹窗 |
| `closable` | `bool` | `false` | 是否展示右上角关闭图标 |
| `onClose` | `VoidCallback?` | - | 关闭图标回调 |

### 其他形态参数

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `warningText` | `String?` | - | 警示文案,展示在辅助文案下方 |
| `warningWidget` | `Widget?` | - | 自定义警示区域,优先于 `warningText` |
| `footer` | `Widget?` | - | 完全自定义底部区域,优先于 `okText` / `cancelText` |
| `width` | `double?` | 主题 `dialogWidth`(300) | 弹窗宽度 |
| `themeData` | `SantoDialogConfig?` | - | 组件级主题覆盖 |

> 弹窗的展示参数(`barrierDismissible`、`useSafeArea` 等)由调用方的 `showDialog` 传入;
> `SantoDialog.confirm` 等静态方法自带 `barrierDismissible`。

### 命名构造

| 构造 | 原组件 | 关键参数 |
| --- | --- | --- |
| `SantoDialog.alert` | `SantoEnhanceOperationDialog` | `iconType` / `title` / `message` / `mainButtonText` / `secondaryButtonText` / `onMainButton` / `onSecondaryButton`;主按钮整行实心,次要按钮为主色文字按钮 |
| `SantoDialog.richText` | `SantoScrollableTextDialog` | `title` / `contentText`(CSS2 富文本)/ `textColor` / `textFontSize` / `submitText` / `onSubmit` / `linksCallback` / `isShowOperateWidget`;内容超过 220 高可滚动 |
| `SantoDialog.singleSelect` | `SantoSingleSelectDialog` | `conditions`(`List<String>`)/ `checkedItem` / `submitText` / `onSubmit` / `onItemClick` / `customWidget` / `isCustomFollowScroll` |
| `SantoDialog.multiSelect` | `SantoMultiSelectDialog` | `conditions`(`List<MultiSelectItem>`)/ `submitText` / `onSubmit`(返回 false 不关闭)/ `onItemClick` / `customWidget` / `isShowOperateWidget` |
| `SantoDialog.share` | `SantoShareDialog` | `shareChannels`(取值见 `SantoShareItemConstants`)/ `title` / `message` / `separatorText` / `onChannelTap` / `getCustomChannelTitle` / `getCustomChannelWidget`;底部面板形态的分享请用 `SantoShare` |

### 静态方法

| 方法 | 说明 |
| --- | --- |
| `SantoDialog.confirm(context, ...)` | 双按钮确认弹窗,返回 `true`(确定)/ `false`(取消)/ `null`(点击蒙层关闭) |
| `SantoDialog.info / success / warning / error(context, ...)` | 单按钮语义弹窗,分别带提示 / 成功 / 警示 / 失败图标 |
| `SantoDialog.show(context, builder: ...)` | 按 `tag` 记录路由的弹窗,配合 `dismiss` 精确关闭,可替代 `showDialog` |
| `SantoDialog.dismiss(context, tag: ...)` | 关闭该 `tag` 下最后入栈的弹窗;同一 `tag` 可叠加多个,只关最后一个 |

```dart
// 一次性确认
final bool? result = await SantoDialog.confirm(
  context,
  title: '确定删除吗?',
  message: '删除后不可恢复',
  onOk: () => print('已删除'),
);

// 复杂弹窗
showDialog<void>(
  context: context,
  builder: (_) => SantoDialog(
    iconType: SantoDialogIconType.info,
    title: '拒绝理由',
    message: '请输入拒绝理由',
    showInput: true,
    inputHintText: '请输入',
    inputController: controller,
    closable: true,
    cancelText: '取消',
    okText: '确定',
    onOk: () => print(controller.text),
  ),
);

// 按 tag 关闭
SantoDialog.show(context: context, builder: (_) => const SantoLoading(), tag: 'loading');
SantoDialog.dismiss(context: context, tag: 'loading');
```

## 四、主题配置

`SantoDialogConfig` 提供弹窗的圆角、宽度、标题/内容/警示的样式与内边距:

| 配置项 | 说明 |
| --- | --- |
| `dialogWidth` | 弹窗宽度,默认 300(Pad 主题 420) |
| `radius` | 圆角,默认取 `commonConfig.radiusLg` |
| `titleTextStyle` / `titleTextAlign` / `titlePaddingSm` / `titlePaddingLg` | 标题样式与内边距 |
| `contentTextStyle` / `contentTextAlign` / `contentPaddingSm` / `contentPaddingLg` | 辅助文案样式与内边距 |
| `warningTextStyle` / `warningTextAlign` / `warningPaddingSm` / `warningPaddingLg` | 警示文案样式与内边距 |
| `dividerPadding` | 内容区与底部区域之间的留白 |
| `iconPadding` | 头部图标距离顶部的边距 |
| `backgroundColor` | 弹窗背景色 |

> `SantoDialogConfig` 的内边距默认值即规范档位:横向与块间距 15,`iconPadding` 的
> `top` 取 `vSpacingXxl`(40),`titlePaddingLg` / `contentPaddingLg` 的 `top` 取 `vSpacingXl`(20);
> 需要整体放宽或收紧时改这里的 `*Padding*` 字段。

```dart
SantoThemeConfigurator.instance.register(
  SantoAllThemeConfig(
    dialogConfig: SantoDialogConfig(radius: 12),
  ),
  configId: 'your-config-id',
);
```

## 版本变更

### v1.1.0

弹窗收拢为唯一入口 `SantoDialog`,**破坏性变更**。

- **新增**: `SantoDialog` 统一弹窗入口,六项配置(`icon` / `title` / `message` / `showInput` / `okText`+`cancelText` / `closable`)全部参数化
- **新增**: 命名构造 `SantoDialog.alert` / `richText` / `singleSelect` / `multiSelect` / `share`
- **新增**: 静态方法 `SantoDialog.confirm` / `info` / `success` / `warning` / `error`
- **新增**: `SantoDialog.show` / `SantoDialog.dismiss` 按 tag 精确关闭(原 `SantoSafeDialog`)
- **新增**: `messageMaxHeight` 限定辅助文案区高度,超出后文案区内滚动
- **新增**: 内部渲染 `SantoInput` 作为输入框(`SantoInput` 支持 `inputMaxLength` 等参数)
- **删除**: `SantoDialogManager.showSingleButtonDialog` / `showConfirmDialog` / `showMoreButtonDialog`
- **删除**: `SantoEnhanceOperationDialog`、`SantoDialogConstants`
- **删除**: `SantoContentExportWidget`、`SantoScrollableTextDialog`、`SantoScrollableText`
- **删除**: `SantoMiddleInputDialog`
- **删除**: `SantoSingleSelectDialog`、`SantoSingleSelectDialogWidget`
- **删除**: `SantoMultiSelectDialog`、`MultiSelect`(选项 `MultiSelectItem` 保留)
- **删除**: `SantoShareDialog`(分享渠道形态并入 `SantoDialog.share`,面板形态继续用 `SantoShare`)
- **删除**: `SantoSafeDialog`(能力并入 `SantoDialog.show` / `SantoDialog.dismiss`)
- **删除**: `SantoDialogUtils`
- **变更**: 辅助文案参数由 `messageText` 改为 `message`,警示文案由 `warningText` 保留、`warningWidget` 保留
- **变更**: 底部按钮由 `actionsText` + `indexedActionCallback` 改为 `okText` / `cancelText` / `onOk` / `onCancel`;
  两个按钮以上改用 `footer` 自行拼装
- **变更**: 头部图标由 `showIcon`(默认警示图)与 `iconImage` 改为 `iconType` + `icon`
- **变更**: 关闭按钮由 `isClose` / `onCloseClick` 改为 `closable` / `onClose`
- **变更**: 弹窗内部横向内边距统一为 `hSpacingMd`(标题原 40、内容原 20、底部 15)
- **变更**: 关闭弹窗与回调的顺序统一为「先关闭再回调」;`SantoMiddleInputDialog` 的 `onConfirm(value)`
  改为 `onOk` + `inputController.text`;`dismissOnActionsTap` 改为 `dismissOnActionTap`
- **迁移**: `SantoDialogManager.showConfirmDialog(context, cancel: '取消', confirm: '确定', ...)`
  → `SantoDialog.confirm(context, cancelText: '取消', okText: '确定', ...)`
- **迁移**: `SantoSingleSelectDialog(conditions: [...], onSubmit: ...)` 配合 `showDialog`
  → `SantoDialog.singleSelect(conditions: [...], onSubmit: ...)` 配合 `showDialog`

### v1.0.0

- 初始版本发布
