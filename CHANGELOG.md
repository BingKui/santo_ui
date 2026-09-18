# Changelog

所有重要变更都会记录在这个文件中。

格式基于 [Keep a Changelog](https://keepachangelog.com/),版本遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

## [1.0.0] - 2026-09-18

Santo UI v1.0.0 初始版本发布。包含 60+ 组件,涵盖基础、布局、表单、选择器、数据展示、反馈、导航、操作反馈和业务组件等 9 大分类。

### ✨ 核心特性

- **统一主题系统**: SantoThemeConfigurator 支持多 configId 注册,提供品牌色、圆角、间距等完整主题定制
- **规范间距体系**: `gapXs~gapXxl`(5/10/15/20/30/40) + `iGapAll/iGapAllSmall/iGapAllMiddle/iGapAllLarger` 预设
- **底部安全区规范**: 贴底组件背景铺到屏幕底部,内容在安全区之上避让且不可配置
- **全局圆角统一**: 12px 基准,主题令牌 radiusXs/Sm/Md/Lg 及各组件容器圆角

### 📦 组件清单

#### 基础组件 (6)

Button、Text、Icon、Link、Divider、Space

#### 布局组件 (7)

Layout、PageLayout、Panel、Section、Footer、SafeArea、Masonry

#### 表单组件 (9)

Input、Checkbox、Radio、Switch、Rate、Stepper、Slider、Form、Cell

#### 选择器组件 (6)

Picker、Cascader、DropdownMenu、Selection、SelectCity、Calendar

#### 数据展示组件 (12)

Table、Tag、Badge、Avatar、Progress、Statistic、Step、Collapse、Tree、Sidebar、Segmented、Pagination

#### 反馈组件 (8)

Toast、Dialog、Message、Loading、Result、Empty、Skeleton、Popover

#### 导航组件 (3)

Navbar、Tabbar、MenuBar

#### 操作反馈组件 (8)

Actionsheet、Drawer、Popup、FloatingPanel、BottomDrawer、Tooltip、Backtop、FAB

#### 业务组件 (17)

Card、Image、Gallery、Charts、Refresh、SwipeCell、Swiper、NoticeBar、ActionBar、Share、Appraise、Guide、Highlight、TextEllipsis、TimeCounter、TagsPicker、SugSearch

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
