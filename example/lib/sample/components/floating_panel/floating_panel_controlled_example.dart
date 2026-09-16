import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/rule_panel.dart';
import 'package:flutter/material.dart';

/// FloatingPanel 受控高度与开关示例
///
/// height 受控:拖动结束后通过 onHeightChange 回传高度,外部按钮也能直接改高度;
/// magnetic、draggable、contentDraggable 三个开关切换后便于对比拖拽行为。
class FloatingPanelControlledExample extends StatefulWidget {
  const FloatingPanelControlledExample({Key? key}) : super(key: key);

  @override
  State<FloatingPanelControlledExample> createState() =>
      _FloatingPanelControlledExampleState();
}

class _FloatingPanelControlledExampleState
    extends State<FloatingPanelControlledExample> {
  static const List<double> _anchors = [140, 260, 420];

  double _height = 260;
  bool _magnetic = true;
  bool _draggable = true;
  bool _contentDraggable = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: SantoAppBar(title: 'FloatingPanel · 受控与开关'),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const RulePanel(
                'height 受控由外部驱动,拖动结束 onHeightChange 回传吸附后高度;下方按钮与开关可直接对比三种拖拽配置',
                maxLines: 3,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                child: Text(
                  '当前高度 ${_height.toStringAsFixed(0)}px',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    SantoNormalButton.outline(
                      text: '展开',
                      fontSize: 12,
                      insertPadding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 12,
                      ),
                      onTap: () => setState(() => _height = _anchors.last),
                    ),
                    SantoNormalButton.outline(
                      text: '收起',
                      fontSize: 12,
                      insertPadding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 12,
                      ),
                      onTap: () => setState(() => _height = _anchors.first),
                    ),
                    SantoNormalButton.outline(
                      text: '磁力吸附 ${_magnetic ? "开" : "关"}',
                      fontSize: 12,
                      insertPadding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 12,
                      ),
                      onTap: () => setState(() => _magnetic = !_magnetic),
                    ),
                    SantoNormalButton.outline(
                      text: '可拖拽 ${_draggable ? "开" : "关"}',
                      fontSize: 12,
                      insertPadding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 12,
                      ),
                      onTap: () => setState(() => _draggable = !_draggable),
                    ),
                    SantoNormalButton.outline(
                      text: '内容可拖拽 ${_contentDraggable ? "开" : "关"}',
                      fontSize: 12,
                      insertPadding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 12,
                      ),
                      onTap: () => setState(
                        () => _contentDraggable = !_contentDraggable,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SantoFloatingPanel(
            anchors: _anchors,
            height: _height,
            magnetic: _magnetic,
            draggable: _draggable,
            contentDraggable: _contentDraggable,
            onHeightChange: (height) => setState(() => _height = height),
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                for (int i = 1; i <= 3; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Text(
                      '面板内容 $i:内容不足一屏时可直接拖拽内容区',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
