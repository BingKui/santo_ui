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

Santo UI 包含 **60+** 组件,涵盖以下分类:

### 基础组件

- **Button** - 按钮(五种类型、加载态、禁用态、图标按钮)
- **Text** - 文本样式
- **Icon** - 图标
- **Link** - 链接
- **Divider** - 分割线
- **Space** - 间距

### 布局组件

- **Layout** - 布局容器
- **PageLayout** - 页面布局
- **Panel** - 面板
- **Section** - 区块
- **Footer** - 页脚
- **SafeArea** - 安全区域
- **Masonry** - 瀑布流

### 表单组件

- **Input** - 输入框(label、必填标记、右侧插槽、多行输入)
- **Checkbox** - 复选框(卡片描边、半选态)
- **Radio** - 单选框(卡片描边)
- **Switch** - 开关
- **Rate** - 评分
- **Stepper** - 步进器
- **Slider** - 滑块
- **Form** - 表单项(多种样式、分组)
- **Cell** - 单元格

### 选择器组件

- **Picker** - 底部选择器(单列/多列/日期)
- **Cascader** - 级联选择
- **DropdownMenu** - 下拉筛选菜单(单选/多选/范围/日期/自定义)
- **Selection** - 筛选组件
- **SelectCity** - 城市选择
- **Calendar** - 日历

### 数据展示组件

- **Table** - 表格
- **Tag** - 标签(自适应宽度、状态标签)
- **Badge** - 徽标
- **Avatar** - 头像
- **Progress** - 进度条
- **Statistic** - 统计数值
- **Step** - 步骤条(水平/垂直)
- **Collapse** - 折叠面板
- **Tree** - 树形控件
- **Sidebar** - 侧边栏
- **Segmented** - 分段控制器
- **Pagination** - 分页

### 反馈组件

- **Toast** - 轻提示
- **Dialog** - 对话框
- **Message** - 消息提示
- **Loading** - 加载
- **Result** - 结果页
- **Empty** - 空状态
- **Skeleton** - 骨架屏
- **Popover** - 气泡卡片

### 导航组件

- **Navbar** - 导航栏
- **Tabbar** - 标签栏(粘性、滑动)
- **MenuBar** - 菜单栏(红点/徽标、悬浮样式)

### 操作反馈组件

- **Actionsheet** - 动作面板
- **Drawer** - 抽屉
- **Popup** - 弹出层
- **FloatingPanel** - 浮动面板(顶部阴影、安全区避让)
- **BottomDrawer** - 底部抽屉
- **Tooltip** - 文字提示
- **Backtop** - 回到顶部
- **FAB** - 浮动按钮

### 业务组件

- **Card** - 卡片(内容展开/收起)
- **Image** - 图片
- **Gallery** - 图片画廊
- **Charts** - 图表(折线图、环形图、进度条)
- **Refresh** - 下拉刷新(四态、控制器、超时)
- **SwipeCell** - 滑动单元格(组内互斥)
- **Swiper** - 轮播
- **NoticeBar** - 通知栏
- **ActionBar** - 底部操作栏
- **Share** - 分享
- **Appraise** - 评价
- **Guide** - 引导
- **Highlight** - 关键词高亮
- **TextEllipsis** - 文本省略
- **TimeCounter** - 计时器
- **TagsPicker** - 标签选择器
- **SugSearch** - 搜索建议

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
