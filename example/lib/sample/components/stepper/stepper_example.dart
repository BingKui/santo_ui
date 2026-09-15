import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// 步进器示例页面
class StepperExample extends StatefulWidget {
  const StepperExample({Key? key}) : super(key: key);

  @override
  _StepperExampleState createState() => _StepperExampleState();
}

class _StepperExampleState extends State<StepperExample> {
  int _value1 = 1;
  int _value2 = 5;
  int _value3 = 0;
  int _value4 = 10;
  int _value5 = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SantoAppBar(title: 'Stepper 示例'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 基础步进器
            SantoPanel(
              title: '基础步进器',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('当前值: $_value1'),
                  ),
                ],
              ),
            ),
            // 自定义步长
            SantoPanel(
              title: '自定义步长 (step: 2)',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('当前值: $_value2（步长为 2）'),
                  ),
                ],
              ),
            ),
            // 禁用状态
            SantoPanel(
              title: '禁用状态',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SantoStepper(
                      value: 3,
                      enabled: false,
                      onChanged: (v) {},
                    ),
                  ),
                ],
              ),
            ),
            // 到达最小值
            SantoPanel(
              title: '到达最小值（减号禁用）',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('当前值: $_value3（最小值为 0）'),
                  ),
                ],
              ),
            ),
            // 到达最大值
            SantoPanel(
              title: '到达最大值（加号禁用）',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('当前值: $_value4（最大值为 10）'),
                  ),
                ],
              ),
            ),
            // 自定义尺寸
            SantoPanel(
              title: '自定义尺寸',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SantoStepper(
                      value: 2,
                      inputWidth: 80,
                      onChanged: (v) {},
                    ),
                  ),
                ],
              ),
            ),
            // 带回调的步进器
            SantoPanel(
              title: '带回调的步进器',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SantoStepper(
                      value: 1,
                      onChanged: (v) {
                        debugPrint('步进器回调: $v');
                      },
                    ),
                  ),
                ],
              ),
            ),
            // 实际场景：购物车数量
            SantoPanel(
              title: '实际场景：商品数量',
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
