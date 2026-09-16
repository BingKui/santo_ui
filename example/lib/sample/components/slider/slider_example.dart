import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// 滑块示例页面
class SliderExample extends StatefulWidget {
  const SliderExample({Key? key}) : super(key: key);

  @override
  _SliderExampleState createState() => _SliderExampleState();
}

class _SliderExampleState extends State<SliderExample> {
  double _singleValue = 30;
  double _singleValue2 = 60;
  List<double> _rangeValue = [20, 80];
  List<double> _rangeValue2 = [40, 60];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(title: 'Slider 示例'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 基础单值滑块
            SantoPanel(
              title: '基础单值滑块',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('当前值: ${_singleValue.round()}'),
                  ),
                ],
              ),
            ),
            // 带刻度的单值滑块
            SantoPanel(
              title: '带刻度的单值滑块',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('当前值: ${_singleValue2.round()}'),
                  ),
                ],
              ),
            ),
            // 自定义范围
            SantoPanel(
              title: '自定义范围 (0 - 200)',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SantoSlider(
                      min: 0,
                      max: 200,
                      value: 120,
                      divisions: 20,
                      onChanged: (v) {},
                    ),
                  ),
                ],
              ),
            ),
            // 自定义颜色
            SantoPanel(
              title: '自定义颜色',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SantoSlider(
                      value: 70,
                      activeColor: const Color(0xFFFF4D4F),
                      inactiveColor: Color(0xFFFF4D4F).withAlpha(40),
                      onChanged: (v) {},
                    ),
                  ),
                ],
              ),
            ),
            // 基础范围滑块
            SantoPanel(
              title: '基础范围滑块',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '范围: ${_rangeValue[0].round()} - ${_rangeValue[1].round()}',
                    ),
                  ),
                ],
              ),
            ),
            // 带标签的范围滑块
            SantoPanel(
              title: '带标签的范围滑块',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '范围: ${_rangeValue2[0].round()} - ${_rangeValue2[1].round()}',
                    ),
                  ),
                ],
              ),
            ),
            // 自定义颜色范围滑块
            SantoPanel(
              title: '自定义颜色范围滑块',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SantoSlider(
                      value: 40,
                      activeColor: const Color(0xFF52C41A),
                      onChanged: (v) {},
                    ),
                  ),
                ],
              ),
            ),
            // 带回调的滑块
            SantoPanel(
              title: '带回调的滑块',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [const SizedBox(height: 40)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
