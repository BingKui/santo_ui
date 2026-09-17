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
  double _callbackValue = 50;
  String _callbackTip = '';
  double _singleValue2 = 60;
  List<double> _rangeValue = [20, 80];
  List<double> _rangeValue2 = [40, 60];

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(      title: 'Slider 示例',
      children: <Widget>[
        // 基础单值滑块
        SantoSection(
          title: '基础单值滑块',
          description: '单值模式用 value 表示当前取值，默认区间为 0 到 100',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text('当前值: ${_singleValue.round()}'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SantoSlider(
                  value: _singleValue,
                  onChanged: (v) => setState(() => _singleValue = v as double),
                ),
              ),
            ],
          ),
        ),
        // 带刻度的单值滑块
        SantoSection(
          title: '带刻度的单值滑块',
          description: '通过 divisions 显示刻度，取值按刻度步长吸附',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text('当前值: ${_singleValue2.round()}'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SantoSlider(
                  value: _singleValue2,
                  divisions: 10,
                  onChanged: (v) => setState(() => _singleValue2 = v as double),
                ),
              ),
            ],
          ),
        ),
        // 自定义范围
        SantoSection(
          title: '自定义范围 (0 - 200)',
          description: 'min 与 max 扩大取值区间，divisions 划分刻度数量',
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
        SantoSection(
          title: '自定义颜色',
          description: 'activeColor 与 inactiveColor 分别设置滑块两侧颜色',
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
        SantoSection(
          title: '基础范围滑块',
          description: '范围模式用 rangeValue 传入起止值，当前区间为 20 到 80',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '范围: ${_rangeValue[0].round()} - ${_rangeValue[1].round()}',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SantoSlider(
                  rangeValue: _rangeValue,
                  onChanged: (v) => setState(
                      () => _rangeValue = (v as List).cast<double>()),
                ),
              ),
            ],
          ),
        ),
        // 带标签的范围滑块
        SantoSection(
          title: '带标签的范围滑块',
          description: 'showLabel 为 true 时拖动过程中展示取值标签',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '范围: ${_rangeValue2[0].round()} - ${_rangeValue2[1].round()}',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SantoSlider(
                  rangeValue: _rangeValue2,
                  showLabel: true,
                  onChanged: (v) => setState(
                      () => _rangeValue2 = (v as List).cast<double>()),
                ),
              ),
            ],
          ),
        ),
        // 自定义颜色范围滑块
        SantoSection(
          title: '自定义颜色范围滑块',
          description: 'activeColor 可自定义滑块激活色，范围模式同样适用',
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
        SantoSection(
          title: '带回调的滑块',
          description: 'onChanged 拖动时持续回调，onChangeEnd 在松手后回调一次',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                    '当前值: ${_callbackValue.round()}，状态: $_callbackTip'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SantoSlider(
                  value: _callbackValue,
                  onChanged: (v) => setState(() {
                    _callbackValue = v as double;
                    _callbackTip = '拖动中';
                  }),
                  onChangeEnd: (v) => setState(() {
                    _callbackValue = v as double;
                    _callbackTip = '松手结束';
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
