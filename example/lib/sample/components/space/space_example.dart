import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// SantoSpace 间距示例
class SpaceExample extends StatelessWidget {
  Widget _demoBox(String text, [Color color = const Color(0xFF0984F9)]) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(title: 'Space 间距'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SantoPanel(
              title: '水平排列',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SantoSpace(
                    size: SantoSpaceSize.small,
                    children: [Text('小间距 8'), Text('|'), Text('8')],
                  ),
                  const SantoSpace.gap(12,
                      direction: SantoSpaceDirection.vertical),
                  const SantoSpace(
                    size: SantoSpaceSize.middle,
                    children: [Text('中间距 16'), Text('|'), Text('16')],
                  ),
                  const SantoSpace.gap(12,
                      direction: SantoSpaceDirection.vertical),
                  const SantoSpace(
                    size: SantoSpaceSize.large,
                    children: [Text('大间距 24'), Text('|'), Text('24')],
                  ),
                ],
              ),
            ),
            SantoPanel(
              title: '垂直排列',
              child: const SantoSpace(
                direction: SantoSpaceDirection.vertical,
                size: SantoSpaceSize.middle,
                children: [
                  Text('第一行'),
                  Text('第二行'),
                  Text('第三行'),
                ],
              ),
            ),
            SantoPanel(
              title: '自定义间距',
              child: SantoSpace(
                customSize: 32,
                children: [
                  _demoBox('32'),
                  _demoBox('32', const Color(0xFF00AE66)),
                  _demoBox('32', const Color(0xFFFAAD14)),
                ],
              ),
            ),
            SantoPanel(
              title: '自动换行 (wrap)',
              child: SantoSpace(
                wrap: true,
                size: SantoSpaceSize.small,
                children: List.generate(
                  12,
                  (i) => _demoBox('标签${i + 1}',
                      HSLColor.fromAHSL(1, i * 30.0, 0.6, 0.5).toColor()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
