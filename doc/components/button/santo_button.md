---
title: SantoButton
group:
  title: 通用
  order: 1
---

# SantoButton

按钮是库内**唯一的按钮入口**,类型、尺寸、颜色、形状、图标、状态等差异全部通过参数配置,
不再提供「大/小主按钮」「大/小描边按钮」「幽灵按钮」「图文按钮」等独立组件。

对标 [antd Button](https://ant-design.antgroup.com/components/button-cn):
`type` 是语法糖,等价于 `color` + `variant` 组合。

## 一、效果总览

- `type`:primary / normal / dashed / text / link 五种预置样式
- `color` + `variant`:语义色 neutral / primary / danger / success / warning / info 与 outlined / dashed / solid / filled / text / link 自由组合,可派生出任意一种 antd 风格按钮
- `size`:large(48 高/16 号)、middle(32 高/14 号,默认,最小宽 84)、small(24 高/12 号)
- `shape`:normal(圆角矩形)、round(两端半圆)、circle(圆形,仅图标)
- 状态:`danger`、`ghost`、`loading`、`block`、`isEnable`
- 图标:`icon` + `iconPlacement`(start / end / top / bottom)+ `iconSize`

## 二、描述

### 使用规范

1. 一个操作区最多一个 `type: SantoButtonType.primary` 主按钮
2. 按钮尺寸由 `size` 决定,不要再自建「大按钮/小按钮」组件;需要更小或更大的按钮时用 `size` + `insertPadding`
3. 内容区间距取主题 `commonConfig` 的 `hSpacingMd` / `vSpacingMd`,不要写魔法数字
4. `autoInsertSpace` 默认 true,两个汉字的文案会自动补空格,与 antd 一致
5. 两个汉字的文案若不想补空格,显式传 `autoInsertSpace: false`

### 布局规则

布局规则参考 `Container`:不给 `alignment` 赋值时按钮尺寸贴合内容;
`block: true` 或设置 `alignment` 后按父布局约束撑开。`circle` 形状的按钮是等宽高的正方形。

## 三、构造函数及参数说明

### 主要参数

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `text` | `String?` | - | 按钮文案,与 `child`、`icon` 至少提供一个 |
| `child` | `Widget?` | - | 自定义子节点,优先级高于 `text` |
| `type` | `SantoButtonType?` | - | 语法糖:primary / normal / dashed / text / link |
| `color` | `SantoButtonColor?` | - | 语义色:neutral / primary / danger / success / warning / info,优先级高于 `type` |
| `variant` | `SantoButtonVariant?` | - | outlined / dashed / solid / filled / text / link,优先级高于 `type` |
| `size` | `SantoButtonSize` | `middle` | large / middle / small |
| `shape` | `SantoButtonShape` | `normal` | normal / round / circle |
| `danger` | `bool` | `false` | 风险操作配色,固定为失败色 |
| `ghost` | `bool` | `false` | 背景透明,文字与边框取该颜色的主色(默认色用反色白),用于灰色/彩色背景之上 |
| `block` | `bool` | `false` | 撑满父布局宽度 |
| `loading` | `bool` | `false` | 展示加载中且不可点击 |
| `isEnable` | `bool` | `true` | 是否可用 |
| `icon` | `Widget?` | - | 图标 |
| `iconPlacement` | `SantoButtonIconPlacement` | `start` | start / end / top / bottom |
| `iconSize` | `double?` | - | 图标边长,设置后图标被约束为方形 |
| `autoInsertSpace` | `bool` | `true` | 两个汉字的文案自动补空格 |
| `onTap` | `VoidCallback?` | - | 点击回调 |

### 外观覆盖参数

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| `textColor` / `backgroundColor` | `Color?` | 覆盖类型默认色,低于禁用态配色 |
| `disableTextColor` / `disableBackgroundColor` | `Color?` | 禁用态配色 |
| `lineColor` | `Color?` | 描边/虚线按钮的边框色 |
| `insertPadding` | `EdgeInsetsGeometry?` | 内边距,默认按 `size` 取主题间距 |
| `fontSize` / `fontWeight` | `double?` / `FontWeight` | 字号与字重 |
| `textStyle` | `TextStyle?` | 文本样式,优先级最高 |
| `borderRadius` | `BorderRadiusGeometry?` | 圆角 |
| `constraints` / `width` / `alignment` | - | 布局逃生舱 |
| `decoration` | `Decoration?` | 自定义修饰,优先级最高 |

## 四、示例代码

```dart
// 五种类型
SantoButton(text: '主按钮', type: SantoButtonType.primary, onTap: () {});
SantoButton(text: '默认按钮', type: SantoButtonType.normal, onTap: () {});
SantoButton(text: '虚线按钮', type: SantoButtonType.dashed, onTap: () {});
SantoButton(text: '文本按钮', type: SantoButtonType.text, onTap: () {});
SantoButton(text: '链接按钮', type: SantoButtonType.link, onTap: () {});

// 颜色与变体
SantoButton(
  text: '浅色填充',
  color: SantoButtonColor.primary,
  variant: SantoButtonVariant.filled,
  onTap: () {},
);
SantoButton(
  text: '成功按钮',
  color: SantoButtonColor.success,
  variant: SantoButtonVariant.outlined,
  onTap: () {},
);

// 尺寸与 block
SantoButton(text: '大按钮', size: SantoButtonSize.large, block: true, onTap: () {});

// 图标与图文(图标在下)
SantoButton(
  text: '写备注',
  icon: const Icon(Icons.add),
  iconPlacement: SantoButtonIconPlacement.bottom,
  onTap: () {},
);

// 圆形图标按钮
SantoButton(
  icon: const Icon(Icons.search),
  type: SantoButtonType.primary,
  shape: SantoButtonShape.circle,
  onTap: () {},
);

// 幽灵按钮:透明底,文字与边框取该颜色的主色(默认色用反色白)
SantoButton(text: '主按钮', type: SantoButtonType.primary, ghost: true, onTap: () {});
SantoButton(text: '默认按钮', type: SantoButtonType.normal, ghost: true, onTap: () {});
SantoButton(text: '危险按钮', type: SantoButtonType.primary, danger: true, ghost: true, onTap: () {});

// 危险 + 加载
SantoButton(
  text: '删除',
  type: SantoButtonType.primary,
  danger: true,
  loading: true,
  onTap: () {},
);
```

### 按钮组合

按钮面板类组件(按钮集合、文本按钮集合、吸底按钮、多选吸底按钮)已移除,组合布局由调用方拼装:

```dart
Row(
  children: <Widget>[
    Expanded(child: SantoButton(text: '次按钮', type: SantoButtonType.normal)),
    const SizedBox(width: 10),
    Expanded(child: SantoButton(text: '主按钮', type: SantoButtonType.primary)),
  ],
)
```

## 五、主题定制

尺寸、圆角与字号由 `SantoButtonConfig` 提供,按 `size` 分三档:

```dart
SantoThemeConfigurator.instance.register(
  SantoAllThemeConfig(
    buttonConfig: SantoButtonConfig(
      largeButtonHeight: 48,
      largeButtonRadius: 12,
      largeButtonFontSize: 16,
      middleButtonHeight: 32,
      middleButtonRadius: 12,
      middleButtonFontSize: 14,
      smallButtonHeight: 24,
      smallButtonRadius: 12,
      smallButtonFontSize: 12,
    ),
  ),
  configId: 'your-config-id',
);
```

## 版本变更

### v1.1.0

- **新增**: `SantoButton` 统一按钮入口,新增 `color` / `variant` / `size` / `shape` / `ghost` / `iconSize` 参数
- **变更**: `SantoButtonType.normal` 对应 antd 的 default;`size` 默认 `middle`(高 32、字号 14)
- **变更**: `autoInsertSpace` 在两个汉字之间补空格的默认行为不再依赖是否显式指定 `type`
- **变化**: `SantoButtonConfig` 的 `bigButton*` / `smallButton*` 重命名为 `largeButton*` / `middleButton*`,并新增 `smallButton*`(高 24)
- **删除**: `SantoNormalButton`(`SantoNormalButton.outline` 语法糖一并移除,改用 `type: SantoButtonType.normal`)
- **删除**: `SantoBigMainButton` / `SantoBigOutlineButton` / `SantoBigGhostButton` / `SantoSmallMainButton` / `SantoSmallOutlineButton` / `SantoSmallGhostButton`
- **删除**: `SantoIconButton` / `SantoVerticalIconButton`(`Direction` 枚举移入引导组件)与 `SantoButtonConstant`
- **删除**: `SantoButtonPanel` / `SantoButtonPanelConfig` / `SantoBottomButtonPanel` / `SantoTextButtonPanel` / `SantoMultipleBottomButton`

### v1.0.0

- 初始版本发布
