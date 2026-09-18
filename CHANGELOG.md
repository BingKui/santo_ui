## Unreleased

### 主题与令牌

* 去掉自定义间距 `pageGap`,改用规范间距:`iDefaultGap`(5)+ `gapXs~gapXxl`(5/10/15/20/20/40),并提供 `iGapAll / iGapAllSmall / iGapAllMiddle / iGapAllLarger / iGapHorizontal / iGapVertical` 预设
* 组件内容区统一取 `gapMd`,`SantoPageLayout` 内容区取 `iGapAllMiddle`;Pad 主题同步删除 `pageGap` 覆盖

### 组件

* SantoTagsPicker:原「多选标签弹框」与「带输入框选择器」合并为一个组件,数据改为 `tags: List<String>` + 下标回调(与 `SantoSelectTag` 对齐),支持多选/单选、选择上限、等分/流式布局、可选输入框与底部提交按钮
* SantoInputText 按 TDesign 重构:左侧 label 与必填标记、右侧按钮/标识/图标/文字插槽、`SantoInputFormat` 限制输入类型、多行输入(不再单独提供 textarea 组件)
* Checkbox/Radio 按 TDesign 重构(指示器尺寸、卡片描边、半选态),修复真机首次点击丢失
* 底部安全区域统一规范:贴底组件与半屏弹窗背景铺到屏幕底部、内容在安全区之上避让,且不可配置;`SantoPageLayout` 底部安全区改由 `SantoBottomSafeArea` 承接
* SantoRefresh 按 TDesign 下拉刷新重写(四态 + 控制器 + 超时 + 触底加载)
* SantoFloatingPanel:增加顶部阴影,底部安全区交由内容滚动避让;SantoFloatingPanel 面板内容不再消费 `MediaQuery.padding`
* SantoBottomDrawer:键盘弹起整体上移、修复 title 为空时的崩溃;Appraise 底部弹窗改为复用 `SantoBottomDrawer`
* MenuBar:红点/徽标定位修正(挂内容右上角),悬浮样式毛玻璃与滑动选中背景,更多菜单集成进组件
* SantoTable 列宽与圆角边框修复;Collapse 内容折叠改为裁剪式高度动画;Card 内容展开/收起逻辑修正
* 示例菜单项改为一等公民的圆角卡片(去分割线),移除 CardTitle 系列组件

### 示例与文档

* 同类示例合并单页(按钮/空态/标签等),示例统一用 `SantoSection` 分块
* 文档站目录重组,组件文档统一为 `doc/components/<分类>/santo_<组件>.md`
* 新增 `AGENTS.md`:底部安全区域处理、内容区/块间距取哪个令牌、示例页组织约定

## 0.1.0

* 参照 Bruno 完成组件库整体移植:主题系统(SantoThemeConfigurator 多 configId)+ 8 大类 58+ 组件
* 包含:基础布局/按钮/文本标签/表单/弹窗浮层/选择器/信息展示与图表组件
* 附带 example 示例 App(分类导航 + 主题演示)、doc/ 组件文档站源文件、tool/gen_doc.dart 参数表生成脚本
* 全局圆角统一为 12px:主题令牌 radiusXs/Sm/Md/Lg 及各组件容器圆角;保留圆形元素(日历选中、徽标、光标)与图表数据标记的原始形状
* 新增 SantoPanel 面板组件(圆角容器 + Header 标题/操作区 + 可滚动内容区)及 SantoPanelConfig 主题配置
* 修复 SantoNormalButton.outline 未传 lineColor 时的空断言崩溃
* 新增 SantoSpace 间距组件(水平/垂直方向,三档预设间距 + 自定义间距 + 自动换行,参考 antd Space)
* 新增 SantoMasonry 瀑布流组件(columns/gutter/verticalGutter/items,API 对齐 antd 6 Masonry)
* 重写 SantoSwipeCell 滑动单元格(API 参考 TDesign Flutter):cell/left/right Panel(extentRatio)、disabled、opened、groupTag 组内互斥、onChange、controller
* 新增 SantoSkeleton 骨架屏组件(text/avatar/image/grid 预设主题、fromRowCol 自定义行列、渐变扫光/闪烁动画、延迟显示,API 参考 TDesign Flutter Skeleton)
* 新增 SantoHighlight 关键词高亮组件(sourceString/keywords/caseSensitive + 命中区间合并,高亮样式与自定义片段,参考 Vant Highlight)
* 新增 SantoTextEllipsis 文本省略组件(rows/dots/expandText/collapseText、position 支持 start/middle/end、TextPainter 二分测量保证省略号与操作同行,参考 Vant TextEllipsis)
* 新增 SantoActionBar 底部操作栏(SantoActionBarIcon 图标+角标、SantoActionBarButton 五种类型/自定义色/加载/禁用,按钮自动平分宽度与首尾圆角,安全区适配,参考 Vant ActionBar)
