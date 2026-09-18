# Changelog

所有重要变更都会记录在这个文件中。

格式基于 [Keep a Changelog](https://keepachangelog.com/),版本遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

## [1.0.0] - 2026-09-18

### 💥 Breaking Changes

- **组件重命名**: `SantoSelectionView` → `DropdownMenu`,避免与 Flutter Material DropdownMenu 命名冲突
- **间距体系重构**: 
  - 废弃自定义 `pageGap`
  - 改用规范间距: `iDefaultGap`(5) + `gapXs~gapXxl`(5/10/15/20/30/40)
  - 新增预设: `iGapAll/iGapAllSmall/iGapAllMiddle/iGapAllLarger/iGapHorizontal/iGapVertical`
- **SantoTagsPicker API 变更**: 从 Bean/Config 模式改为 `tags: List<String>` + 下标回调,与 `SantoSelectTag` API 对齐

### ✨ 新增组件

- **SantoSpace** - 间距组件(水平/垂直方向,三档预设 + 自定义 + 自动换行,参考 antd Space)
- **SantoMasonry** - 瀑布流组件(columns/gutter/verticalGutter/items,API 对齐 antd 6 Masonry)
- **SantoSkeleton** - 骨架屏(text/avatar/image/grid 预设、fromRowCol 自定义、渐变扫光/闪烁动画、延迟显示)
- **SantoHighlight** - 关键词高亮(sourceString/keywords/caseSensitive + 命中区间合并)
- **SantoTextEllipsis** - 文本省略(rows/dots/expandText/collapseText、position 支持 start/middle/end)
- **SantoActionBar** - 底部操作栏(图标+角标、五种按钮类型/自定义色/加载/禁用)
- **SantoPanel** - 面板组件(圆角容器 + Header 标题/操作区 + 可滚动内容区)

### 🔄 重构组件

- **DropdownMenu**(原 SantoSelectionView) - 下拉筛选菜单,支持单选/多选/范围/日期/自定义等多种筛选类型
- **SantoInputText** - 按 TDesign 重构:
  - 左侧 label 与必填标记
  - 右侧四类插槽(按钮/标识/图标/文字)
  - `SantoInputFormat` 限制输入类型
  - 支持多行输入(不再单独提供 textarea)
- **Checkbox/Radio** - 按 TDesign 重构:
  - 指示器尺寸 24px
  - 卡片描边
  - 半选态支持
  - 修复真机首次点击丢失问题
- **SantoRefresh** - 按 TDesign TPullDownRefresh 重写:
  - 四态切换(下拉前/下拉中/刷新中/完成)
  - 控制器支持
  - 超时机制
  - 触底加载
- **SantoSwipeCell** - 完全重写(API 参考 TDesign Flutter):
  - cell/left/right Panel(extentRatio)
  - disabled/opened/groupTag 组内互斥
  - onChange/controller 支持

### ⚡ 优化组件

- **底部安全区域规范**:
  - 贴底组件与半屏弹窗背景铺到屏幕底部
  - 内容在安全区之上避让且不可配置
  - `SantoPageLayout` 底部安全区改由 `SantoBottomSafeArea` 承接
- **SantoFloatingPanel**: 增加顶部阴影,底部安全区交由内容滚动避让,面板内容不再消费 `MediaQuery.padding`
- **SantoBottomDrawer**: 键盘弹起整体上移、修复 title 为空时的崩溃,Appraise 底部弹窗改为复用
- **MenuBar**: 红点/徽标定位修正(挂内容右上角),悬浮样式毛玻璃与滑动选中背景,MoreMenu 集成进组件
- **SantoTable**: 列宽与圆角边框修复
- **Collapse**: 内容折叠改为裁剪式高度动画
- **Card**: 内容展开/收起逻辑修正(折叠折成一行+行尾「展开」,展开全部内容+末行行尾「收起」)

### 🎨 主题与令牌

- 组件内容区统一取 `gapMd`,`SantoPageLayout` 内容区取 `iGapAllMiddle`
- Pad 主题同步删除 `pageGap` 覆盖
- 全局圆角统一为 12px: 主题令牌 radiusXs/Sm/Md/Lg 及各组件容器圆角

### 📚 示例与文档

- 同类示例合并单页(按钮/空态/标签等)
- 示例统一用 `SantoSection` 分块
- 示例页面一律使用 `Scaffold` + 自定义 `AppBar`,不再依赖 `SantoPageLayout`
- 文档站目录重组,组件文档统一为 `doc/components/<分类>/santo_<组件>.md`
- 新增 `AGENTS.md`: 底部安全区域处理、内容区/块间距取哪个令牌、示例页组织约定、API 变更版本标注规范
- 示例菜单项改为一等公民的圆角卡片(去分割线),移除 CardTitle 系列组件

### 🐛 Bug 修复

- 修复 `SantoNormalButton.outline` 未传 lineColor 时的空断言崩溃
- 修复配置类 getter 默认值回退单例导致的 Stack Overflow 问题
- 修复滚动列表消费 `MediaQuery.padding` 导致多余间距的问题

### 🔧 其他

- 仓库迁移至 GitHub: https://github.com/BingKui/santo_ui
- 完善 pubspec.yaml 元数据(repository/homepage/issue_tracker/documentation)
- 初始版本包含 8 大类 60+ 组件,附带 example 示例 App 和完整文档站
- 添加完整的组件分类列表到 README.md
- 建立 API 变更版本标注规范

---

## 参考

- [Keep a Changelog](https://keepachangelog.com/) - 变更日志格式规范
- [语义化版本 2.0.0](https://semver.org/lang/zh-CN/) - 版本号规范
