# Santo UI

企业级 Flutter 组件库。Santo(云上先途)根据现有市面上的开源项目进行的整合和优化,主要用于内部应用的开发和支持。提供统一主题定制、多主题 configId 注册、开箱即用的移动端组件。

## 参考项目

本组件库在设计和实现过程中参考了以下优秀的开源项目:

1. **[Bruno](https://github.com/LianjiaTech/bruno)** - 贝壳找房 Flutter 组件库
2. **[antd](https://github.com/ant-design/ant-design)** - Ant Design React 组件库
3. **[TDesign](https://github.com/Tencent/tdesign-flutter)** - 腾讯 TDesign Flutter 组件库
4. **[Vant](https://github.com/youzan/vant)** - 有赞 Vant 移动端组件库

感谢这些优秀项目的贡献,为我们提供了宝贵的参考和灵感。

## 组件覆盖

Santo UI 包含 **74** 组件,按示例目录分组如下:

### action_bar (1)

- **ActionBar** - 底部操作栏(图标+角标、五种按钮类型/自定义色/加载/禁用)

### actionsheet (1)

- **ActionSheet** - 动作面板

### appraise (1)

- **Appraise** - 评价

### avatar (1)

- **Avatar** - 头像

### backtop (1)

- **BackTop** - 回到顶部

### badge (1)

- **Badge** - 徽标

### bubble_text (1)

- **BubbleText** - 气泡文本

### button (1)

- **Button** - 按钮(五种类型、加载态、禁用态、图标按钮)

### calendar (1)

- **Calendar** - 日历

### card (1)

- **Card** - 卡片(内容展开/收起)

### cascader (1)

- **Cascader** - 级联选择

### cell (1)

- **Cell** - 单元格

### charts (1)

- **Charts** - 图表(折线图、环形图、进度条)

### checkbox (1)

- **Checkbox** - 复选框(卡片描边、半选态)

### collapse (1)

- **Collapse** - 折叠面板

### dialog (1)

- **Dialog** - 对话框

### divider (1)

- **Divider** - 分割线

### drawer (1)

- **Drawer** - 抽屉

### dropdown_menu (1)

- **DropdownMenu** - 下拉筛选菜单(单选/多选/范围/日期/自定义)

### empty (1)

- **Empty** - 空状态

### fab (1)

- **FAB** - 浮动按钮

### floating_panel (1)

- **FloatingPanel** - 浮动面板(顶部阴影、安全区避让)

### footer (1)

- **Footer** - 页脚

### form (1)

- **Form** - 表单(多种样式、分组)

### gallery (1)

- **Gallery** - 图片画廊

### guide (1)

- **Guide** - 引导

### highlight (1)

- **Highlight** - 关键词高亮

### image (1)

- **Image** - 图片

### input (1)

- **Input** - 输入框(label、必填标记、右侧插槽、多行输入)

### layout (1)

- **Layout** - 布局容器

### link (1)

- **Link** - 链接

### loading (1)

- **Loading** - 加载

### masonry (1)

- **Masonry** - 瀑布流(columns/gutter/verticalGutter/items)

### menu_bar (1)

- **MenuBar** - 菜单栏(红点/徽标、悬浮样式)

### message (1)

- **Message** - 消息提示

### navbar (1)

- **Navbar** - 导航栏

### noticebar (1)

- **NoticeBar** - 通知栏

### pagination (1)

- **Pagination** - 分页

### panel (1)

- **Panel** - 面板(圆角容器 + Header 标题/操作区 + 可滚动内容区)

### picker (1)

- **Picker** - 底部选择器(单列/多列/日期)

### popover (1)

- **Popover** - 气泡卡片

### popup (1)

- **Popup** - 弹出层

### progress (1)

- **Progress** - 进度条

### radio (1)

- **Radio** - 单选框(卡片描边)

### rate (1)

- **Rate** - 评分

### refresh (1)

- **Refresh** - 下拉刷新(四态、控制器、超时、触底加载)

### result (1)

- **Result** - 结果页

### safe_area (1)

- **SafeArea** - 安全区域

### scroll_anchor (1)

- **ScrollAnchor** - 滚动锚点

### section (1)

- **Section** - 区块

### segmented (1)

- **Segmented** - 分段控制器

### selectcity (1)

- **SelectCity** - 城市选择

### selection (1)

- **Selection** - 筛选组件

### share (1)

- **Share** - 分享

### sidebar (1)

- **Sidebar** - 侧边栏

### skeleton (1)

- **Skeleton** - 骨架屏(text/avatar/image/grid 预设、渐变扫光/闪烁动画)

### slider (1)

- **Slider** - 滑块

### space (1)

- **Space** - 间距(水平/垂直方向、三档预设 + 自定义 + 自动换行)

### statistic (1)

- **Statistic** - 统计数值

### step (1)

- **Step** - 步骤条(水平/垂直)

### stepper (1)

- **Stepper** - 步进器

### sugsearch (1)

- **SugSearch** - 搜索建议

### swipe_cell (1)

- **SwipeCell** - 滑动单元格(cell/left/right Panel、组内互斥)

### swiper (1)

- **Swiper** - 轮播

### switch (1)

- **Switch** - 开关

### tabbar (1)

- **Tabbar** - 标签栏(粘性、滑动)

### table (1)

- **Table** - 表格

### tag (1)

- **Tag** - 标签(自适应宽度、状态标签五态)

### text_ellipsis (1)

- **TextEllipsis** - 文本省略(rows/dots/expandText/collapseText、position 支持 start/middle/end)

### time_counter (1)

- **TimeCounter** - 计时器

### toast (1)

- **Toast** - 轻提示

### tooltip (1)

- **Tooltip** - 文字提示

### tree (1)

- **Tree** - 树形控件

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
  santo_ui: ^1.0.0
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

SantoBigMainButton(title: '提交', onTap: () {});
SantoToast.show('保存成功', context);
SantoDialogManager.showConfirmDialog(context,
    cancel: '取消', confirm: '确定', title: '提示', message: '确认删除?');
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
