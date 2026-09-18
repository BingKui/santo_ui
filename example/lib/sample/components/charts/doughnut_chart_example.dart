

import 'dart:math';

import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';

class DoughnutChartExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DoughnutChartExampleState();
  }
}

class DoughnutChartExampleState extends State<DoughnutChartExample> {
  SantoDoughnutDataItem? selectedItem;

  List<SantoDoughnutDataItem> dataList = [];
  List<Color> preinstallColors = [
    Color(0xffFF862D),
    Color(0xff26BB7D),
    Color(0xffFFDD00),
    Color(0xff6AA6FB),
    Color(0xff1677FF),
  ];
  int count = 5;

  void initState() {
    super.initState();
    for (int i = 0; i < count; i++) {
      dataList.add(SantoDoughnutDataItem(
          title: '示例',
          value: random(1, 5).toDouble(),
          color: getColorWithIndex(i)));
    }
  }

  int random(int min, int max) {
    final _random = Random();
    return min + _random.nextInt(max - min + 1);
  }

  Color getColorWithIndex(int index) {
    return this.preinstallColors[index % this.preinstallColors.length];
  }

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: '数据展示',
        children: <Widget>[
          ExampleIntro('charts'),
          // 环状图与图例
          SantoSection(
            title: '环状图与图例',
            description: '点选扇区后中心展示该扇区标题，图例以 wrap 形式自动换行',
            child: Column(
              children: <Widget>[
                SantoDoughnutChart(
                  padding: EdgeInsets.all(50),
                  width: 200,
                  height: 200,
                  data: dataList,
                  selectedItem: selectedItem,
                  showTitleWhenSelected: true,
                  selectCallback: (SantoDoughnutDataItem? selectedItem) {
                    setState(() {
                      this.selectedItem = selectedItem;
                    });
                  },
                ),
                DoughnutChartLegend(
                    data: this.dataList,
                    legendStyle: SantoDoughnutChartLegendStyle.wrap),
                ],
            ),
          ),
          // 扇区数量动态调整
          SantoSection(
            title: '数据个数',
            description: 'count 在 1 到 10 之间调整扇区数量，颜色循环取预设色板',
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text('数据个数'),
                ),
                Expanded(
                  child: SantoSlider(
                      value: count.toDouble(),
                      divisions: 10,
                      onChanged: (data) {
                        setState(() {
                          this.count = data.toInt();
                          dataList.clear();
                          for (int i = 0; i < count; i++) {
                            dataList.add(SantoDoughnutDataItem(
                                title: '示例',
                                value: random(1, 5).toDouble(),
                                color: getColorWithIndex(i)));
                          }
                        });
                      },
                      onChangeStart: (data) {},
                      onChangeEnd: (data) {},
                      min: 1,
                      max: 10,
                      label: '$count',
                      activeColor: Colors.green,
                      inactiveColor: Colors.grey,
                      semanticFormatterCallback: (double newValue) {
                        return '${newValue.round()}}';
                      }),
                ),
              ],
            ),
          ),
        ],
    );
  }
}
