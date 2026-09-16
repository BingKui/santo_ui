---
title: SantoActionBar
group:
  title: 导航
  order: 3
---

# SantoActionBar

底部操作栏:一行承载若干图标入口与按钮,为页面底部的常用操作提供入口,参考 Vant ActionBar。

## 一、效果总览

操作栏高 50px,默认适配底部安全区;`SantoActionBarIcon` 保持固定宽度,
`SantoActionBarButton` 平分剩余宽度,并自动按位置处理首尾圆角与外边距。

## 二、描述

### 适用场景
1. 商品详情、订单详情等页面的底部操作区(客服、购物车、加入购物车、立即购买)。
2. 需要在页面底部固定一组操作入口,且不随内容滚动。

### 使用规范
- 使用方式:作为 `Scaffold.bottomNavigationBar`,或作为页面 Column 的最后一个子节点。
- `safeAreaInsetBottom` 默认 true,操作栏自身在底部预留安全区高度,页面无需再处理。
- 按钮类型:normal(白底描边)、primary、success、warning、danger;`color` 可覆盖背景色。
- 按钮禁用统一降透明度到 0.4;加载中展示进度指示且不响应点击。
- 首个按钮左侧、末个按钮右侧各留 5px 外边距并收 12px 圆角,中间按钮保持直角,
  位置由 SantoActionBar 自动计算,无需手动传入。

### 与 Vant 的对应关系
Vant 的 `placeholder` 用于给 `position: fixed` 的 DOM 补占位高度,Flutter 中操作栏
本身在布局流内(Scaffold.bottomNavigationBar 或 Column 末尾),因此未移植该属性。

## 三、构造函数及参数说明

### SantoActionBar

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| children | List&lt;Widget&gt; | 操作栏内容,通常为 SantoActionBarIcon 与 SantoActionBarButton | 是 | 无 |
| safeAreaInsetBottom | bool | 是否适配底部安全区 | 否 | true |
| backgroundColor | Color? | 背景色 | 否 | 主题 fillBase |

### SantoActionBarIcon

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| icon | Widget | 图标控件,图标自带颜色/尺寸时以图标自身设置为准 | 是 | 无 |
| text | String? | 图标下方的文案 | 否 | null |
| child | Widget? | 自定义文案控件,优先级高于 text | 否 | null |
| color | Color? | 图标颜色 | 否 | 基础文字色 |
| dot | bool | 是否展示红点 | 否 | false |
| badgeCount | int? | 角标数字,大于 0 时展示 | 否 | null |
| disabled | bool | 是否禁用 | 否 | false |
| onTap | VoidCallback? | 点击回调 | 否 | null |

### SantoActionBarButton

| 参数名 | 参数类型 | 描述 | 是否必填 | 默认值 |
| --- | --- | --- | --- | --- |
| text | String? | 按钮文案,与 child 至少提供一个 | 否 | null |
| child | Widget? | 自定义按钮内容,优先级高于 text | 否 | null |
| type | SantoActionBarButtonType | 按钮类型 normal/primary/success/warning/danger | 否 | normal |
| color | Color? | 自定义背景色,优先级高于 type,此时文案为白色且无描边 | 否 | null |
| icon | Widget? | 文案左侧的图标 | 否 | null |
| loading | bool | 是否加载中 | 否 | false |
| disabled | bool | 是否禁用 | 否 | false |
| onTap | VoidCallback? | 点击回调 | 否 | null |
| first | bool | 是否为整组按钮的首个,由 SantoActionBar 自动计算 | 否 | true |
| last | bool | 是否为整组按钮的末个,由 SantoActionBar 自动计算 | 否 | true |

## 四、示例代码

```dart
SantoActionBar(
  children: [
    SantoActionBarIcon(
      icon: Icon(Icons.headset_mic),
      text: '客服',
      onTap: () {},
    ),
    SantoActionBarIcon(
      icon: Icon(Icons.shopping_cart),
      text: '购物车',
      badgeCount: 2,
      onTap: () {},
    ),
    SantoActionBarButton(
      text: '加入购物车',
      type: SantoActionBarButtonType.warning,
      onTap: () {},
    ),
    SantoActionBarButton(
      text: '立即购买',
      type: SantoActionBarButtonType.danger,
      onTap: () {},
    ),
  ],
)

// 吸底用法
Scaffold(
  body: ListView(children: [/* 页面内容 */]),
  bottomNavigationBar: SantoActionBar(
    children: [
      SantoActionBarIcon(icon: Icon(Icons.star), text: '收藏', dot: true),
      SantoActionBarButton(text: '提交', loading: true),
    ],
  ),
)
```
