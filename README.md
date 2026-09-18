# Santo UI

企业级 Flutter 组件库。提供统一主题定制、多主题 configId 注册、开箱即用的移动端组件。

## 工程结构

```
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

## 组件覆盖

| 分类 | 内容 |
| --- | --- |
| 基础与布局 | AppBar/搜索导航栏、TabBar、Sidebar、Collapse、Divider/虚线、阴影卡片、Panel、Section、Space、SafeArea、Cell、ScrollAnchor |
| 按钮 | 大主/幽灵/描边按钮、小按钮、图标按钮、按钮组/吸底面板、ActionBar |
| 文本与标签 | 可展开/省略/高亮文本、气泡文本、通知栏、Tag 系列(普通/状态/可删/可选中/自定义) |
| 表单 | InputText(必填标记、前后缀、按钮/图标/文字插槽、输入类型限制、多行)、Checkbox/Radio、Slider、Switch、Stepper、Segmented、SearchText、表单项与分组 |
| 弹窗与浮层 | Dialog 系列、Drawer/BottomDrawer、FloatingPanel、Popover、Tooltip、ActionSheet、Toast、Loading、Message、Share |
| 选择器 | 底部滚轮 Picker、多级联动、日期/区间/时间、城市选择、TagsPicker(标签选择,支持多选/单选/输入框)、筛选器系列 |
| 数据展示 | Table、Tree、Statistic、Progress/图表系列、Swiper、Masonry、Skeleton、Gallery、Empty/Result、Appraise |
| 其他 | Refresh 下拉刷新、BackTop、TimeCounter、Calendar、Guide 引导、Fab、Badge/Avatar、Image |

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
