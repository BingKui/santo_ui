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
