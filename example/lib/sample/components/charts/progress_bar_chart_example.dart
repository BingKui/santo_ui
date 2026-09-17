import 'dart:math';
import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

class ProgressBarChartExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProgressBarChartExampleState();
  }
}

class ProgressBarChartExampleState extends State<ProgressBarChartExample> {
  Random randomColorG = Random();
  int count = 5;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      child: Column(
        children: <Widget>[
          // 横向柱状图
          SantoSection(
            title: '横向柱状图',
            description:
                'barChartStyle 为 horizontal，xAxis 标签倾斜展示，点击柱子弹出提示',
            child: SantoProgressBarChart(
              barChartStyle: BarChartStyle.horizontal,
              xAxis: ChartAxis(
                  inclineText: true,
                  axisItemList: [
                AxisItem(showText: '2022年10月10日'),
                AxisItem(showText: '2022年10月10日'),
                AxisItem(showText: '2022年10月10日'),
                AxisItem(showText: '2022年10月10日'),
                AxisItem(showText: '2022年10月10日'),
                AxisItem(showText: '2022年10月10日'),
                AxisItem(showText: '2022年10月10日'),
              ]),
              yAxis: ChartAxis(axisItemList: [
                AxisItem(showText: '示例1'),
                AxisItem(showText: '示例2'),
                AxisItem(showText: '示例3'),
                AxisItem(showText: '示例4'),
                AxisItem(showText: '示例5'),
              ]),
              singleBarWidth: 30,
              barBundleList: [
                SantoProgressBarBundle(barList: [
                  SantoProgressBarItem(text: '示例', value: 10, hintValue: 15),
                  SantoProgressBarItem(text: '示例', value: 20),
                  SantoProgressBarItem(text: '示例', value: 30, hintValue: 15),
                  SantoProgressBarItem(text: '示例', value: 20, hintValue: 15),
                  SantoProgressBarItem(text: '示例', value: 0, hintValue: 15),
                ], colors: [
                  Color(0xff1545FD),
                  Color(0xff1677FF)
                ]),
              ],
              barChartSelectCallback: (SantoProgressBarItem? barItem) {
                SantoToast.show(barItem?.text ?? '', context);
              },
            ),
          ),
          // 纵向柱状图与分组
          SantoSection(
            title: '纵向柱状图与分组',
            description:
                'barChartStyle 为 vertical，两组 barBundle 并列，barMaxValue 限制为 60',
            child: SantoProgressBarChart(
              barChartStyle: BarChartStyle.vertical,
              xAxis: ChartAxis(axisItemList: [
                AxisItem(showText: '示例1'),
                AxisItem(showText: '示例2'),
                AxisItem(showText: '示例3'),
                AxisItem(showText: '示例4'),
                AxisItem(showText: '示例5'),
                AxisItem(showText: '示例6'),
                AxisItem(showText: '示例7'),
                AxisItem(showText: '示例8'),
                AxisItem(showText: '示例9'),
                AxisItem(showText: '示例10'),
              ]),
              barBundleList: [
                SantoProgressBarBundle(barList: [
                  SantoProgressBarItem(
                      text: '示例11', value: 5, hintValue: 15, showBarValueText: "1122334"),
                  SantoProgressBarItem(text: '示例12', value: 20, selectedHintText: '示例12:20'),
                  SantoProgressBarItem(
                      text: '示例13',
                      value: 30,
                      selectedHintText: '示例13:30\n示例13:30\n示例13:30\n示例13:30\n示例13:30\n示例13:30'),
                  SantoProgressBarItem(text: '示例14', value: 25),
                  SantoProgressBarItem(text: '示例15', value: 21),
                  SantoProgressBarItem(text: '示例16', value: 28),
                  SantoProgressBarItem(text: '示例17', value: 15),
                  SantoProgressBarItem(text: '示例18', value: 11),
                  SantoProgressBarItem(text: '示例19', value: 30),
                  SantoProgressBarItem(text: '示例110', value: 24),
                ], colors: [
                  Color(0xff1545FD),
                  Color(0xff1677FF)
                ]),
                SantoProgressBarBundle(barList: [
                  SantoProgressBarItem(text: '示例21', value: 20, hintValue: 15),
                  SantoProgressBarItem(text: '示例22', value: 15, selectedHintText: '示例12:20'),
                  SantoProgressBarItem(
                      text: '示例23',
                      value: 30,
                      selectedHintText: '示例13:30\n示例13:30\n示例13:30\n示例13:30\n示例13:30\n示例13:30'),
                  SantoProgressBarItem(text: '示例24', value: 20),
                  SantoProgressBarItem(text: '示例25', value: 28),
                  SantoProgressBarItem(text: '示例26', value: 25),
                  SantoProgressBarItem(text: '示例27', value: 17),
                  SantoProgressBarItem(text: '示例28', value: 14),
                  SantoProgressBarItem(text: '示例29', value: 36),
                  SantoProgressBarItem(text: '示例210', value: 29),
                ], colors: [
                  Color(0xff01D57D),
                  Color(0xff01D57D)
                ]),
              ],
              yAxis: ChartAxis(axisItemList: [
                AxisItem(showText: '10'),
                AxisItem(showText: '20'),
                AxisItem(showText: '30')
              ]),
              singleBarWidth: 30,
              barGroupSpace: 30,
              barMaxValue: 60,
              onBarItemClickInterceptor: (barBundleIndex, barBundle, barGroupIndex, barItem) {
                return true;
              },
              barChartSelectCallback: (SantoProgressBarItem? barItem) {
                SantoToast.show(barItem?.text ?? '', context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
