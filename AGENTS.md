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

组件内边距不要写魔法数字,统一取主题 `commonConfig`:

- 内容区四周留白与块间距用 `hSpacingMd` / `vSpacingMd`(默认 15),同一组件内保持同一档位;
- 更小的横向间距用 `hSpacingXs / hSpacingSm`,更大的用 `hSpacingLg`;
- 页面级留白(页面内容区、区块之间)才用 `pageGap`(默认 12)。

示例:`SantoTagsPicker` 的标签区、输入区、底部提交按钮的左右 15 取 `hSpacingMd`,上下 15 取 `vSpacingMd`,标签间距同样取 `hSpacingMd` / `vSpacingMd`。

## 验证

改完代码按需自查,不随意打包:

```bash
dart analyze lib example/lib   # 类型/静态检查
flutter test test              # 单测与 golden
```

需要跑起来看效果时由使用者自行启动示例 App。

## API 变更版本标注规范

组件发生以下变更时,**必须**在对应文档(`doc/components/<分类>/santo_<组件>.md`)中标注版本号:

### 需要标注的变更类型

1. **新增参数** - 组件构造函数新增可选/必填参数
2. **删除参数** - 组件移除已有参数(标记为 deprecated 后删除)
3. **参数类型变更** - 参数类型发生变化(如 `String` → `int`)
4. **参数默认值变更** - 参数的默认值发生改变
5. **组件删除** - 整个组件从库中移除

### 标注格式

在文档的"API 参考"或"参数说明"章节末尾添加版本变更记录:

```markdown
## 版本变更

### v1.1.0
- **新增**: `showLabel` 参数,控制是否显示 label
- **删除**: `oldParam` 参数(已废弃,请使用 `newParam`)
- **变更**: `maxCount` 默认值从 `10` 改为 `20`

### v1.0.0
- 初始版本发布
```

### 标注位置

- **组件文档**: `doc/components/<分类>/santo_<组件>.md` 的末尾添加"版本变更"章节
- **CHANGELOG.md**: 同步记录到对应版本的变更日志中
- **组件注释**: 在组件构造函数的 dart doc 中标注 `@since v1.x.x`

### 示例

```dart
/// 下拉菜单组件
/// 
/// @since v1.0.0
/// @changed v1.1.0 新增 showLabel 参数
class DropdownMenu extends StatefulWidget {
  /// 是否显示 label
  /// 
  /// @since v1.1.0
  final bool showLabel;
  
  DropdownMenu({
    Key? key,
    this.showLabel = true,  // @since v1.1.0
    // ...
  }) : super(key: key);
}
```

### 注意事项

- 版本号格式遵循语义化版本(SemVer): `major.minor.patch`
- 破坏性变更(breaking change)必须升级 major 版本号
- 新增功能(minor)和修复(patch)分别升级对应的版本号
- 每次发布到 pub.dev 前,确保所有 API 变更都已标注版本
