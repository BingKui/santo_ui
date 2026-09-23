# Changelog

[English](CHANGELOG.md) | [简体中文](CHANGELOG_zh-CN.md)

所有重要变更都会记录在这个文件中。

格式基于 [Keep a Changelog](https://keepachangelog.com/),版本遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

## [1.4.1] - 2026-09-23

### 🧭 Selection 示例

- **变更**: 复杂筛选示例改为分组入口，全部三级演示页统一迁移至 `SantoPageLayout`，平铺筛选示例合并为共享实现
- **修复**: 移除日期范围与选择数量限制示例中遗留的顶部关闭弹层占位内容

## [1.4.0] - 2026-09-22

### 🗂️ SantoEmpty 固定高度布局

- **新增**: `height` 参数,用于设置空状态组件高度,并让内容在该高度内垂直居中

### 📊 SantoTable 能力扩展

- **新增**: 横向/纵向合并、单选/多选、本地排序、展开折叠、分页及每页条数选择
- **新增**: 稳定 `rowKey` 与受控选择/展开状态;已有自定义渲染、固定高度滚动、固定列和边框控制继续兼容新表格流程
- **变更**: 默认表头由品牌色背景+反色文字调整为主题浅填充背景+主文字色
- **变更**: 默认单元格水平内边距统一读取 `commonConfig.hSpacingMd`

## [1.3.0] - 2026-09-22

### 🧭 AppBar 右侧图标操作对齐

- **新增**: `SantoIconAction.icon`(图标名)——由组件按主题图标大小构建图标,与左侧返回箭头同尺寸,颜色随 AppBar 深浅色自动对齐;`child` 保留给自定义 widget(未指定 size 的 `SantoIcon` 仍是它自己的默认值);`size` 语义由「点击区尺寸」改为「图标边长」
- **修复**: 右侧图标操作原先点击区只有 20×20 且用 Material 默认圆形水波,左侧 `SantoBackLeading` 是 32×32 + 12 圆角;现在两侧共用 `SantoAppBarTheme.leadingSize`(32×32)与同一个 12 圆角 `InkWell`
- **修复**: `Icon` 类图标原先被 20×20 的紧约束挤住、实际按 24 绘制溢出;现在统一按解析出的 20 渲染
- **变更**: 右侧操作区之间的间距(`SantoAppBarConfig.itemSpacing`,默认取 `SantoAppBarTheme.iconMargin`)由 20 改为 5,与左侧 `leadingSpacing` 一致;两侧距屏幕边缘仍为 15,整条导航栏左右对称

### 🔄 SantoRefresh 下拉安全区域

- **新增**: `triggerDistance` 参数——触发刷新所需的下拉距离(安全区域高度),默认 50。未达该距离时头部不展示任何提示、松手也不触发刷新;达到后才展示「松手刷新」,松手即刷新
- **变更**: `loadingBarHeight` 不再兼作触发阈值,只表示刷新头部高度(刷新进行中头部停留的高度),是否可触发改由 `triggerDistance` 判定
- **新增**: `triggerDistance <= maxBarHeight` 断言,避免下拉永远到不了触发距离

### 📐 PageLayout 顶部安全区

- **修复**: 传 `header` 且不传 `appBar`(如整页自定义品牌头部)时,内容区的 `MediaQuery.padding.top` 仍是状态栏高度。自带滚动且未显式传 `padding` 的 `ListView` 会把它当成顶部内边距消费,`header` 下方因此多出一条状态栏高度的空白。现在内容区的 `MediaQuery.padding.top` 统一置 0 —— 顶部避让始终由布局承担(无 `header` 时并入 `padding`、有 `header` 时由 header 自身的 `SafeArea` 处理),滚动态与非滚动态行为一致
- **新增**: 两条回归测试(传 `header` 时内容区顶部安全区为 0;头部与首块内容的间距只含 `padding`,不含状态栏高度)

### ➖ Divider 自定义间距

- **新增**: `spacing` 参数——水平分割线的自定义上下间距,优先于 `size`;传 `0` 可完全去掉上下留白(如外层行内边距已足够时)

## [1.2.0] - 2026-09-21

### 🧭 AppBar 重设计

- **变更**: 返回键与 `SantoDoubleLeading` 每个操作位固定 32×32 点击区(`SantoAppBarTheme.leadingSize`),两个操作位间距 5,导航栏左右缘留白 15;双 leading 宽度与预留槽位由同一公式计算,此前的横向溢出不再出现
- **变更**: 标题始终相对整条导航栏居中(`centerTitle` 固定)
- **新增**: 浅色/深色内容模式 —— 背景亮度 < 0.5(深色模式或自定义背景色)时标题/操作文字/返回箭头/图标主题默认白色,自定义其他颜色保留;浅色背景内容默认黑色,自定义白色自动回退为黑色(白底不可见)
- **修复**: `SantoAppBarConfig.copyWith` 与构造函数参数 `systemUiOverlayStyle` 统一更名为 `systemOverlayStyle`,与 Flutter `AppBar` 一致

### 🧭 MenuBar 选中样式

- **新增**: `selectedTextStyle` / `unselectedTextStyle`,完整定制选中/未选中文字的字号、字重、颜色(缺省回退到颜色参数)
- **新增**: 停靠样式支持 `itemSelectedBgColor` 选中背景(滑动动画,与悬浮样式同款),默认不展示
- **修复**: 停靠样式图标颜色此前不随选中状态变化,现通过 `IconTheme` 跟随选中/未选中色(图标自带 color 时以图标为准)

### 📐 PageLayout 扩展

- **新增**: `header` —— 标题下方固定区域(搜索框/筛选/Tab/步骤条/日历等),撑满宽度、不加内边距、高度自适应且不随内容滚动
- **新增**: `enableRefresh` / `onRefresh` —— 内置滚动容器由 `SantoRefresh` 承载,并施加 `AlwaysScrollableScrollPhysics`,内容不满一屏也能下拉
- **新增**: `padding` 覆盖默认内容区内边距(顶部状态栏避让仍由布局叠加)
- **新增**: `appBar*` 透传参数(`appBarLeading` / `appBarActions` / `appBarBackgroundColor` / `appBarElevation` / `appBarShadowColor` / `appBarShape` / `appBarIconTheme` / `appBarActionsIconTheme` / `appBarSystemOverlayStyle` / `appBarBackLeadCallback`),作用于仅传 title 的简写构建

### 🧭 ActionBar 边距与分割线

- **变更**: 操作栏按钮区左右外边距 10(首/末按钮)、上下留白 5,按钮高度改为占满栏内剩余高度,不再固定 40
- **新增**: 操作栏顶部增加 0.5px 分割线

下拉刷新重构、TabBar 选中指示条、Empty 插画、Checkbox/Radio 卡片选中样式、城市选择与省市区级联。**含破坏性变更**:`SantoEmptyImageType` 枚举值重定义、`SantoTabBar` 指示条参数移除、部分遗留 `SantoAsset` 常量移除。

### 🔄 PageLayout 下拉刷新抖动

- **修复**: 松手后刷新头先一路收到 0、再突然弹出 Loading 区的问题:iOS Bouncing 物理下 `ScrollEndNotification` 要等回弹模拟结束才发出,之前回弹阶段持续跟随 pixels 把头部收完才触发刷新。现在在松手后第一条滚动通知处立即判定:已过阈值就直接平滑收缩到 `loadingBarHeight` 并保持,刷新完成后再收到 0(与 Vant PullRefresh 一致)
- **变更**: 默认刷新头去掉主题 `fillBody` 圆角底色,改为透明背景,仅展示加载图标与提示文案
- **变更**: 默认刷新头的完成态改为成功图标(`check-circle`,主题 `brandSuccess` 色),不再是下拉箭头
- **变更**: 完成态(成功图标与「刷新完成」文案)保持到头部完全收起——收起动画结束才回到初始态,不再动画一启动就切回下拉箭头
- **新增**: 强制 Bouncing 物理的回归测试,断言刷新期间头部稳定停在刷新高度(不低于它)、完成后归零
- **修复**: 刷新头原先是滚动视图上方的 `Column` 兄弟节点,高度增长会逐帧挤压列表视口——下拉时页面抖动、可见内容被压得很少。现在改为覆盖式头部:列表内容用 `Transform.translate` 下移(纯绘制不触发布局),整个下拉过程视口高度恒定;平移量会扣除负向 pixels,iOS Bouncing 物理下内容不会双重位移
- **修复**: `SantoPageLayout.enableRefresh` 之前挂了没有 parent 的裸 `AlwaysScrollableScrollPhysics`,没有边界约束和松手回弹模拟——刷新后滚动位置残留负值,之后任何滚动都会把刷新头重新拉出来。现在把平台物理(`ScrollConfiguration.of(context).getScrollPhysics(context)`)作为 parent 挂接
- **新增**: 回归测试断言刷新完成后滚动位置归零、下拉过程中滚动视口高度恒定

### 🏙 城市选择

- **修复**: 列表 ListTile 与最近 Material 之间的白色 DecoratedBox 会盖住水波纹并触发框架 "ListTile background color or ink splashes may be invisible" 断言,页面 body 改为直接用白色 Material 承载
- **变更**: 推荐城市按钮增加 `radiusXs` 圆角、固定 36 高度、背景改为透明
- **变更**: 搜索框 padding 统一为 `hSpacingMd`(不再左右 20 / 上下 10),搜索框下分割线按 0.5 细线规范
- **变更**: A-Z 索引条增加常驻选中样式——当前列表分组对应的字母显示为品牌色圆形底 + 白色字母(`IndexBar.currentTag`,由 AzListView 传入);按下的字母保持灰色圆形高亮;移除无用的 `IndexBar.touchDownTextStyle`

### 🗺 省市区级联

- **新增**: `SantoCascader.showArea()` 快捷弹出省/市/区三级选择器,内置数据移植自 `@vant/area-data`(34 省 / 369 市 / 3478 区县,行政区划码为国家标准 6 位码)
- **新增**: `SantoAreaData` 暴露 `provinceList` / `cityList` / `countyList` 三个码到名称的扁平映射,以及 `cascaderItems`(按码前缀推导的省/市/区三级树,value 为码、label 为名称),可配合通用 `SantoCascader.show()` 使用
- **新增**: `showArea` 确认回调回传 `SantoAreaResult`,包含 `codes` / `names` / `text`(名称以 "/" 拼接)与省/市/区分项取值 `provinceCode` / `provinceName` / `cityCode` / `cityName` / `districtCode` / `districtName`;`initialValues` 支持传行政区划码回显

### 🖼 Empty 插画

- **变更**: `SantoEmpty` 内置插画整体替换为 `assets/empty` 下的 12 张 SVG 插画,`SantoEmptyImageType` 枚举值重新定义为 notFound / contentEmpty / importLoading / listEmpty / loadFail / noAccess / notOpenPayType / offline / orderEmpty / searchEmpty / unbindAccount / wait(原 noData / networkError 移除)
- **变更**: `img` 参数类型从 `Image?` 放宽为 `Widget?`,支持传入任意图片组件(含 SVG);自定义图片仍优先于 `imageType`
- **变更**: `SantoAbnormalStateUtils` 预设映射更新:加载失败 → loadFail、网络未连接 → offline、暂无数据 → listEmpty
- **删除**: 包内老插画 `assets/images/no_data.png`、`assets/images/network_error.png` 及 `SantoAsset.noData`、`SantoAsset.networkError` 常量

### 🧭 TabBar 指示器

- **变更**: `SantoTabBar` 选中指示器改为选中圆角区域自身的底部 border(通栏宽、随圆角裁切),与选中底色共用同一套切换动画;TabBar 内置指示器已关闭
- **删除**: `SantoTabBar.indicatorWidth` 与 `SantoTabBar.indicatorPadding`(不再有意义);`indicatorWeight` 仍控制粗细、`indicatorColor` 仍控制颜色;`SantoAnchorTabBarStyle.indicatorPadding` 同步删除
- **修复**: 更多按钮的 Container 此前把 tight 约束直接传给图标,导致箭头 SVG 无论 `SantoIcon.size` 多少都按约 25px 渲染;现已居中放置 20px 图标(chevron 字形只占 viewBox 一半,视觉线宽约 10px)

### 📜 Drawer 长内容

- **修复**: `SantoBottomDrawer` 内容区改为自动可滚动,长内容超过 `maxHeight`(默认屏幕高度 85%)时由内容区滚动消化,不再竖向溢出;抽屉示例新增「长内容自动滚动」演示

### 📜 抽屉安全区与宽度上限

- **新增**: `SantoDrawer` 内容区按滑出方向自动避让安全区——顶部抽屉避让状态栏、底部抽屉避让手势条、左右整屏高抽屉上下都避让。与 `SantoBottomDrawer` / `SantoFloatingPanel` 一致,通过改写内容区 MediaQuery padding 交给内容消费(不可配置),安全区放在内容中而不是额外加一块空白区域:可滚动内容(如不传 padding 的 ListView)自动把安全区消费为滚动内边距,滚动区铺满整个抽屉,滚到底最后一项停在安全区之上;固定头尾在抽屉子树内读取 `MediaQuery.of(context).padding` 把安全区算进自身 padding。抽屉示例同步改为此写法(标题作为列表首项自动消费、底部按钮行内联合入安全区)
- **变更**: 左右方向抽屉宽度上限为屏幕宽度的 95%,超出时收敛到上限

### 🔄 刷新头部圆角

- **修复**: 默认下拉刷新头部改为圆角(主题 `radiusMd`),不再是直角满宽色块

### 🗑 遗留位图资源清理

- **删除**: `SantoAsset` 中 28 个已废弃常量(选中/未选中框、alert/warning/success、star_size、arrow_up/down、require_red、star_select、notice 系列)及其对应 PNG 资源;组件图标已统一由 SantoIcon 提供,`assets/images` 由 50 个文件精简到 40 个、`assets/icons` 由 33 个精简到 12 个
- **删除**: 示例工程中 10 个无引用资源——`example/assets/image`:arrow_up / icon_clear_grey / icon_navbar_add_hei / icon_navbar_im_bai / icon_navbar_xiala_hei / icon_refresh / icon_theme / network_error / no_data,以及 `example/assets/icons`:navbar_house;同时移除示例 pubspec 中已空掉的 `assets/icons/` 条目。`assets/icons/grey_place_holder.png` 保留:相册配置与两个 ActionSheet 示例会从包内取它(`SantoTools.getAssetImage` 会加 `package: santo_ui`)

### 🧭 示例图标去图片化

- **变更**: 导航栏与 Toast 示例不再加载 PNG 图标——搜索 / 加号 / 关闭 / 下拉 / 分享 / 拼团 / 关注 / 消息 改为 `SantoIcon`(`SantoIcons.search` / `plus` / `xmark` / `navArrowDown` / `shareIos` / `group` / `heart` / `chatLines`),Toast 前置图标改用实心 `check-circle` / `xmark-circle`,对应的 16 张 PNG 已删除
- **变更**: `SantoToast.show` 的 `preIcon` 与 `ToastChild.leading` 由 `Image?` 放宽为 `Widget?`,可传任意组件(含 `SantoIcon`)作为前置图标

### ☑️ Checkbox / Radio 卡片选中样式

- **变更**: `cardMode` 卡片的选中态改为卡片右侧一颗实心 `check-circle` 图标——与卡片描边同色、边长取卡片高度的 50%,替换原先左上角的品牌色三角 + 白色对号,三角绘制类 `_CornerCheck` 已删除
- **修复**: 卡片描述(`subTitle`)多缩进了一份 `insetSpacing`(容器内边距被重复计算),与标题不对齐;现在 `cardMode` × `contentDirection` 四种组合下描述都与标题左对齐

## [1.1.1] - 2026-09-21

### 🧩 Segmented 角标

- **新增**: `SantoSegmentedOption.badgeCount` 在文案右侧展示计数角标(内部用 `SantoBadge` 渲染,超 99 显示 99+),`SantoSegmentedOption.dot` 展示红点角标,对标 antd Segmented 的选项角标;示例页新增「带角标」演示

### 🖼 Empty 图片参数

- **变更**: `SantoEmpty` 新增 `imageType` 参数(`SantoEmptyImageType` —— noData / networkError),配置不同类型展示不同内置插画;`imageType` 与 `img` 都不配置时不展示图片;`img` 自定义图片优先级最高;`SantoAbnormalStateUtils` 改为通过 `imageType` 提供预设插画

## [1.1.0] - 2026-09-20

按钮、加载、弹窗、Card 与 Tag 多类组件收敛为唯一入口,图标统一为 SantoIcon,组件间距统一取主题 token。**破坏性变更。**

### 💥 破坏性变更

#### 按钮收拢为唯一入口 SantoButton

- **新增**: `SantoButton` 统一按钮组件,新增 `color` / `variant` / `size` / `shape` / `ghost` / `iconSize` 参数
- **新增**: `SantoButtonColor` 语义色 neutral / primary / danger / success / warning / info,分别取主题的 `colorTextBase` / `brandPrimary` / `brandError` / `brandSuccess` / `brandWarning` / `brandAuxiliary`
- **新增**: `SantoButtonSize` 三档尺寸 large(48/16)、middle(32/14,默认,最小宽 84)、small(24/12)
- **删除**: `SantoNormalButton`(含 `SantoNormalButton.outline`)、`SantoBigMainButton`、`SantoBigOutlineButton`、`SantoBigGhostButton`、`SantoSmallMainButton`、`SantoSmallOutlineButton`、`SantoSmallGhostButton`
- **删除**: `SantoIconButton`、`SantoVerticalIconButton`(图文按钮并入 `SantoButton` 的 `icon` + `iconPlacement`,`Direction` 枚举移入引导组件)、`SantoButtonConstant`
- **删除**: `SantoButtonPanel`、`SantoButtonPanelConfig`、`SantoBottomButtonPanel`、`SantoTextButtonPanel`、`SantoMultipleBottomButton`;按钮组合改由调用方用 `Row` / `Expanded` / `SantoSpace` 拼装
- **变更**: `SantoButtonConfig` 的 `bigButton*` / `smallButton*` 重命名为 `largeButton*` / `middleButton*`,并新增 `smallButton*`
- **变更**: 按钮文本默认字号与高度统一由 `size` 决定,默认尺寸为 middle
- **变更**: 去掉各按钮组件的 `themeData` 与 `maxWidth` 参数,改用全局 `SantoButtonConfig` 与 `fontSize` / `width` 等参数

#### 弹窗收拢为唯一入口 SantoDialog

- **新增**: `SantoDialog` 统一弹窗入口,六项配置全部参数化 —— 图标 `icon` / `iconType`、标题 `title` / `titleWidget`、辅助文案 `message` / `messageWidget`、输入框 `showInput` 及 `input*` 一组参数、底部两个按钮 `okText` / `cancelText`、右上角关闭 `closable`
- **新增**: 输入框内部渲染 `SantoInputText`;`messageMaxHeight` 限定辅助文案区高度,超出后在文案区内滚动
- **新增**: 命名构造 `SantoDialog.alert`(纵向主次按钮强提示)、`SantoDialog.richText`(长文本 CSS2 富文本)、`SantoDialog.singleSelect`(单选列表)、`SantoDialog.multiSelect`(多选列表)、`SantoDialog.share`(分享渠道)
- **新增**: 静态方法 `SantoDialog.confirm` / `info` / `success` / `warning` / `error`,一次性弹窗无需自己 `new` 与 `pop`;`SantoDialog.show` / `SantoDialog.dismiss` 支持按 tag 精确关闭弹窗
- **新增**: `SantoDialogIconType` 预设图标 info / warning / error / success,统一取 `SantoIcon` 的线图标与主题语义色、`SantoDialogSingleSelectSubmit` / `SantoDialogMultiSelectSubmit` / `SantoDialogSelectItemClick` / `SantoDialogShareItemClick` 等回调类型
- **删除**: `SantoDialogManager`(三个 show 方法分别由 `SantoDialog.confirm` 与构造函数 + `showDialog` 承接)
- **删除**: `SantoEnhanceOperationDialog`、`SantoDialogConstants`
- **删除**: `SantoContentExportWidget`、`SantoScrollableTextDialog`、`SantoScrollableText`
- **删除**: `SantoMiddleInputDialog`、`SantoSingleSelectDialog`、`SantoSingleSelectDialogWidget`
- **删除**: `SantoMultiSelectDialog`、`MultiSelect`(选项 `MultiSelectItem` 保留)
- **删除**: `SantoShareDialog`(分享渠道形态并入 `SantoDialog.share`,底部面板形态继续用 `SantoShare`)
- **删除**: `SantoSafeDialog`(能力并入 `SantoDialog.show` / `SantoDialog.dismiss`)、`SantoDialogUtils`
- **变更**: 底部按钮由 `actionsText` + `indexedActionCallback` 改为 `okText` / `cancelText` / `onOk` / `onCancel`;`actionsWidget` 改为 `footer`,两个按钮以上由调用方用 `Row` / `Column` 拼装
- **变更**: 头部图标由 `showIcon` / `iconImage` 改为 `iconType` / `icon`;关闭按钮由 `isClose` / `onCloseClick` 改为 `closable` / `onClose`
- **变更**: 辅助文案参数 `messageText` → `message`;`dismissOnActionsTap` → `dismissOnActionTap`
- **变更**: 按钮点击统一为「先关闭弹窗再回调」;输入框的值改为从 `inputController.text` 读取(原 `onConfirm(value)`)
- **变更**: 弹窗内边距与块间距统一取规范间距 token,清掉继承自 Bruno 的非档位值(标题横向 40、内容横向 20、
  标题↔正文 8、图标↔标题 12、正文↔底部 28、警示上方 6、无图标顶 25):横向与块间距取 `hSpacingMd` / `vSpacingMd`(15),
  顶部留白单独一档 —— 图标距顶部 `vSpacingXxl`(40),无图标时 `vSpacingXl`(20)
- **变更**: 弹窗宽度恢复为屏幕宽的 85%(与收拢前的 `SantoDialog` 一致;收拢中曾误用主题里未被使用的 `dialogWidth` 300),需要固定宽度时传 `width`
- **变更**: 弹窗内部不再有重复的灰色底/Scaffold,统一为一层白色圆角 `Material`,内容超出可用高度时整体可滚动

#### ActionBar 图标与按钮接入统一体系

- **变更(破坏性)**: `SantoActionBarIcon` 的 `icon` 参数类型由 `Widget` 改为 `String` 图标名称(取值见 `SantoIcons` / `SantoSolidIcons`),内部统一用 `SantoIcon` 渲染,颜色与尺寸由组件掌控
- **变更**: `SantoActionBarButton` 改为基于 `SantoButton` 实现,不再自绘容器与按压反馈;禁用态由透明度 0.4 改为 `SantoButton` 标准禁用样式(置灰),文字字重改为 `SantoButton` 默认 w500,并接入全局防连点

#### Card 收敛与 Descriptions

- **变更(破坏性)**: `SantoShadowCard` 改名为 `SantoCard`,并新增 `title` / `titleWidget` / `extra` / `meta` 参数,默认背景改为主题 `fillBase`(白)
- **新增**: `SantoCardMeta`(头像 + 标题 + 描述)与 `SantoDescriptions` / `SantoDescriptionsItem`,对标 antd Descriptions,支持 `column` / `layout` / `bordered` / `size` / `colon` / `labelWidth` / `span`
- **删除**: `SantoInsertInfo`(与 `SantoBubbleText` 重复,气泡文本统一用 `SantoBubbleText`)
- **删除**: `SantoFollowPairInfo`、`SantoAlignPairInfo`(由 `SantoPairInfoTable` 的 `isValueAlign` 覆盖,两者转为库内私有实现)
- **变更(破坏性)**: Tag 收敛为唯一入口 `SantoTag`,普通/描边/状态/多彩形态全部通过参数实现;`SantoTagCustom`(含 `buildBorderTag`)与 `SantoStateTag` 删除,`TagState` 枚举更名为 `SantoTagState`

### ⏳ Loading 收拢

- **新增**: `SantoLoading` 统一加载组件,对标 antd Spin,覆盖尺寸、文案、受控、延迟、自定义指示器、包裹、全屏、进度
- **新增**: `SantoLoadingSize` 三档尺寸 small(14)、medium(20,默认)、large(32)
- **新增**: 静态方法 `SantoLoading.show` / `SantoLoading.dismiss` 展示与关闭加载浮层
- **删除**: `SantoPageLoading`、`SantoLoadingDialog`,由 `SantoLoading` 与 `SantoLoading.show` / `dismiss` 承接
- **变更**: 浮层文案参数由 `content` 改为 `tip`

### 🎨 图标统一为 SantoIcon

- **新增**: `SantoIcon` 统一图标组件,按名称取用图标;`SantoIcons` 提供全部 1383 个常规图标名称常量
- **新增**: 内置开源图标库 [Iconoir](https://github.com/iconoir-icons/iconoir)(MIT)的图标 SVG 资源,存于 `assets/iconoir/`,分 regular(1383 个)与 solid(288 个)两种风格
- **新增**: `solid` 参数支持实心风格,配套 `SantoSolidIcons` 名称常量
- **变更**: 新增依赖 `flutter_svg ^2.3.0`
- **变更**: 搜索、关闭、右/上/下箭头、三角、增删、问号、日历翻月等线图标由 PNG 资源统一换为 `SantoIcon`,涉及 43 个组件文件;组件内的多色 PNG 图标(选择指示器、评分星、筛选重置、选择菜单上下箭头、表单必填星、NoticeBar 的十种状态图标)同步替换,弹窗预设图标与选中/点亮态用 `SantoSolidIcons` 的 solid 实心变体
- **保留**: 评价表情、分享渠道品牌图标、步骤数字徽标,以及插画类图片(`SantoEmpty` 的 no_data / network_error、城市选择空态)
- **变更**: 步进器增删按钮的可用/禁用态改用主题色 `colorTextSecondary` / `colorTextDisabled` 区分
- **删除**: `SantoAsset` 中 56 个已无引用的常量;`assets/` 下 63 个无引用资源文件(含 `assets/icons/radio/` 整个目录)

### 🧩 Table 支持滚动与固定列

- **新增**: `SantoTable.height` 内容区高度,数据超出时在内容区内纵向滚动,表头固定(对标 antd `scroll.y`)
- **新增**: 横向滚动,列宽和超出容器宽度时自动开启,所有列按定宽渲染,未定宽列取默认宽 120
- **新增**: `SantoTableColumn.fixed`(left / right)固定列,横向滚动时钉在两侧,可与纵向滚动组合(对标 `column.fixed`)
- **删除**: `SantoTable.pinnedHeader`,由 `height` 取代
- **变更**: 全部列定宽且超出容器时由"按比例压缩"改为横向滚动

### 📏 间距统一取主题 token

- **变更**: `SantoSpace` 三档间距由硬编码 8/16/24 改为取主题 token(水平 `hSpacingSm/Md/Lg`、垂直 `vSpacingSm/Md/Lg`,默认 10/15/20)
- **变更**: `SantoDividerSize` 枚举注释修正为与实现一致(取主题 `vSpacingSm/Md/Lg`),行为不变

### 📝 示例与文档

- 按钮示例页按 antd Button 文档分组重写:类型/幽灵/危险/图标/图标位置/加载中/多种尺寸/禁用/block/颜色与变体/形状/自定义禁用底色/按钮组合
- 全库调用点(对话框、选择器、标签选择、评价、选择筛选等)与示例统一迁移到 `SantoButton`
- 弹窗示例页按 antd Modal 分组重写:基础用法/图标/辅助文案/输入框/警示文案/右上角关闭/自定义底部/强提示弹窗/语义弹窗/长文本/单选列表/多选列表/分享渠道/按 tag 关闭
- 原「CardContent 卡片内容」入口改名为「Descriptions 描述列表」,示例重写为单页
- ActionBar 示例与文档中的 Material 图标全部替换为 SantoIcon 图标
- 新增组件文档 `doc/components/button/santo_button.md`、`doc/components/icon/santo_icon.md`、`doc/components/dialog/santo_dialog.md`(含旧的 9 个弹窗类到新 API 的迁移对照)、`doc/components/card/santo_card.md`、`doc/components/descriptions/santo_descriptions.md`

## [1.0.1] - 2026-09-18

### 🐛 Bug 修复

- 修复 `SantoProgress` 移除未使用字段后 `initState` 仍引用 `_previousValue` 导致的编译错误
- 移除 `SantoMessage` 中对 `Overlay.of(context)` 结果的无效空判断

### ⚡ 优化

- 移除 `SantoAvatar`、`SantoDrawer`、`SantoLink`、`SantoSkeleton`、`SantoMenuBar` 中的未使用变量、冗余非空断言与未使用导入,`dart analyze` 全量通过无告警

## [1.0.0] - 2026-09-18

Santo UI v1.0.0 初始版本发布。包含 **80** 组件,按示例菜单分为通用、布局、导航、数据录入、数据展示、反馈、数据图表 7 个分组。

###  核心特性

- **统一主题系统**: SantoThemeConfigurator 支持多 configId 注册,提供品牌色、圆角、间距等完整主题定制
- **规范间距体系**: `gapXs~gapXxl`(5/10/15/20/30/40) + `iGapAll/iGapAllSmall/iGapAllMiddle/iGapAllLarger` 预设
- **底部安全区规范**: 贴底组件背景铺到屏幕底部,内容在安全区之上避让且不可配置
- **全局圆角统一**: 12px 基准,主题令牌 radiusXs/Sm/Md/Lg 及各组件容器圆角

### 📦 组件清单(按示例菜单分组)

#### 通用 (7)

Button 按钮、Fab 悬浮按钮、Link 链接、Panel 面板、Section 区块、SafeArea 安全区域、CardContent 卡片内容

#### 布局 (7)

Divider 分割线、Space 间距、Masonry 瀑布流、Skeleton 骨架屏、FloatingPanel 浮层面板、AppLayout 应用布局、PageLayout 页面布局

#### 导航 (10)

AppBar 导航栏、Tabs 标签页、MenuBar 菜单栏、Sidebar 侧边栏、Steps 步骤条、AnchorTab 锚点、BackTop 返回顶部、Drawer 抽屉、Guide 引导、ActionBar 操作栏

#### 数据录入 (16)

Input 输入框、Form 表单、Radio 单选框、Checkbox 多选框、Switch 开关、Rate 评分、Stepper 步进器、Slider 滑动输入条、SearchText 搜索框、Picker 选择器、Cascader 级联选择、DropdownMenu 下拉菜单、Selection 筛选、Tree 树形控件、Calendar 日历、CitySelection 城市选择

#### 数据展示 (23)

Avatar 头像、Badge 徽标数、Cell 单元格、Card 卡片、Swiper 轮播、Collapse 折叠面板、Image 图片、Table 表格、Pagination 分页、Segmented 分段选择器、Statistic 统计数值、Tag 标签、BubbleText 气泡文本、Highlight 关键词高亮、TextEllipsis 文本省略、Popover 气泡卡片、SwipeCell 滑动单元格、NoticeBar 通知栏、Progress 进度条、TimeCounter 计时器、Empty 空状态、Footer 页脚、Gallery 图片浏览

#### 反馈 (11)

Dialog 对话框、ActionSheet 动作面板、Share 分享、Toast 轻提示、Message 全局提示、Tooltip 文字提示、OverlayWindow 悬浮窗、Loading 加载、Refresh 下拉刷新、Result 结果、Appraise 评价

#### 数据图表 (6)

BrokenLine 折线图、Radar 雷达图、Funnel 漏斗图、Doughnut 环状图、ProgressChart 进度图、BarChart 柱状图

### 🎯 设计参考

本组件库整合优化了以下优秀开源项目:

- [Bruno](https://github.com/LianjiaTech/bruno) - 贝壳找房 Flutter 组件库
- [antd](https://github.com/ant-design/ant-design) - Ant Design React 组件库
- [TDesign](https://github.com/Tencent/tdesign-flutter) - 腾讯 TDesign Flutter 组件库
- [Vant](https://github.com/youzan/vant) - 有赞 Vant 移动端组件库

### 📚 文档与示例

- 完整的组件文档站 (`doc/components/`)
- 示例 App (`example/`),包含所有组件的使用示例
- 开发约定文档 (`AGENTS.md`)
- API 变更版本标注规范

### 🔧 技术栈

- Flutter >=3.10.0
- Dart >=3.13.3
- 依赖: xml ^6.1.0, lpinyin ^2.0.3, path_drawing ^1.0.0, intl >=0.18.0 <2.0.0, photo_view ^0.15.0

---

## 参考

- [Keep a Changelog](https://keepachangelog.com/) - 变更日志格式规范
- [语义化版本 2.0.0](https://semver.org/lang/zh-CN/) - 版本号规范
