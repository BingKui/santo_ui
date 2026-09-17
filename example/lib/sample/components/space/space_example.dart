import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// SantoSpace 间距示例
class SpaceExample extends StatelessWidget {
  Widget _demoBox(String text, [Color color = const Color(0xFF1677FF)]) {
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
    return SantoPageLayout(      title: 'Space 间距',
      children: <Widget>[
        SantoSection(
          title: '水平排列',
          description: 'size 提供 small、middle、large 三档间距',
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
        SantoSection(
          title: '垂直排列',
          description: 'direction 设为 vertical 后子元素自上而下排列',
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
        SantoSection(
          title: '自定义间距',
          description: 'customSize 优先级高于 size，直接传入具体间距值',
          child: SantoSpace(
            customSize: 32,
            children: [
              _demoBox('32'),
              _demoBox('32', const Color(0xFF52C41A)),
              _demoBox('32', const Color(0xFFFAAD14)),
            ],
          ),
        ),
        SantoSection(
          title: '自动换行 (wrap)',
          description: 'wrap 开启后单行放不下自动换行，仅水平方向生效',
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
    );
  }
}
