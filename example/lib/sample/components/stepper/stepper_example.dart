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
    return SantoPageLayout(
      title: 'Stepper 示例',
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 基础步进器
          SantoSection(
            title: '基础步进器',
            description: 'value 传入当前数值，onChanged 回调最新的增减结果',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('当前值: $_value1'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SantoStepper(
                    value: _value1,
                    onChanged: (v) => setState(() => _value1 = v),
                  ),
                ),
              ],
            ),
          ),
          // 自定义步长
          SantoSection(
            title: '自定义步长 (step: 2)',
            description: 'step 控制每次增减的幅度，此处每次变化 2',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('当前值: $_value2（步长为 2）'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SantoStepper(
                    value: _value2,
                    step: 2,
                    onChanged: (v) => setState(() => _value2 = v),
                  ),
                ),
              ],
            ),
          ),
          // 禁用状态
          SantoSection(
            title: '禁用状态',
            description: 'enabled 传 false 后按钮置灰，数值不可再修改',
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
          SantoSection(
            title: '到达最小值（减号禁用）',
            description: 'value 等于 min 时减号自动禁用',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('当前值: $_value3（最小值为 0）'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SantoStepper(
                    value: _value3,
                    min: 0,
                    onChanged: (v) => setState(() => _value3 = v),
                  ),
                ),
              ],
            ),
          ),
          // 到达最大值
          SantoSection(
            title: '到达最大值（加号禁用）',
            description: 'value 等于 max 时加号自动禁用',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('当前值: $_value4（最大值为 10）'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SantoStepper(
                    value: _value4,
                    max: 10,
                    onChanged: (v) => setState(() => _value4 = v),
                  ),
                ),
              ],
            ),
          ),
          // 自定义尺寸
          SantoSection(
            title: '自定义尺寸',
            description: 'inputWidth 调整输入框宽度，两侧按钮尺寸保持不变',
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
          SantoSection(
            title: '带回调的步进器',
            description: 'onChanged 在每次增减后回调，可用于同步业务数据',
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
          // 尺寸档位
          SantoSection(
            title: '尺寸档位',
            description: 'size 提供 small/normal/large 三档,高度、字号与图标同步变化',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: SantoStepper(
                    value: 1,
                    size: SantoStepperSize.small,
                    onChanged: (v) {},
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: SantoStepper(
                    value: 5,
                    size: SantoStepperSize.normal,
                    onChanged: (v) {},
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: SantoStepper(
                    value: 9,
                    size: SantoStepperSize.large,
                    onChanged: (v) {},
                  ),
                ),
              ],
            ),
          ),
          // 实际场景：购物车数量
          SantoSection(
            title: '实际场景：商品数量',
            description: '购物车等场景的数量增减，可结合 min、max 限制范围',
            child: Row(
              children: [
                const SizedBox(width: 20),
                const Text('商品数量'),
                const Spacer(),
                SantoStepper(
                  value: _value5,
                  min: 1,
                  max: 10,
                  onChanged: (v) => setState(() => _value5 = v),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
