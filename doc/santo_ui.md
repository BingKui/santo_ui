---
order: 1
title: Santo
---

### Santo 是什么？

Santo 是一套企业级 Flutter 组件库,提供 70+ 组件,覆盖表单、导航、反馈、数据展示等常见场景。

### 特征

- 提炼自企业级移动端产品的交互与视觉风格
- 开箱即用的 Flutter 组件(70+),含移动端底部安全区域适配
- 统一设计令牌(颜色/字号/间距/圆角),支持多主题 configId 并行注册
- 配套示例 App 与组件文档,组件参数表由脚本生成、可校验

### 组件分类

- **基础组件**:Badge 徽标、Avatar 头像、Button 按钮、Icon 图标、Link 链接、Image 图片
- **布局组件**:Cell 单元格、Divider 分割线、Space 间距、Section 区块、SafeArea 安全区域、Panel 面板
- **导航组件**:AppBar 导航栏、TabBar 标签栏、Sidebar 侧边栏、MenuBar 底部菜单栏、Pagination 分页、Anchor 锚点
- **表单组件**:Input 输入框、Checkbox 复选框、Radio 单选框、Switch 开关、Slider 滑块、Stepper 步进器、Segmented 分段选择器、SearchText 搜索框
- **反馈组件**:Toast 轻提示、Message 消息、Dialog 对话框、Loading 加载、Result 结果页、Empty 空状态、Progress 进度条、Refresh 下拉刷新
- **数据展示**:Table 表格、Tree 树形控件、Collapse 折叠面板、Statistic 统计数值、Swiper 轮播图、Masonry 瀑布流、Skeleton 骨架屏、Gallery 大图预览
- **操作反馈**:ActionSheet 动作面板、Drawer 抽屉、BottomDrawer 底部弹窗、FloatingPanel 浮层面板、Popover 气泡弹出框、Tooltip 工具提示、Fab 悬浮按钮、ActionBar 底部操作栏
- **选择器**:Picker 选择器、Cascader 级联选择器、DatePicker 日期选择器、TagsPicker 标签选择器、Selection 筛选器
- **其他**:BackTop 返回顶部、TimeCounter 计时器、Calendar 日历、Highlight 高亮、Notice 通知栏、Guide 引导、Appraise 评价、Share 分享

### 设计令牌

主题令牌集中定义在 `SantoCommonConfig`:

| 令牌 | 默认值 | 说明 |
| --- | --- | --- |
| `brandPrimary` | `0xFF1677FF` | 品牌色 |
| `radiusXs / Sm / Md / Lg` | 12 | 圆角 |
| `gapXs / gapSm / gapMd / gapLg / gapXl / gapXxl` | 5 / 10 / 15 / 20 / 20 / 40 | 规范间距,按 `iDefaultGap`(5)倍数推导 |
| `hSpacing* / vSpacing*` | 5 / 10 / 15 / 20 / 20 / 40 | 横向 / 纵向间距 |

成块留白用预设常量:`iGapAllSmall`(5)、`iGapAll`(10)、`iGapAllMiddle`(15)、`iGapAllLarger`(20)、`iGapHorizontal`、`iGapVertical`。

### 适配 Flutter SDK 版本

| Santo 版本 | Dart SDK | Flutter SDK |
| ---------- | -------- | ----------- |
| 0.1.0      | ^3.13.3  | >=3.10.0    |

> 版本以 `pubspec.yaml` 为准。

### 接入

Flutter 工程的 `pubspec.yaml` 中加入依赖:

```yaml
dependencies:
  santo_ui: ^0.1.0
```

### 代码引入

```dart
import 'package:santo_ui/santo_ui.dart';
```

### 主题定制

在 `main.dart` 里注册主题(不注册则使用默认主题):

```dart
SantoThemeConfigurator.instance.register(
  SantoAllThemeConfig(
    commonConfig: SantoCommonConfig(brandPrimary: const Color(0xFF1677FF)),
  ),
);
```

需要多套主题并存时给 `register` 传 `configId`。详见 [主题定制](./theme)。

### 链接

- [所有组件](./components)
- [快速接入](./start)
- [主题定制](./theme)
- [常见问题](./faq)
- [开发约定](../AGENTS.md)
- [Sketch 设计指引](./sketch)

### 如何贡献

请阅读 [贡献指南](./contribution)。
