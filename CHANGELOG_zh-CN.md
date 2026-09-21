# Changelog

[English](CHANGELOG.md) | [简体中文](CHANGELOG_zh-CN.md)

所有重要变更都会记录在这个文件中。

格式基于 [Keep a Changelog](https://keepachangelog.com/),版本遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

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
