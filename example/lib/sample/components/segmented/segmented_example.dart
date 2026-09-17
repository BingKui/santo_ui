import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// SantoSegmented 分段选择器示例
class SegmentedExample extends StatefulWidget {
  const SegmentedExample({Key? key}) : super(key: key);

  @override
  State<SegmentedExample> createState() => _SegmentedExampleState();
}

class _SegmentedExampleState extends State<SegmentedExample> {
  String _basicValue = '日';
  String _controlledValue = 'list';
  String _blockValue = 'all';
  String _roundValue = 'light';
  String _verticalValue = 'list';
  String _iconValue = 'map';
  String _customValue = 'spring';
  String _dynamicValue = 'a';
  SantoSegmentedSize _sizeValue = SantoSegmentedSize.medium;
  List<SantoSegmentedOption<String>> _dynamicOptions = _baseDynamicOptions;

  static const List<SantoSegmentedOption<String>> _baseDynamicOptions = [
    SantoSegmentedOption(value: 'a', label: '选项 A'),
    SantoSegmentedOption(value: 'b', label: '选项 B'),
  ];

  static const List<String> _simpleLabels = ['日', '周', '月', '季', '年'];

  List<SantoSegmentedOption<String>> get _simpleOptions => [
        for (final label in _simpleLabels)
          SantoSegmentedOption(value: label, label: label),
      ];

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 12),
          SantoSection(
            title: '基础用法',
            description: 'options 定义选项，未传 value 时非受控，默认选中第一个选项',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _center(SantoSegmented<String>(
                  options: _simpleOptions,
                  onChanged: (value) => setState(() => _basicValue = value),
                )),
                const SizedBox(height: 8),
                Text(
                  'onChanged 回调值：$_basicValue',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
          SantoSection(
            title: '受控模式',
            description: 'value 绑定当前选中值，选中态完全由外部控制',
            child: _center(SantoSegmented<String>(
              value: _controlledValue,
              options: const [
                SantoSegmentedOption(value: 'list', label: '列表'),
                SantoSegmentedOption(value: 'board', label: '看板'),
                SantoSegmentedOption(value: 'chart', label: '图表'),
              ],
              onChanged: (value) =>
                  setState(() => _controlledValue = value),
            )),
          ),
          SantoSection(
            title: '三种尺寸',
            description: 'size 支持 large(40)/medium(32)/small(24)，点击下方切换',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SantoSegmented<SantoSegmentedSize>(
                  block: true,
                  value: _sizeValue,
                  options: const [
                    SantoSegmentedOption(
                        value: SantoSegmentedSize.small, label: 'small'),
                    SantoSegmentedOption(
                        value: SantoSegmentedSize.medium, label: 'medium'),
                    SantoSegmentedOption(
                        value: SantoSegmentedSize.large, label: 'large'),
                  ],
                  onChanged: (value) => setState(() => _sizeValue = value),
                ),
                const SizedBox(height: 12),
                _center(SantoSegmented<String>(
                  size: _sizeValue,
                  options: _simpleOptions,
                )),
              ],
            ),
          ),
          SantoSection(
            title: '撑满宽度',
            description: 'block 为 true 时轨道撑满父容器，各选项等分宽度',
            child: SantoSegmented<String>(
              block: true,
              value: _blockValue,
              options: const [
                SantoSegmentedOption(value: 'all', label: '全部'),
                SantoSegmentedOption(value: 'doing', label: '进行中'),
                SantoSegmentedOption(value: 'done', label: '已完成'),
              ],
              onChanged: (value) => setState(() => _blockValue = value),
            ),
          ),
          SantoSection(
            title: '胶囊形状',
            description: 'shape 为 round 时轨道与滑块改为胶囊形',
            child: _center(SantoSegmented<String>(
              shape: SantoSegmentedShape.round,
              value: _roundValue,
              options: const [
                SantoSegmentedOption(value: 'light', label: '浅色'),
                SantoSegmentedOption(value: 'dark', label: '深色'),
                SantoSegmentedOption(value: 'auto', label: '跟随系统'),
              ],
              onChanged: (value) => setState(() => _roundValue = value),
            )),
          ),
          SantoSection(
            title: '垂直排列',
            description: 'orientation 为 vertical 时选项纵向排列',
            child: Align(
              alignment: Alignment.centerLeft,
              child: SantoSegmented<String>(
                orientation: SantoSegmentedOrientation.vertical,
                value: _verticalValue,
                options: const [
                  SantoSegmentedOption(value: 'list', label: '列表视图'),
                  SantoSegmentedOption(value: 'board', label: '看板视图'),
                  SantoSegmentedOption(value: 'chart', label: '图表视图'),
                ],
                onChanged: (value) => setState(() => _verticalValue = value),
              ),
            ),
          ),
          SantoSection(
            title: '带图标',
            description: '选项可只放图标，也可图标与文案同时展示',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _center(SantoSegmented<String>(
                  value: _iconValue,
                  options: const [
                    SantoSegmentedOption(
                      value: 'list',
                      label: '列表',
                      icon: Icon(Icons.list),
                    ),
                    SantoSegmentedOption(
                      value: 'map',
                      label: '地图',
                      icon: Icon(Icons.map),
                    ),
                    SantoSegmentedOption(
                      value: 'stats',
                      label: '统计',
                      icon: Icon(Icons.bar_chart),
                    ),
                  ],
                  onChanged: (value) => setState(() => _iconValue = value),
                )),
                const SizedBox(height: 12),
                _center(SantoSegmented<String>(
                  shape: SantoSegmentedShape.round,
                  defaultValue: 'dark',
                  options: const [
                    SantoSegmentedOption(
                      value: 'light',
                      icon: Icon(Icons.light_mode),
                      tooltip: '浅色模式',
                    ),
                    SantoSegmentedOption(
                      value: 'dark',
                      icon: Icon(Icons.dark_mode),
                      tooltip: '深色模式',
                    ),
                  ],
                )),
              ],
            ),
          ),
          SantoSection(
            title: '自定义选项内容',
            description: 'labelWidget 可替换默认文案，渲染任意内容',
            child: _center(SantoSegmented<String>(
              value: _customValue,
              options: const [
                SantoSegmentedOption(
                  value: 'spring',
                  labelWidget: _TwoLineLabel(title: '春', desc: '1-3 月'),
                ),
                SantoSegmentedOption(
                  value: 'summer',
                  labelWidget: _TwoLineLabel(title: '夏', desc: '4-6 月'),
                ),
                SantoSegmentedOption(
                  value: 'autumn',
                  labelWidget: _TwoLineLabel(title: '秋', desc: '7-9 月'),
                ),
                SantoSegmentedOption(
                  value: 'winter',
                  labelWidget: _TwoLineLabel(title: '冬', desc: '10-12 月'),
                ),
              ],
              onChanged: (value) => setState(() => _customValue = value),
            )),
          ),
          SantoSection(
            title: '禁用状态',
            description: 'disabled 可以禁用整个组件，选项上的 disabled 只禁用该项',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _center(SantoSegmented<String>(
                  disabled: true,
                  defaultValue: 'week',
                  options: _simpleOptions,
                )),
                const SizedBox(height: 12),
                _center(SantoSegmented<String>(
                  value: _dynamicValue,
                  options: [
                    const SantoSegmentedOption(value: 'a', label: '可选中'),
                    const SantoSegmentedOption(
                      value: 'b',
                      label: '不可选中',
                      disabled: true,
                    ),
                    SantoSegmentedOption(value: 'c', label: '可选中'),
                  ],
                  onChanged: (value) =>
                      setState(() => _dynamicValue = value),
                )),
              ],
            ),
          ),
          SantoSection(
            title: '动态改变选项',
            description: 'options 变化后选中值仍匹配则保留，否则回退到默认选项',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _center(SantoSegmented<String>(
                  value: _dynamicValue,
                  options: _dynamicOptions,
                  onChanged: (value) =>
                      setState(() => _dynamicValue = value),
                )),
                const SizedBox(height: 12),
                Row(
                  children: [
                    SantoSmallOutlineButton(
                      title: '加载选项',
                      onTap: () => setState(() {
                        _dynamicValue = 'c';
                        _dynamicOptions = const [
                          ..._baseDynamicOptions,
                          SantoSegmentedOption(value: 'c', label: '选项 C'),
                        ];
                      }),
                    ),
                    const SizedBox(width: 12),
                    SantoSmallOutlineButton(
                      title: '重置',
                      onTap: () => setState(() {
                        _dynamicValue = 'a';
                        _dynamicOptions = _baseDynamicOptions;
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  /// 分段选择器宽度由内容决定，示例里居中展示
  Widget _center(Widget segmented) {
    return Align(alignment: Alignment.center, child: segmented);
  }
}

/// 自定义选项内容:两行文案
class _TwoLineLabel extends StatelessWidget {
  const _TwoLineLabel({required this.title, required this.desc});

  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, height: 1.3)),
          Text(
            desc,
            style: TextStyle(
              fontSize: 12,
              height: 1.3,
              color: SantoThemeConfigurator.instance
                  .getConfig()
                  .commonConfig
                  .colorTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
