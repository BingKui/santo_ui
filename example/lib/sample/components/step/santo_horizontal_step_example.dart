import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';

class SantoHorizontalStepExamplePage extends StatefulWidget {
  final String title;

  const SantoHorizontalStepExamplePage({Key? key, required this.title})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SantoHorizontalStepExamplePageState();
  }
}

class SantoHorizontalStepExamplePageState
    extends State<SantoHorizontalStepExamplePage> {
  late int _index;
  double sliderValue = 2;
  late SantoStepsController _controller;
  late ValueNotifier<double> valueNotifier;

  @override
  void initState() {
    super.initState();
    _index = 0;
    _controller = SantoStepsController(currentIndex: _index);
    valueNotifier = ValueNotifier(sliderValue);
  }

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(      appBar: SantoAppBar(title: widget.title),
      children: <Widget>[
        ExampleIntro('step'),
        SantoSection(
          title: '步骤个数调节',
          description: '拖动 SantoSlider 调整步骤总数，最多 5 步，变化后回到第 1 步',
          child: Column(
            children: [
              SliverSantoHorizontalStep(
                controller: _controller,
                valueNotifier: valueNotifier,
              ),
              const Text('步骤个数：'),
              SliderWidget(
                initValue: sliderValue,
                valueNotifier: valueNotifier,
              ),
            ],
          ),
        ),
        SantoSection(
          title: '步骤切换控制',
          description: '按钮分别调用 SantoStepsController 的前后步、跳转与完成方法',
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SantoButton(
                    child: const Text('上一步'),
                    onTap: () {
                      _controller.backStep();
                    },
                  ),
                  SantoButton(
                    child: const Text('下一步'),
                    onTap: () {
                      _controller.forwardStep();
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SantoButton(
                    child: const Text('跳至第3步'),
                    onTap: () {
                      _controller.setCurrentIndex(2);
                    },
                  ),
                  SantoButton(
                    child: const Text('完成'),
                    onTap: () {
                      _controller.setCompleted();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 自定义 widget
class SliderWidget extends StatefulWidget {
  const SliderWidget({
    Key? key,
    required this.initValue,
    required this.valueNotifier,
  }) : super(key: key);
  final double initValue;
  final ValueNotifier<double> valueNotifier;

  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  late double sliderValue;

  @override
  void initState() {
    super.initState();
    sliderValue = widget.initValue;
  }

  @override
  Widget build(BuildContext context) {
    return SantoSlider(
      value: sliderValue,
      min: 2,
      max: 5,
      divisions: 3,
      onChanged: (value) {
        setState(() {
          sliderValue = value;
          widget.valueNotifier.value = value;
        });
      },
    );
  }
}

/// 自定义 widget
class SliverSantoHorizontalStep extends StatefulWidget {
  const SliverSantoHorizontalStep({
    Key? key,
    required this.controller,
    required this.valueNotifier,
  }) : super(key: key);
  final SantoStepsController controller;
  final ValueNotifier<double> valueNotifier;

  @override
  _SliverSantoHorizontalStepsState createState() =>
      _SliverSantoHorizontalStepsState();
}

class _SliverSantoHorizontalStepsState extends State<SliverSantoHorizontalStep> {
  List<SantoStep> santoSteps() {
    final List<SantoStep> _list = [];
    final int value = widget.valueNotifier.value.toInt();
    for (int i = 0; i < value; i++) {
      _list.add(SantoStep(stepContentText: ('第你好11${i + 1}步')));
    }
    return _list;
  }

  void _onChange() {
    setState(() {
      santoSteps();
      widget.controller.setCurrentIndex(0);
    });
  }

  @override
  void initState() {
    super.initState();
    widget.valueNotifier.addListener(_onChange);
  }

  @override
  void dispose() {
    widget.valueNotifier.removeListener(_onChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SantoHorizontalSteps(
      steps: santoSteps(),
      controller: widget.controller,
    );
  }
}
