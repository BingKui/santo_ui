# AGENTS.md

santo_ui 组件库开发约定。新增/改动组件前先读本文件。

## 底部安全区域(贴底组件)

适用对象:自绘底面的贴底组件与半屏弹窗,如 `SantoFloatingPanel`、`SantoBottomDrawer`、`SantoTagsPicker`(基类 `CommonTagsPicker`)。

三条规则:

1. 组件背景(白底/填充色)必须铺到屏幕底部,**覆盖**整个底部安全区域,不能露出透明带或页面底色。
2. 内容区在安全区之上避让,最后一段内容不被 Home Indicator / 手势条遮挡。
3. 是否预留安全区**不可配置**,固定生效,不暴露开关参数。

两种实现方式,按组件形态二选一:

- **背景包住内容**(内容整体上抬):白底 `Container` 外层,内层 `Padding(bottom: MediaQuery.paddingOf(context).bottom)` 再放约束与内容。参考 `lib/src/components/picker/santo_tags_common_picker.dart`。
- **背景铺满,内容自行避让**(内容撑到面板底部,滚动时最后一段停在安全区之上):把内容的 MediaQuery padding 改写为"仅底部安全区":
  `MediaQuery(data: MediaQuery.of(context).copyWith(padding: EdgeInsets.only(bottom: safeAreaBottom)), child: content)`。参考 `lib/src/components/floating_panel/santo_floating_panel.dart`。

坑:`ListView` / `GridView` 在 `padding == null` 时会自动消费 `MediaQuery.padding`,凭空多出顶部/底部间距。不需要它消费时显式传 `padding: EdgeInsets.zero`。

## 内容区间距取主题变量

组件内边距不要写魔法数字,统一取主题 `commonConfig`;内容区四周留白用 `pageGap`,以 `gap` 命名:

```dart
double get gap => SantoThemeConfigurator.instance.getConfig().commonConfig.pageGap;
```

横向小间距用 `hSpacingXs / hSpacingSm / hSpacingMd / hSpacingLg`,纵向用 `vSpacingMd`。示例:`SantoTagsPicker` 的输入区 padding、底部按钮 padding 取 `gap`。

同一组件内的间距若沿用既有实现(如标签网格的 `hSpacingLg` / `vSpacingLg`),保持原样不动,不要顺手改成 `gap`。

## 验证

改完代码按需自查,不随意打包:

```bash
dart analyze lib example/lib   # 类型/静态检查
flutter test test              # 单测与 golden
```

需要跑起来看效果时由使用者自行启动示例 App。
