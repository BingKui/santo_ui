# Santo UI

[English](README.md) | [简体中文](README_zh-CN.md)

企业级 Flutter 组件库。Santo(云上先途)根据现有市面上的开源项目进行的整合和优化,主要用于内部应用的开发和支持。提供统一主题定制、多主题 configId 注册、开箱即用的移动端组件。

## 参考项目

本组件库在设计和实现过程中参考了以下优秀的开源项目:

1. **[Bruno](https://github.com/LianjiaTech/bruno)** - 贝壳找房 Flutter 组件库
2. **[antd](https://github.com/ant-design/ant-design)** - Ant Design React 组件库
3. **[TDesign](https://github.com/Tencent/tdesign-flutter)** - 腾讯 TDesign Flutter 组件库
4. **[Vant](https://github.com/youzan/vant)** - 有赞 Vant 移动端组件库

感谢这些优秀项目的贡献,为我们提供了宝贵的参考和灵感。

## 图标数据源

图标组件 `SantoIcon` 的数据源为 **[Iconoir](https://github.com/iconoir-icons/iconoir)**(MIT 协议),
其 SVG 资源全量内置在 `assets/iconoir/`:常规描边(regular)1383 个、实心(solid)288 个,
按名称取用,详见 [SantoIcon 文档](doc/components/icon/santo_icon.md)。

## 组件覆盖

Santo UI 包含 **81** 组件,按示例菜单分为 7 个分组。

### 通用

| 组件 | 说明 |
| --- | --- |
| Button 按钮 | 统一按钮入口:类型/尺寸/颜色与变体/形状/图标/幽灵/危险/加载/禁用/block |
| Fab 悬浮按钮 | 页面悬浮操作入口 |
| Link 链接 | 文字链接 |
| Icon 图标 | 统一图标入口,内置 Iconoir 全量图标(1383 个),按名称取用 |
| Panel 面板 | 标题 + 操作 + 可滚动内容 |
| Section 区块 | 演示内容 + 标题描述 |
| SafeArea 安全区域 | 顶部与底部安全区域 |
| Descriptions 描述列表 | 单列/多列键值描述列表 |

### 布局

| 组件 | 说明 |
| --- | --- |
| Divider 分割线 | 实线与虚线分割 |
| Space 间距 | 元素间距 gap |
| Masonry 瀑布流 | 多列瀑布流布局 |
| Skeleton 骨架屏 | 加载占位骨架 |
| FloatingPanel 浮层面板 | 拖动吸附的底部面板 |
| AppLayout 应用布局 | 底部悬浮菜单栏 + 多页面 |
| PageLayout 页面布局 | 可配置导航栏 + 滚动内容容器 |

### 导航

| 组件 | 说明 |
| --- | --- |
| AppBar 导航栏 | 页面顶部导航 |
| Tabs 标签页 | 内容分类切换 |
| MenuBar 菜单栏 | 默认/悬浮两种样式 |
| Sidebar 侧边栏 | 侧边导航菜单 |
| Steps 步骤条 | 流程进度引导 |
| AnchorTab 锚点 | 锚点定位导航 |
| BackTop 返回顶部 | 长列表快速回顶 |
| Drawer 抽屉 | 侧边滑出面板 |
| Guide 引导 | 新手操作引导 |
| ActionBar 操作栏 | 底部操作栏 |

### 数据录入

| 组件 | 说明 |
| --- | --- |
| Input 输入框 | 文本输入 |
| Form 表单 | 表单集合 |
| Radio 单选框 | 单项选择 |
| Checkbox 多选框 | 多项选择 |
| Switch 开关 | 状态切换 |
| Rate 评分 | 星级打分 |
| Stepper 步进器 | 数量增减 |
| Slider 滑动输入条 | 范围数值选择 |
| SearchText 搜索框 | 搜索输入 |
| Picker 选择器 | 底部弹出选择 |
| Cascader 级联选择 | 多级联动选择 |
| DropdownMenu 下拉菜单 | 列表筛选下拉 |
| Selection 筛选 | 复杂条件筛选 |
| Tree 树形控件 | 树形结构选择 |
| Calendar 日历 | 日历日期选择 |
| CitySelection 城市选择 | 城市列表选择 |

### 数据展示

| 组件 | 说明 |
| --- | --- |
| Avatar 头像 | 用户头像展示 |
| Badge 徽标数 | 红点/数字角标 |
| Cell 单元格 | 列表标准行 |
| Card 卡片 | 标题/操作/元信息与阴影卡片容器 |
| Swiper 轮播 | 图片/内容轮播 |
| Collapse 折叠面板 | 可展开/收起内容 |
| Image 图片 | 增强图片组件 |
| Table 表格 | 数据表格展示 |
| Pagination 分页 | 页码切换 |
| Segmented 分段选择器 | 分段切换选择 |
| Statistic 统计数值 | 突出展示统计数字 |
| Tag 标签 | 标记与分类 |
| BubbleText 气泡文本 | 气泡文本 |
| Highlight 关键词高亮 | 关键词高亮文本 |
| TextEllipsis 文本省略 | 多行省略与展开收起 |
| Popover 气泡卡片 | 锚点弹出气泡 |
| SwipeCell 滑动单元格 | 列表项滑动操作 |
| NoticeBar 通知栏 | 滚动通知条 |
| Progress 进度条 | 线性/环形进度 |
| TimeCounter 计时器 | 倒计时/正计时 |
| Empty 空状态 | 空数据提示 |
| Footer 页脚 | 页面底部信息 |
| Gallery 图片浏览 | 大图预览 |

### 反馈

| 组件 | 说明 |
| --- | --- |
| Dialog 对话框 | 弹窗交互 |
| ActionSheet 动作面板 | 底部动作菜单 |
| Share 分享 | 分享面板 |
| Toast 轻提示 | 轻量反馈提示 |
| Message 全局提示 | 顶部消息通知 |
| Tooltip 文字提示 | 定位气泡提示 |
| OverlayWindow 悬浮窗 | 页面之上的独立窗口 |
| Loading 加载 | 统一加载入口,对标 antd Spin:尺寸/文案/延迟/包裹/全屏/进度/浮层 |
| Refresh 下拉刷新 | 下拉刷新/上拉加载 |
| Result 结果 | 操作结果反馈 |
| Appraise 评价 | 评分评价组件 |

### 数据图表

| 组件 | 说明 |
| --- | --- |
| BrokenLine 折线图 | 数据折线图 |
| Radar 雷达图 | 多维数据展示 |
| Funnel 漏斗图 | 漏斗数据展示 |
| Doughnut 环状图 | 环形数据图 |
| ProgressChart 进度图 | 进度展示图 |
| BarChart 柱状图 | 柱状数据图 |

完整清单与用法见 `doc/components/`;示例运行 `cd example && flutter run`。

## 工程结构

```shell
santo_ui/
├── lib/
│   ├── santo_ui.dart                 # 统一出口:import 'package:santo_ui/santo_ui.dart'
│   └── src/
│       ├── theme/                    # 主题系统(SantoThemeConfigurator + 各组件 Config)
│       └── components/               # 按分类组织的组件(74 个分类目录)
├── example/                          # 示例 App(分类导航 + 各组件示例页)
├── doc/                              # 文档站源文件
│   ├── santo_ui.md / start.md / theme.md / contribution.md / FAQ.md
│   └── components/<分类>/santo_<组件>.md
├── tool/gen_doc.dart                 # 参数表生成 + 文档校验脚本
└── test/                             # 单元测试(行为用例 + golden)
```

## 快速接入

```yaml
dependencies:
  santo_ui: ^1.1.0
```

```dart
import 'package:santo_ui/santo_ui.dart';

// 注册品牌主题(可选,不注册则使用默认主题)
SantoThemeConfigurator.instance.register(
  SantoAllThemeConfig(
    commonConfig: SantoCommonConfig(brandPrimary: const Color(0xFF1677FF)),
  ),
);

// 底部标签选择弹框:数据用标签文案列表,结果按下标回调
SantoTagsPicker(
  context: context,
  tags: <String>['洗衣机池', '机池', '电冰池'],
  maxSelectItemCount: 5,
  onConfirm: (List<int> indexes, String text) {
    print('选中下标:$indexes,输入:$text');
  },
).show();

SantoButton(
  text: '提交',
  type: SantoButtonType.primary,
  size: SantoButtonSize.large,
  block: true,
  onTap: () {},
);
SantoToast.show('保存成功', context);
// 一次性确认用静态方法,复杂弹窗用构造函数 + showDialog
SantoDialog.confirm(context, title: '提示', message: '确认删除?');

showDialog<void>(
  context: context,
  builder: (_) => SantoDialog(
    iconType: SantoDialogIconType.info,
    title: '拒绝理由',
    showInput: true,
    inputController: controller,
    closable: true,
    cancelText: '取消',
    okText: '确定',
  ),
);
```

## 主题与设计令牌

令牌集中在 `SantoCommonConfig`(颜色、字号、间距、圆角),用 `SantoThemeConfigurator.instance.register(SantoAllThemeConfig(...), configId: ...)` 注册,支持多 configId 并存(`SantoPadThemeConfig` 是 Pad 侧主题)。

| 令牌 | 默认值 | 说明 |
| --- | --- | --- |
| `brandPrimary` | `0xFF1677FF` | 品牌色,选中态/主按钮取它 |
| `radiusXs / Sm / Md / Lg` | 12 | 组件、卡片、弹层圆角 |
| `gapXs / gapSm / gapMd / gapLg / gapXl / gapXxl` | 5 / 10 / 15 / 20 / 20 / 40 | 规范间距,按 `iDefaultGap`(5)的倍数推导 |
| `hSpacingXs / Sm / Md / Lg / Xl / Xxl` | 5 / 10 / 15 / 20 / 20 / 40 | 横向间距 |
| `vSpacingXs / Sm / Md / Lg / Xl / Xxl` | 5 / 10 / 15 / 20 / 20 / 40 | 纵向间距 |

成块留白直接用预设常量:`iGapAllSmall / iGapAll / iGapAllMiddle / iGapAllLarger`(5 / 10 / 15 / 20)与 `iGapHorizontal / iGapVertical`。组件内容区统一取 `gapMd`,不再有 `pageGap` 这类自定义间距。

完整清单与用法见 `doc/components/`;示例运行 `cd example && flutter run`。

## 开发

```bash
flutter pub get
dart analyze lib example/lib         # 静态检查
flutter test test                    # 单元测试与 golden
dart run tool/gen_doc.dart --all     # 生成组件参数表
dart run tool/gen_doc.dart --check   # 校验组件均有文档
dart doc                             # API Reference(--output doc/api)
```

改组件前先读 [AGENTS.md](./AGENTS.md):底部安全区域怎么处理、内容区/块间距取哪个令牌、示例页怎么组织,那里有约定。

## 许可

MIT License.
