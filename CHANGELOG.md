# Changelog

所有重要变更都会记录在这个文件中。

格式基于 [Keep a Changelog](https://keepachangelog.com/),版本遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

## [1.0.0] - 2026-09-18

Santo UI v1.0.0 初始版本发布。包含 **74** 组件,按示例目录分为以下分类:

###  核心特性

- **统一主题系统**: SantoThemeConfigurator 支持多 configId 注册,提供品牌色、圆角、间距等完整主题定制
- **规范间距体系**: `gapXs~gapXxl`(5/10/15/20/30/40) + `iGapAll/iGapAllSmall/iGapAllMiddle/iGapAllLarger` 预设
- **底部安全区规范**: 贴底组件背景铺到屏幕底部,内容在安全区之上避让且不可配置
- **全局圆角统一**: 12px 基准,主题令牌 radiusXs/Sm/Md/Lg 及各组件容器圆角

### 📦 组件清单(按示例目录分组)

#### action_bar (1)

ActionBar - 底部操作栏

#### actionsheet (1)

ActionSheet - 动作面板

#### appraise (1)

Appraise - 评价

#### avatar (1)

Avatar - 头像

#### backtop (1)

BackTop - 回到顶部

#### badge (1)

Badge - 徽标

#### bubble_text (1)

BubbleText - 气泡文本

#### button (1)

Button - 按钮

#### calendar (1)

Calendar - 日历

#### card (1)

Card - 卡片

#### cascader (1)

Cascader - 级联选择

#### cell (1)

Cell - 单元格

#### charts (1)

Charts - 图表

#### checkbox (1)

Checkbox - 复选框

#### collapse (1)

Collapse - 折叠面板

#### dialog (1)

Dialog - 对话框

#### divider (1)

Divider - 分割线

#### drawer (1)

Drawer - 抽屉

#### dropdown_menu (1)

DropdownMenu - 下拉筛选菜单

#### empty (1)

Empty - 空状态

#### fab (1)

FAB - 浮动按钮

#### floating_panel (1)

FloatingPanel - 浮动面板

#### footer (1)

Footer - 页脚

#### form (1)

Form - 表单

#### gallery (1)

Gallery - 图片画廊

#### guide (1)

Guide - 引导

#### highlight (1)

Highlight - 关键词高亮

#### image (1)

Image - 图片

#### input (1)

Input - 输入框

#### layout (1)

Layout - 布局

#### link (1)

Link - 链接

#### loading (1)

Loading - 加载

#### masonry (1)

Masonry - 瀑布流

#### menu_bar (1)

MenuBar - 菜单栏

#### message (1)

Message - 消息提示

#### navbar (1)

Navbar - 导航栏

#### noticebar (1)

NoticeBar - 通知栏

#### pagination (1)

Pagination - 分页

#### panel (1)

Panel - 面板

#### picker (1)

Picker - 选择器

#### popover (1)

Popover - 气泡卡片

#### popup (1)

Popup - 弹出层

#### progress (1)

Progress - 进度条

#### radio (1)

Radio - 单选框

#### rate (1)

Rate - 评分

#### refresh (1)

Refresh - 下拉刷新

#### result (1)

Result - 结果页

#### safe_area (1)

SafeArea - 安全区域

#### scroll_anchor (1)

ScrollAnchor - 滚动锚点

#### section (1)

Section - 区块

#### segmented (1)

Segmented - 分段控制器

#### selectcity (1)

SelectCity - 城市选择

#### selection (1)

Selection - 筛选

#### share (1)

Share - 分享

#### sidebar (1)

Sidebar - 侧边栏

#### skeleton (1)

Skeleton - 骨架屏

#### slider (1)

Slider - 滑块

#### space (1)

Space - 间距

#### statistic (1)

Statistic - 统计数值

#### step (1)

Step - 步骤条

#### stepper (1)

Stepper - 步进器

#### sugsearch (1)

SugSearch - 搜索建议

#### swipe_cell (1)

SwipeCell - 滑动单元格

#### swiper (1)

Swiper - 轮播

#### switch (1)

Switch - 开关

#### tabbar (1)

Tabbar - 标签栏

#### table (1)

Table - 表格

#### tag (1)

Tag - 标签

#### text_ellipsis (1)

TextEllipsis - 文本省略

#### time_counter (1)

TimeCounter - 计时器

#### toast (1)

Toast - 轻提示

#### tooltip (1)

Tooltip - 文字提示

#### tree (1)

Tree - 树形控件

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
