# Changelog

所有重要变更都会记录在这个文件中。

格式基于 [Keep a Changelog](https://keepachangelog.com/),版本遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

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
