import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// SantoMasonry 瀑布流示例
class MasonryExample extends StatelessWidget {
  static const List<double> _heights = [120, 80, 160, 60, 100, 140, 90, 180, 70];

  static const List<Color> _colors = [
    Color(0xFF1677FF),
    Color(0xFF52C41A),
    Color(0xFFFAAD14),
    Color(0xFFFA541C),
    Color(0xFF722ED1),
  ];

  Widget _card(int index) {
    return Container(
      height: _heights[index % _heights.length],
      decoration: BoxDecoration(
        color: _colors[index % _colors.length],
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        'Item ${index + 1}',
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SantoSection(
            title: '两列瀑布流 (gutter: 8)',
            description: '子项按最短列优先排布，高度不一时自动错落填充',
            child: SizedBox(
              height: 340,
              child: SingleChildScrollView(
                child: SantoMasonry(
                  columns: 2,
                  gutter: 8,
                  items: List.generate(6, _card),
                ),
              ),
            ),
          ),
          SantoSection(
            title: '三列瀑布流 (gutter: 16)',
            description: '显式传入 verticalGutter，可与 gutter 使用不同间距',
            child: SizedBox(
              height: 320,
              child: SingleChildScrollView(
                child: SantoMasonry(
                  columns: 3,
                  gutter: 16,
                  verticalGutter: 16,
                  items: List.generate(9, _card),
                ),
              ),
            ),
          ),
          SantoSection(
            title: '四列瀑布流 (gutter: 8)',
            description: 'columns 设为 4 后列宽变窄，外层容器限定高度可滚动',
            child: SizedBox(
              height: 260,
              child: SingleChildScrollView(
                child: SantoMasonry(
                  columns: 4,
                  gutter: 8,
                  items: List.generate(12, _card),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
