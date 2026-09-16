import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/rule_panel.dart';
import 'package:flutter/material.dart';

/// FloatingPanel 基础用法示例
///
/// 面板贴底,不传 anchors 时使用默认锚点 [100, 可用高度 * 0.6],
/// 拖动把手或内容区域改变高度,松手后吸附到最近锚点。
class FloatingPanelBasicExample extends StatelessWidget {
  const FloatingPanelBasicExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: SantoAppBar(title: 'FloatingPanel · 基础用法'),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const RulePanel(
                '不传 anchors 时使用默认锚点(100px 与可用高度 60%),拖动把手或内容区域改变高度,松手吸附到最近锚点',
                maxLines: 3,
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 360),
                  children: [
                    for (int i = 1; i <= 12; i++)
                      Container(
                        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
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
          ),
          SantoFloatingPanel(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: 20,
              itemBuilder: (context, index) => ListTile(
                dense: true,
                title: Text('面板内容 ${index + 1}'),
                subtitle: const Text('面板内列表可正常滚动'),
                trailing: const Icon(Icons.chevron_right, size: 18),
                onTap: () => SantoToast.show('点击了第 ${index + 1} 条', context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
