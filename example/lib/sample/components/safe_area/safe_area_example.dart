import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';

/// SantoSafeArea 安全区域示例
class SafeAreaExample extends StatefulWidget {
  const SafeAreaExample({Key? key}) : super(key: key);

  @override
  State<SafeAreaExample> createState() => _SafeAreaExampleState();
}

class _SafeAreaExampleState extends State<SafeAreaExample> {
  bool _top = true;
  bool _bottom = true;

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(      title: 'SafeArea 安全区域',
      children: <Widget>[
        ExampleIntro('safe_area'),
        SantoSection(
          title: '顶部与底部开关',
          description: '两个开关分别控制是否避让状态栏与底部 Home Indicator',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('顶部安全区域'),
                  const Spacer(),
                  Switch(
                    value: _top,
                    onChanged: (v) => setState(() => _top = v),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('底部安全区域'),
                  const Spacer(),
                  Switch(
                    value: _bottom,
                    onChanged: (v) => setState(() => _bottom = v),
                  ),
                ],
              ),
            ],
          ),
        ),
        SantoSection(
          title: '效果',
          description: '下方色块贴住屏幕边缘,开启后会被状态栏/Home Indicator 区域顶开;'
              '当前 top: $_top,bottom: $_bottom。',
          child: SizedBox(
            height: 160,
            child: SantoSafeArea(
              top: _top,
              bottom: _bottom,
              child: Container(
                color: const Color(0xFFE6F4FF),
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(12),
                child: const Text('内容区域'),
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }
}
