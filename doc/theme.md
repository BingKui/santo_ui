---
order: 3
---

# 主题定制

<blockquote><p style="color:#666666">
  <font size="2">如果你想对使用的组件进行一些定制，你需要了解以下内容以帮助你快速实现你的构想。</font></p></blockquote>

#### 哪些组件支持主题定制?

全部组件都支持主题定制。全局令牌(颜色/字号/间距/圆角)在 `SantoCommonConfig` 里统一改;单个组件的样式可以用它自己的 <code>themeData</code>(对应的 <code>XxxConfig</code>,如 <code>SantoDialogConfig</code>、<code>SantoButtonConfig</code>)单独覆盖。

#### 支持哪些属性的定制？

主题定制不只是换色,文字大小、间距、圆角同样可配:

| 令牌 | 默认值 | 说明 |
| --- | --- | --- |
| `brandPrimary` | `0xFF1677FF` | 品牌色 |
| `brandPrimaryTap` | `0x191677FF` | 品牌色按下态 |
| `brandSuccess / Warning / Error` | `0xFF52C41A` / `0xFFFAAD14` / `0xFFFF4D4F` | 成功 / 警告 / 失败色 |
| `brandImportant / brandImportantValue` | `0xFFFF4D4F` / `0xFFFF5722` | 红点色 / 重要数值色 |
| `brandAuxiliary` | `0xFF2DB7F5` | 辅助色(iInfo) |
| `brandPrimaryBg / SuccessBg / WarningBg / ErrorBg` | `0xFFE6F4FF` / `0xFFF6FFED` / `0xFFFFFBE6` / `0xFFFFF2F0` | 语义色淡底(通知栏 / 状态标签) |
| `colorTextBase / Important / Secondary` | `0xFF17233D` / `0xFF515A6E` / `0xFF808695` | 标题 / 正文 / 描述文字色 |
| `colorTextDisabled / Hint / BaseInverse / Link` | `0xFFC5C8CE` / `0xFFCCCCCC` / `0xFFFFFFFF` / 跟随品牌色 | 禁用 / 提示 / 反色 / 链接文字色 |
| `fillBase / fillBody / fillMask` | `0xFFFFFFFF` / `0xFFF5F5F5` / `0x99000000` | 组件底 / 页面底 / 遮罩 |
| `borderColorBase / dividerColorBase` | `0xFFDCDEE2` / `0xFFE8EAEC` | 边框色 / 分割线色 |
| `fillBaseInverse` | `0xFF000000` | 反色组件底(大图查看等深色场景) |
| `appBarDarkBackgroundColor` | `0xFF2E313B` | AppBar 深色变体背景色 |
| `chartPalette` | 6 色分类色板 | 多系列图表按序取色 |
| `chartAxisColor / chartAxisTextColor / chartGridColor` | `0xFF222222` / `0xFF999999` / `0xFFCCCCCC` | 图表轴线 / 刻度文字 / 网格色 |
| `loadingPillBackgroundColor` | `0xFF1A1A1A` | Loading 浮层黑胶囊底 |
| `popoverBackgroundColor / tooltipBackgroundColor` | `0xFF1A1A1A` | Popover / Tooltip 浮层底 |
| `toastBackgroundColor` | `0xFF17233D` | Toast 浮层底 |
| `menuBarFloatingSelectedBgColor` | `0xFFF0F0F0` | 悬浮 MenuBar 选中项底 |
| `shadowColor` | `0x14000000` | 阴影颜色 |
| `shadowSm / shadowMd / shadowLg` | 见下 | 小 / 中 / 大阴影预设(`List<BoxShadow>`) |
| `radiusXs / Sm / Md / Lg` | 12 | 圆角 |
| `borderWidthSm / Md / Lg` | 0.5 / 1 / 2 | 边框宽度 |
| `fontSizeHeadLg / Head / SubHead / Base / Caption / CaptionSm` | 22 / 18 / 16 / 14 / 12 / 10 | 字号 |
| `gapXs / gapSm / gapMd / gapLg / gapXl / gapXxl` | 5 / 10 / 15 / 20 / 20 / 40 | 规范间距(按 `iDefaultGap`(5) 倍数推导) |
| `hSpacing* / vSpacing*` | 5 / 10 / 15 / 20 / 20 / 40 | 横向 / 纵向间距 |
| `iconSizeXxs / Xs / Sm / Md / Lg` | 8 / 12 / 14 / 16 / 32 | 图标尺寸 |

