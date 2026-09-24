---
title: SantoInput
group:
  title: 输入框
  order: 1
---

# SantoInput

输入框是基于 Flutter `TextField` 编辑内核的文本输入组件，是库内文本输入的**统一入口**：
单行文本、搜索框、多行文本域三种模式通过 `type` 一个参数切换，密码框用
`showPasswordToggle` + `obscureText` 表达，不再提供独立的 `SantoInputText`、`SantoTextArea`、
`SantoSearchBar` 等组件。

API 对标 [TDesign TInput](https://tdesign.tencent.com/flutter/components/input) 与
[antd Input](https://ant-design.antgroup.com/components/input-cn)（`Input` / `Input.Search` /
`Input.TextArea` 三种形态合一）。

## 一、描述

### 使用规范

1. 文本输入统一使用 `SantoInput`，不要再按场景自建输入组件；形态差异先用 `type` 表达
2. `controller` 是主控制路径；未传时由组件创建内部 controller，并用 `initialValue` 初始化一次。
   **两者不能同时传入**
3. 单行输入框内容区高度定稿 32，左右插槽（prefix / suffix 等）在此高度内居中，不会把输入框撑高
4. 边框宽度定稿 1，不随主题 `borderWidthMd` 档位变化；聚焦时边框与计数器取状态色
5. `maxLength`（grapheme 计数）与 `maxCharacter`（ASCII 计 1、非 ASCII 计 2）**二选一**，
   不能同时传入

### 三种模式（`type`）

| 模式 | 说明 |
| --- | --- |
| `SantoInputMode.text` | 单行文本输入（默认），对应 antd `Input` |
| `SantoInputMode.search` | 搜索框：未传自定义 `prefix` 时自带前置搜索图标，可用 `prefix` 覆盖，对应 antd `Input.Search` |
| `SantoInputMode.textarea` | 多行文本域：默认最小 4 行（`minLines`），高度随内容增长，对应 antd `Input.TextArea` |

## 二、代码示例

### 基础用法

```dart
SantoInput(
  controller: controller,
  hintText: '请输入',
  onChanged: (value) => print(value),
);
```

### 搜索框 / 多行文本域

```dart
// 搜索框：自带前置搜索图标
SantoInput(
  type: SantoInputMode.search,
  hintText: '搜索',
  onSubmitted: (value) => doSearch(value),
);

// 多行文本域：默认 minLines 4，高度随内容增长
SantoInput(
  type: SantoInputMode.textarea,
  hintText: '请输入备注',
);
```

### 密码框

```dart
SantoInput(
  hintText: '请输入密码',
  obscureText: true,
  showPasswordToggle: true, // 后置插槽内置显隐按钮
);
```

### label 与必填标识

```dart
SantoInput(
  label: '手机号',
  required: true,       // label 前显示红色星号
  labelWidth: 80,       // 为空时按内容自适应
  inputFormat: SantoInputFormat.phone,
);
```

### 前后缀插槽

```dart
// 右侧单位文案
SantoInput(
  hintText: '请输入金额',
  suffixText: '元',
);

// 右侧按钮（suffix / suffixIcon / suffixButton 用法一致）
SantoInput(
  hintText: '请输入验证码',
  suffixButton: SantoButton(
    size: SantoButtonSize.small,
    child: const Text('获取验证码'),
    onTap: sendCode,
  ),
);

// 自定义后缀组件；注意传入 suffix 后不显示内置清除按钮
SantoInput(
  hintText: '请输入',
  suffix: const Icon(Icons.info_outline),
);
```

### 限制输入类型

```dart
// 纯数字（digit / number / idCard / phone / email）
SantoInput(
  inputFormat: SantoInputFormat.digit,
  hintText: '请输入数量',
);

// inputFormat 为 text 时由 inputType 决定键盘类型
SantoInput(
  inputType: TextInputType.url,
);
```

### 清除按钮

```dart
SantoInput(
  hintText: '请输入',
  clearButtonMode: SantoInputClearButtonMode.focused, // 有文本且聚焦时显示
);
```

### 校验状态

```dart
SantoInput(
  hintText: '请输入手机号',
  status: SantoInputStatus.error, // 状态色作用于输入壳层、边框与计数器
);
```

### 字数限制与计数器

```dart
// grapheme 计数，与 maxCharacter 二选一
SantoInput(
  maxLength: 20,
  indicator: true, // 未配置长度限制时不会显示计数
);

// 按字符权重计数：ASCII 计 1，非 ASCII 计 2
SantoInput(
  maxCharacter: 20,
  indicator: true,
);
```

### 无边框

```dart
SantoInput(
  hintText: '请输入',
  borderless: true, // 常用于嵌入表单行、搜索栏等已有容器的场景
);
```

## 三、API 参考

### SantoInput

| 参数 | 类型 | 说明 | 必填 | 默认值 |
| --- | --- | --- | --- | --- |
| `type` | `SantoInputMode` | 输入框模式 | 否 | `SantoInputMode.text` |
| `controller` | `TextEditingController?` | 文本控制器，主控制路径；与 `initialValue` 互斥 | 否 | - |
| `initialValue` | `String?` | 内部控制器的初始文本，仅初始化一次；与 `controller` 互斥 | 否 | - |
| `onChanged` | `ValueChanged<String>?` | 文本变化通知 | 否 | - |
| `onSubmitted` | `ValueChanged<String>?` | 提交回调 | 否 | - |
| `onEditingComplete` | `VoidCallback?` | 编辑完成回调 | 否 | - |
| `enabled` | `bool` | 是否可交互；为 false 时禁止编辑、聚焦和选择，并使用禁用态文字颜色 | 否 | `true` |
| `readOnly` | `bool` | 是否只读；禁止修改内容，但保留只读文本的选择和复制能力 | 否 | `false` |
| `hintText` | `String?` | 占位提示文案 | 否 | - |
| `label` | `String?` | 输入框左侧标签文案 | 否 | - |
| `required` | `bool` | 是否必填，为 true 时在 `label` 前显示红色星号 | 否 | `false` |
| `labelWidth` | `double?` | 左侧标签宽度，为空时按内容自适应 | 否 | - |
| `prefix` | `Widget?` | 前缀组件；search 模式下传入会覆盖内置搜索图标 | 否 | - |
| `suffix` | `Widget?` | 后缀组件；传入后不显示内置清除按钮 | 否 | - |
| `suffixText` | `String?` | 右侧标识文案，如单位"元"、"个" | 否 | - |
| `suffixTextStyle` | `TextStyle?` | 右侧标识文案样式 | 否 | - |
| `suffixIcon` | `Widget?` | 右侧图标 | 否 | - |
| `suffixButton` | `Widget?` | 右侧按钮，如"获取验证码" | 否 | - |
| `inputFormat` | `SantoInputFormat` | 输入内容的类型限制，同时决定键盘类型与输入过滤；为 `text` 时键盘类型以 `inputType` 为准 | 否 | `SantoInputFormat.text` |
| `clearButtonMode` | `SantoInputClearButtonMode?` | 清除按钮显示模式 | 否 | `SantoInputClearButtonMode.never` |
| `status` | `SantoInputStatus` | 输入框语义状态，状态色用于输入壳层、计数器和边框 | 否 | `SantoInputStatus.normal` |
| `borderless` | `bool` | 是否隐藏输入框边框 | 否 | `false` |
| `maxLines` | `int?` | 最大行数；textarea 模式下保持默认 1 表示高度随内容增长 | 否 | `1` |
| `minLines` | `int?` | 最小行数；多行模式下为空时默认 4 | 否 | - |
| `maxLength` | `int?` | 最大字符数，使用 Flutter grapheme 计数语义；与 `maxCharacter` 互斥 | 否 | - |
| `maxCharacter` | `int?` | 最大字符权重，按 Unicode code point 计算（ASCII 计 1，非 ASCII 计 2）；与 `maxLength` 互斥 | 否 | - |
| `indicator` | `bool` | 是否显示当前字符计数；未配置长度限制时不会显示 | 否 | `false` |
| `autofocus` | `bool` | 是否自动聚焦 | 否 | `false` |
| `focusNode` | `FocusNode?` | 焦点节点 | 否 | - |
| `inputType` | `TextInputType` | 键盘类型，`inputFormat` 为 `text` 时生效 | 否 | `TextInputType.text` |
| `inputAction` | `TextInputAction?` | 键盘动作 | 否 | - |
| `textAlign` | `TextAlign` | 文本对齐方式 | 否 | `TextAlign.start` |
| `obscureText` | `bool` | 是否隐藏输入文本 | 否 | `false` |
| `showPasswordToggle` | `bool` | 是否在后置插槽显示内置密码显隐按钮；初始显隐状态由 `obscureText` 决定，仅支持单行输入 | 否 | `false` |
| `inputFormatters` | `List<TextInputFormatter>?` | 输入格式化器，追加在 `inputFormat` / 长度限制之后 | 否 | - |
| `style` | `TextStyle?` | 输入文本样式 | 否 | - |
| `cursorColor` | `Color?` | 光标颜色，为空时取主题品牌色 | 否 | - |

### 枚举说明

**`SantoInputMode`** — 输入框模式，对标 antd Input 的 Input / Input.Search / Input.TextArea：

| 值 | 说明 |
| --- | --- |
| `text` | 单行文本输入（默认） |
| `search` | 搜索框：默认带前置搜索图标，可用 `prefix` 覆盖 |
| `textarea` | 多行文本域：默认最小 4 行，高度随内容增长 |

**`SantoInputFormat`** — 输入内容的类型限制，同时决定键盘类型与输入过滤：

| 值 | 说明 |
| --- | --- |
| `text` | 不限制 |
| `digit` | 纯数字 |
| `number` | 数字，可含小数点和负号 |
| `idCard` | 身份证号（数字与 X） |
| `phone` | 手机号（数字与 + - 空格） |
| `email` | 邮箱字符（字母、数字与常见符号） |

**`SantoInputClearButtonMode`** — 清除按钮的显示模式：

| 值 | 说明 |
| --- | --- |
| `never` | 从不显示清除按钮 |
| `always` | 有文本时显示清除按钮 |
| `focused` | 输入框获得焦点且有文本时显示清除按钮 |

**`SantoInputStatus`** — 输入框语义状态（状态不改变已输入文字的正文色）：

| 值 | 说明 |
| --- | --- |
| `normal` | 默认状态 |
| `success` | 成功状态 |
| `warning` | 警告状态 |
| `error` | 错误状态 |

## 版本变更

### v2.0.0

- **变更**: 组件由 `SantoInputText` 更名为 `SantoInput`
- **新增**: `type` 参数（SantoInputMode.text/search/textarea 模式）
- **变更**: 边框宽度定稿为 1
- **变更**: 单行输入框默认高度由 44 改为 32
