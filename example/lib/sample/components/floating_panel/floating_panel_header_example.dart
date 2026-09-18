import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';

/// FloatingPanel 自定义标头与多锚点示例
///
/// header 插槽与把手条同属拖拽区域,整块都可拖动;
/// anchors 传入三档高度,面板可在三档之间吸附。
class FloatingPanelHeaderExample extends StatelessWidget {
  const FloatingPanelHeaderExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return SantoPageLayout(
      backgroundColor: const Color(0xFFF5F6FA),
      title: 'FloatingPanel · 自定义标头',
      // 内容自带滚动(Column + Expanded),由内层列表避让面板
      scrollable: false,
      children: <Widget>[
              ExampleIntro('floating_panel'),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 480),
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
      // 浮层面板:自定义标头,叠在内容之上
      overlay: SantoFloatingPanel(
          anchors: [100, screenHeight * 0.35, screenHeight * 0.85],
          header: Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 12, 8),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    '订单详情',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SantoButton(
                  type: SantoButtonType.normal,
                  text: '操作',
                  fontSize: 12,
                  insertPadding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 12,
                  ),
                  onTap: () => SantoToast.show('点击了标头操作', context),
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
                    '订单明细 $i',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
            ],
          ),
        ),
    );
  }
}