阴影预设默认值:

| 令牌 | 默认值 |
| --- | --- |
| `shadowSm` | `BoxShadow(color: 0x14000000, blurRadius: 2, offset: (0, 1))` |
| `shadowMd` | `BoxShadow(color: 0x1A000000, blurRadius: 8, offset: (0, 2))` |
| `shadowLg` | `BoxShadow(color: 0x1F000000, blurRadius: 24, offset: (0, 4))` |

#### 适用什么场景？

- 全局样式配置:品牌换色、统一圆角与间距,一次注册全局生效;
- 单组件样式配置:只改某个组件的样式,不动全局。

需要这类适配时,按下面的步骤定制~

### 主题配置

Santo 默认走自家的设计风格(令牌见上表),如果你想更换主题,可以参照以下步骤:

- step1：

在 Flutter 工程中创建一个 `utils` 类用来存放全局配置 如：`config_xxx_utils.dart`

- step2:

在创建的 `config_xxx_utils.dart` 中创建个工具类 `XxxConfigUtils`

- step3:

类中加入你想定制的样式，比如你想更换主题色，那么可以加如下代码

```dart
class XxxConfigUtils {

  static SantoAllThemeConfig defaultAllConfig = SantoAllThemeConfig(
      commonConfig: defaultCommonConfig);

  /// 全局配置
  static SantoCommonConfig defaultCommonConfig = SantoCommonConfig(
    ///品牌色
    brandPrimary: const Color(0xFF3072F6),
  );
}
```

如果你想配置 `Dialog` 圆角更大，那么可以这么做

```dart
class XxxConfigUtils {

  static SantoAllThemeConfig defaultAllConfig = SantoAllThemeConfig(
    commonConfig: defaultCommonConfig,
    // 这里添加dialog配置
    dialogConfig: defaultDialogConfig);

  static SantoCommonConfig defaultCommonConfig = SantoCommonConfig(
    brandPrimary: const Color(0xFF3072F6),
  );

  /// Dialog配置
  static SantoDialogConfig defaultDialogConfig = SantoDialogConfig(
    radius: 12.0,
  );
}
```

- step4:

在 `main.dart` 中注册前面创建的配置

```dart
SantoInitializer.register(allThemeConfig: XxxConfigUtils.defaultAllConfig);
```

多套主题并存(多渠道)时,换成 `SantoThemeConfigurator.instance.register(XxxConfigUtils.defaultAllConfig, configId: 'xxx')` 注册,读配置时带同一个 `configId` 即可。

当然你也可以忽略  step1 ~ step3，直接在 `main.dart` 中注册 `SantoAllThemeConfig`

```dart
SantoInitializer.register(
      allThemeConfig: SantoAllThemeConfig(
          // 全局配置
          commonConfig: SantoCommonConfig(brandPrimary: Color(0xFF3072F6)),
          // dialog配置
          dialogConfig: SantoDialogConfig(radius: 12.0))
);
```

最后

如果你想针对单个组件而并非一组组件进行配置，正如上面我们提到了所有支持主题定制的组件都有一个可选参数  <code>themeData</code>

```dart
SantoMultiChoiceInputFormItem(
  prefixIconType: SantoPrefixIconType.TYPE_REMOVE,
  isRequire: true,
  error: "必填项不能为空",
  title: "自然到访保护期",
  subTitle: "这里是副标题",
  tipLabel: "标签",
  ...
  themeData: SantoFormItemConfig(titleTextStyle:SantoTextStyle(color: Colors.red)),
)
```
