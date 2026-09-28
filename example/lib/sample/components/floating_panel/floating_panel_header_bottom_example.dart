import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';

/// FloatingPanel 标头底部插槽示例
///
/// headerBottom 展示在标头之下、内容区之上,用法同 PageLayout 的 header:
/// 不做内边距、撑满宽度,可放筛选标签、TabBar 等任意组件;
/// 与把手条/标头同属拖拽区域。
class FloatingPanelHeaderBottomExample extends StatefulWidget {
  const FloatingPanelHeaderBottomExample({Key? key}) : super(key: key);

  @override
  State<FloatingPanelHeaderBottomExample> createState() =>
      _FloatingPanelHeaderBottomExampleState();
}

class _FloatingPanelHeaderBottomExampleState
    extends State<FloatingPanelHeaderBottomExample> {
  late final List<double> _anchors;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final screenHeight = MediaQuery.of(context).size.height;
    // 最小锚点须容得下标头整体高度(把手条 + 标题/描述 + 筛选标签插槽),
    // 否则内容区被压成 0 会报 RenderFlex overflow
    _anchors = [200, screenHeight * 0.35, screenHeight * 0.85];
  }

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      backgroundColor: const Color(0xFFF5F6FA),
      title: 'FloatingPanel · 标头底部插槽',
      // 内容自带滚动(Column + Expanded),由内层列表避让面板
      scrollable: false,
      children: <Widget>[
        ExampleIntro('floating_panel'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 460),
            children: [
              for (int i = 1; i <= 12; i++)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '背景内容卡片 $i',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
            ],
          ),
        ),
      ],
      // 浮层面板:标头下方放筛选标签插槽
      overlay: SantoFloatingPanel(
        anchors: _anchors,
        title: '筛选条件',
        desc: '按标签筛选下方内容',
        headerBottom: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final label in const ['全部', '进行中', '已完成', '已取消'])
                SantoTag(
                  text: label,
                  selectable: true,
                  initSelected: label == '全部',
                  onSelectedChange: (selected) => SantoToast.show(
                    '「$label」选中态：$selected',
                    context,
                  ),
                ),
            ],
          ),
        ),
        child: ListView(
          children: [
            for (int i = 1; i <= 16; i++)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Text(
                  '筛选项 $i',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
