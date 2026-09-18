---
order: 1
title: Santo
---

### Santo 是什么？

Santo 是基于一整套设计体系的 Flutter 组件库,提供 70+ 高质量组件,覆盖表单、导航、反馈、数据展示等常见场景。

### 特征

- 提炼自企业级移动端产品的交互和视觉风格
- 开箱即用的高质量 Flutter 组件(70+)
- 提供满足业务差异的主题定制能力
- 完善的组件文档和示例
- 设计工具赋能开发全链路

### 组件分类

- **基础组件**: Badge徽标、Avatar头像、Button按钮、Icon图标、Link链接
- **布局组件**: Cell单元格、Divider分割线、Space间距、Section区块、SafeArea安全区域
- **导航组件**: AppBar导航栏、TabBar标签栏、Sidebar侧边栏、DropdownMenu下拉菜单、Pagination分页
- **表单组件**: Input输入框、Checkbox复选框、Radio单选框、Switch开关、Slider滑块、Stepper步进器、Segmented分段选择器
- **反馈组件**: Toast轻提示、Message消息、Dialog对话框、Loading加载、Result结果页、Empty空状态、Progress进度条
- **数据展示**: Table表格、Tree树形控件、Collapse折叠面板、Statistic统计数值、Swiper轮播图、Gallery大图预览
- **操作反馈**: ActionSheet动作面板、Drawer抽屉、FloatingPanel悬浮面板、Popover气泡弹出框、Tooltip工具提示、Fab悬浮按钮
- **选择器**: Picker选择器、Cascader级联选择器、DatePicker日期选择器、TagsPicker标签选择器
- **其他**: Refresh下拉刷新、BackTop返回顶部、TimeCounter计时器、Calendar日历、Highlight高亮、NoticeBar通知栏

### 适配 Flutter SDK 版本

| Santo 版本 | Flutter SDK 版本 |  
| ---------- | ---------------- |  
| 1.0.0      | 1.22.4           |  
| 2.0.0      | 2.2.2            |  
| 2.1.1 (支持空安全) | 2.2.2     |  
| 2.2.0      | 2.10.5           |  
| 3.0.0      | 3.0.3            |  
| 3.1.0      | 3.3.0            |  
| 3.2.0      | 3.3.0            |  

> 当前最新版本请参考 pubspec.yaml 或 GitHub Release 页面  

### 接入

Flutter 工程中 `pubspec.yaml` 文件里加入以下依赖：

```yaml
dependencies:
  santo_ui: version
```

### 代码引入

```dart
import 'package:santo_ui/santo_ui.dart';
```

### 主题定制

在 Flutter 工程目录 `main.dart` 中加如下注册方法：

```dart
SantoInitializer.register(allThemeConfig:TestConfigUtils.defaultAllConfig);
```

详见 [主题定制](./theme)

### 链接

- [首页](../)
- [所有组件](../widgets)
- [设计理念](https://mp.weixin.qq.com/s?__biz=MzIyODcxODY0OA==&mid=2247486048&idx=1&sn=0cc95bd85a54ce0f39f6247d15618ae8&chksm=e84ceb37df3b62216b34c7be041229630eca3d7c4fd3823ebf0520a9f2c99ed2cdf3e677904b&mpshare=1&scene=1&srcid=11012tvWvcYunVGfiPa8EfCT&sharer_sharetime=1635751229200&sharer_shareid=dbde8f595d5b99a8f5cfb27122964615&version=3.1.16.90294)
- [快速接入](./start)
- [主题定制](./theme)
- [常见问题](./faq)
- [Sketch 设计指引](./sketch)

- [设计物料下载](https://santo-ui.example.com/download/sketch)

### 谁在使用

覆盖贝壳 B 端所有业务线，服务贝壳 10+ App ，组件累积引用超 1w 次。

<blockquote><p style="color:#666666">
  <font size="2">如果你有意愿接入Santo，或者你公司和产品使用了Santo，欢迎到 <a href="https://github.com/LianjiaTech/santo_ui/issues/2">这里</a> 留言。</font></p></blockquote>

### 如何贡献

请阅读 [贡献指南](./contribution)。如果你希望参与贡献，欢迎 [Pull Request](https://github.com/LianjiaTech/santo_ui/pulls)，或给我们 [报告 Bug](https://github.com/LianjiaTech/santo_ui/issues/new)。
