import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// SantoStatistic 统计数值示例
class StatisticExample extends StatelessWidget {
  const StatisticExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(      title: 'Statistic 统计数值',
      children: <Widget>[
        SantoSection(
          title: '基础用法',
          description: 'title 为标题、value 为数值，整数默认按千分位分组',
          child: Row(
            children: <Widget>[
              Expanded(
                child: SantoStatistic(title: '活跃用户', value: 112893),
              ),
              Expanded(
                child: SantoStatistic(
                  title: '账号余额（元）',
                  value: 112893,
                  precision: 2,
                ),
              ),
            ],
          ),
        ),
        SantoSection(
          title: '前后缀',
          description: 'prefix 与 suffix 展示单位，图标与文案随数值样式一起继承',
          child: Row(
            children: <Widget>[
              Expanded(
                child: SantoStatistic(
                  title: '点赞数',
                  value: 1128,
                  prefix: const Icon(Icons.thumb_up_alt_outlined),
                ),
              ),
              Expanded(
                child: SantoStatistic(
                  title: '未合并请求',
                  value: 93,
                  suffix: const Text('/ 100'),
                ),
              ),
            ],
          ),
        ),
        SantoSection(
          title: '精度与分隔符',
          description: 'precision 只补零与截断不四舍五入，分隔符可用 groupSeparator 与 decimalSeparator 替换',
          child: Row(
            children: <Widget>[
              Expanded(
                child: SantoStatistic(
                  title: '截断到两位',
                  value: 11.2856,
                  precision: 2,
                ),
              ),
              Expanded(
                child: SantoStatistic(
                  title: '欧式分隔符',
                  value: 1234567.891,
                  precision: 2,
                  groupSeparator: '.',
                  decimalSeparator: ',',
                ),
              ),
            ],
          ),
        ),
        SantoSection(
          title: '非数字内容',
          description: '数值传字符串时原样展示，不做分组与精度处理',
          child: Row(
            children: <Widget>[
              Expanded(
                child: SantoStatistic(title: '成交量', value: '12.5万'),
              ),
              Expanded(
                child: SantoStatistic(title: '待补充', value: '—'),
              ),
            ],
          ),
        ),
        SantoSection(
          title: '自定义格式化',
          description: 'formatter 完全接管数值区域，可返回任意内容',
          child: Row(
            children: <Widget>[
              Expanded(
                child: SantoStatistic(
                  title: '完成率',
                  value: 0.86,
                  formatter: (value) => Text(
                    '${((value as num) * 100).toStringAsFixed(1)}%',
                  ),
                ),
              ),
              Expanded(
                child: SantoStatistic(
                  title: '上限',
                  value: 100,
                  formatter: (value) => const Text('不限'),
                ),
              ),
            ],
          ),
        ),
        SantoSection(
          title: '加载中',
          description: 'loading 为 true 时数值区域展示骨架占位，标题保持不变',
          child: Row(
            children: <Widget>[
              Expanded(
                child: SantoStatistic(
                  title: '加载中的数值',
                  value: 112893,
                  loading: true,
                ),
              ),
              Expanded(
                child: SantoStatistic(
                  title: '加载完成',
                  value: 112893,
                ),
              ),
            ],
          ),
        ),
        SantoSection(
          title: '在卡片中使用',
          description: '数值样式可通过 valueStyle 覆盖，常规做法是配合涨跌颜色与箭头',
          child: Row(
            children: <Widget>[
              Expanded(
                child: SantoShadowCard(
                  padding: const EdgeInsets.all(15),
                  child: SantoStatistic(
                    title: '上涨',
                    value: 11.28,
                    precision: 2,
                    prefix: const Icon(Icons.arrow_upward, size: 16),
                    suffix: const Text('%'),
                    valueStyle: const TextStyle(
                      color: Color(0xFF3F8600),
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: SantoShadowCard(
                  padding: const EdgeInsets.all(15),
                  child: SantoStatistic(
                    title: '下跌',
                    value: 9.3,
                    precision: 2,
                    prefix: const Icon(Icons.arrow_downward, size: 16),
                    suffix: const Text('%'),
                    valueStyle: const TextStyle(
                      color: Color(0xFFCF1322),
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
