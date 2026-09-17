import 'dart:math';

import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/components/charts/line/db_data_node_model.dart';
import 'package:flutter/material.dart';

class BrokenLineExample extends StatefulWidget {
  final List<DBDataNodeModel> brokenData;

  BrokenLineExample(this.brokenData);

  @override
  _BrokenLineExampleState createState() => _BrokenLineExampleState();
}

class _BrokenLineExampleState extends State<BrokenLineExample> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: '折线',
      padding: EdgeInsets.zero,
      scrollable: false,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // 首个区块前保留原有顶部留白
              SizedBox(height: 20),
              SantoSection(
                title: '单条曲线与数据点',
                description: '数据点与坐标刻度由 brokenData 动态生成，提示框常驻不消失',
                child: _brokenLineExample1(context, widget.brokenData),
              ),
              SantoSection(
                title: '多条折线与图例',
                description: 'lines 叠加两条折线并展示图例，x 轴刻度文案可自定义',
                child: _brokenLineExample2(context),
              ),
              SantoSection(
                title: '自定义提示内容',
                description: 'onTouch 返回 Widget 渲染浮层，y 轴刻度文案也可自定义',
                child: _brokenLineExample3(context),
              ),
              SantoSection(
                title: '超宽图表横向滑动',
                description: 'size 宽度设为屏幕两倍，数据点超出可视区时可左右滑动查看',
                child: _brokenLineExample4(context),
              ),
              SantoSection(
                title: '数据点文本与样式',
                description: 'isShowPointText 开启数据点文本，样式与偏移可自定义',
                child: _brokenLineExample5(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /////////////////////////////
  Widget _brokenLineExample1(context, List<DBDataNodeModel> brokenData) {
    return Container(
      child: Column(
        children: <Widget>[
          SantoBrokenLine(
            showPointDashLine: true,
            yHintLineOffset: 30,
            isTipWindowAutoDismiss: false,
            isShowXDial: false,
            lines: [
              SantoPointsLine(
                isShowPointText: true,
                lineWidth: 3,
                pointRadius: 4,
                isShowPoint: true,
                isCurve: true,
                points: _linePointsForExample1(brokenData),
                shaderColors: [
                  Colors.green.withOpacity(0.3),
                  Colors.green.withOpacity(0.01)
                ],
                lineColor: Colors.green,
              )
            ],
            size: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height / 5 * 1.6 - 20 * 2),
            isShowXHintLine: true,
            xDialValues: _getXDialValuesForExample1(brokenData),
            xDialMin: 0,
            xDialMax: _getXDialValuesForExample1(brokenData).length.toDouble(),
            yDialValues: _getYDialValuesForExample1(brokenData),
            yDialMin: _getMinValueForExample1(brokenData),
            yDialMax: _getMaxValueForExample1(brokenData),
            isHintLineSolid: false,
            isShowYDialText: true,
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }

  List<SantoPointData> _linePointsForExample1(List<DBDataNodeModel> brokenData) {
    return brokenData
        .map((item) => SantoPointData(
            pointText: item.value,
            x: brokenData.indexOf(item).toDouble(),
            y: double.parse(item.value!),
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return item.value;
                })))
        .toList();
  }

  List<SantoDialItem> _getYDialValuesForExample1(
      List<DBDataNodeModel> brokenData) {
    double min = _getMinValueForExample1(brokenData);
    double max = _getMaxValueForExample1(brokenData);
    double dValue = (max - min) / 10;
    List<SantoDialItem> _yDialValue = [];
    for (int index = 0; index <= 10; index++) {
      _yDialValue.add(SantoDialItem(
        dialText: '${(min + index * dValue).ceil()}',
        dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF808695)),
        value: (min + index * dValue).ceilToDouble(),
      ));
    }
    _yDialValue.add(SantoDialItem(
      dialText: '4.5',
      dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF808695)),
      value: 4.5,
    ));
    return _yDialValue;
  }

  double _getMinValueForExample1(List<DBDataNodeModel> brokenData) {
    double minValue = double.tryParse(brokenData[0].value!) ?? 0;
    for (DBDataNodeModel point in brokenData) {
      minValue = min(double.tryParse(point.value!) ?? 0, minValue);
    }
    return minValue;
  }

  double _getMaxValueForExample1(List<DBDataNodeModel> brokenData) {
    double maxValue = double.tryParse(brokenData[0].value!) ?? 0;
    for (DBDataNodeModel point in brokenData) {
      maxValue = max(double.tryParse(point.value!) ?? 0, maxValue);
    }
    return maxValue;
  }

  List<SantoDialItem> _getXDialValuesForExample1(
      List<DBDataNodeModel> brokenData) {
    List<SantoDialItem> _xDialValue = [];
    for (int index = 0; index < brokenData.length; index++) {
      _xDialValue.add(SantoDialItem(
        dialText: brokenData[index].name,
        dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF808695)),
        value: index.toDouble(),
      ));
    }
    return _xDialValue;
  }

  ////////////////////////////
  Widget _brokenLineExample2(context) {
    var chartLine = SantoBrokenLine(
      lines: _linesForExample2(),
      size: Size(MediaQuery.of(context).size.width - 50,
          MediaQuery.of(context).size.height / 5 * 1.6 - 20 * 2),
      isShowXHintLine: true,
      yHintLineOffset: 30,
      yDialValues: _yDialValuesForExample2(),
      yDialMin: 0,
      yDialMax: 120,
      xDialValues: _xDialValuesForExample2(),
      xDialMin: 1,
      xDialMax: 7,
      isHintLineSolid: false,
      isShowYDialText: true,
    );
    return Container(
      child: Column(
        children: <Widget>[
          _buildIdentificationList(),
          SizedBox(
            height: 16,
          ),
          chartLine
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }

  List<SantoPointsLine> _linesForExample2() {
    SantoPointsLine _pointsLine;
    SantoPointsLine _pointsLine1;
    List<SantoPointsLine> pointsLineList = [];
    _pointsLine = SantoPointsLine(
      isShowPointText: true,
      lineWidth: 3,
      pointRadius: 4,
      isShowPoint: false,
      isCurve: true,
      points: [
        SantoPointData(
            pointText: '15',
            x: 1,
            y: 15,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '15';
                })),
        SantoPointData(
            x: 2.5,
            y: 30,
            pointText: '22222',
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '30';
                })),
        SantoPointData(
            pointText: '17',
            x: 3,
            y: 17,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '17';
                })),
        SantoPointData(
            pointText: '45',
            x: 4,
            y: 45,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '45';
                })),
        SantoPointData(
            pointText: '45',
            x: 5,
            y: 80,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '80';
                })),
      ],
      shaderColors: [
        Colors.blue.withOpacity(0.3),
        Colors.blue.withOpacity(0.01)
      ],
      lineColor: Colors.blue,
    );
    _pointsLine1 = SantoPointsLine(
      isShowPointText: true,
      lineWidth: 3,
      pointRadius: 4,
      isShowPoint: false,
      isCurve: true,
      points: [
        SantoPointData(
            pointText: '30',
            x: 2.5,
            y: 4,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '30';
                })),
        SantoPointData(
            pointText: '17',
            x: 3,
            y: 20,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '17';
                })),
        SantoPointData(
            pointText: '45',
            x: 4,
            y: 30,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '45';
                })),
        SantoPointData(
            pointText: '45',
            x: 5,
            y: 50,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '80';
                })),
        SantoPointData(
            pointText: '45',
            x: 6,
            y: 5,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '80';
                })),
      ],
      shaderColors: [
        Colors.green.withOpacity(0.3),
        Colors.green.withOpacity(0.01)
      ],
      lineColor: Colors.green,
    );

    pointsLineList.add(_pointsLine);
    pointsLineList.add(_pointsLine1);
    return pointsLineList;
  }

  List<SantoDialItem> _xDialValuesForExample2() {
    return [
      SantoDialItem(
        dialText: '1月',
        dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF808695)),
        selectedDialTextStyle: TextStyle(fontSize: 14.0, color: Colors.green),
        value: 1,
      ),
      SantoDialItem(
        dialText: '2月',
        dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF808695)),
        selectedDialTextStyle: TextStyle(fontSize: 14.0, color: Colors.red),
        value: 2,
      ),
      SantoDialItem(
        dialText: '3月',
        dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF808695)),
        selectedDialTextStyle: TextStyle(fontSize: 14.0, color: Colors.black),
        value: 3,
      ),
      SantoDialItem(
        dialText: '5月',
        dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF808695)),
        selectedDialTextStyle: TextStyle(fontSize: 14.0, color: Colors.orange),
        value: 5,
      ),
      SantoDialItem(
        dialText: '6月',
        dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF808695)),
        selectedDialTextStyle: TextStyle(fontSize: 14.0, color: Colors.yellow),
        value: 6,
      ),
      SantoDialItem(
        dialText: '7月',
        dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF808695)),
        selectedDialTextStyle: TextStyle(fontSize: 14.0, color: Colors.amberAccent),
        value: 7,
      )
    ];
  }

  List<SantoDialItem> _yDialValuesForExample2() {
    return [
      SantoDialItem(
        dialText: '0',
        dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF808695)),
        value: 0,
      ),
      SantoDialItem(
        dialText: '33.3',
        dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF808695)),
        value: 33.3,
      ),
      SantoDialItem(
        dialText: '66.6',
        dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF808695)),
        value: 66.6,
      ),
      SantoDialItem(
        dialText: '100',
        dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF808695)),
        value: 100,
      ),
      SantoDialItem(
        dialText: '120',
        dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF808695)),
        value: 120,
      )
    ];
  }

  /////////////////////
  Widget _brokenLineExample3(context) {
    var chartLine = SantoBrokenLine(
      showPointDashLine: false,
      yHintLineOffset: 40,
      lines: _getPointsLinesForExample3(),
      size: Size(MediaQuery.of(context).size.width - 50 * 2,
          MediaQuery.of(context).size.height / 5 * 1.6 - 20 * 2),
      isShowXHintLine: true,
      yDialValues: getYDialValuesForExample3(),
      xDialValues: _getXDialValuesForExample3(_getPointsLinesForExample3()),
      yDialMin: 0,
      yDialMax: 120,
      xDialMin: 1,
      xDialMax: 11,
      isHintLineSolid: false,
      isShowYDialText: true,
    );
    return Container(
      child: Column(
        children: <Widget>[
          _buildIdentificationList(),
          SizedBox(
            height: 16,
          ),
          chartLine,
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }

  List<SantoPointsLine> _getPointsLinesForExample3() {
    SantoPointsLine pointsLine, _pointsLine2;
    List<SantoPointsLine> pointsLineList = [];
    pointsLine = SantoPointsLine(
      lineWidth: 3,
      pointRadius: 4,
      isShowPoint: true,
      isCurve: false,
      points: [
        SantoPointData(
            pointText: '30',
            y: 30,
            x: 1,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return Container(
                    alignment: Alignment.center,
                    width: 40,
                    height: 40,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 30,
                            color: Colors.orange,
                          ),
                          Container(
                            height: 30,
                            color: Colors.greenAccent,
                          ),
                          Container(height: 20, color: Colors.green),
                          Container(height: 20, color: Colors.green),
                          Container(height: 20, color: Colors.blue)
                        ],
                      ),
                    ),
                  );
                })),
        SantoPointData(
            pointText: '88',
            y: 80,
            x: 2,
            lineTouchData: SantoLineTouchData(
                onTouch: () {
                  return Container(
                    padding:
                        EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
                    child: Center(
                        child: Text(
                      'content',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    )),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(2.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0.0, 2.0), //阴影xy轴偏移量
                          blurRadius: 4.0, //阴影模糊程度
                        )
                      ],
                    ),
                  );
                },
                tipWindowSize: Size(60, 40))),
        SantoPointData(
            pointText: '20',
            y: 20,
            x: 3,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '20';
                })),
        SantoPointData(
            pointText: '67',
            y: 67,
            x: 4,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '66';
                })),
        SantoPointData(
            pointText: '10',
            y: 10,
            x: 5,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '10';
                })),
        SantoPointData(
            pointText: '40',
            y: 40,
            x: 6,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '40';
                })),
        SantoPointData(
            pointText: '100',
            y: 60,
            x: 7,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '100';
                })),
        SantoPointData(
            pointText: '100',
            y: 70,
            x: 8,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '100';
                })),
        SantoPointData(
            pointText: '100',
            y: 90,
            x: 9,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '100';
                })),
        SantoPointData(
            pointText: '100',
            y: 80,
            x: 10,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '11';
                })),
        SantoPointData(
            pointText: '100',
            y: 100,
            x: 11,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '100';
                })),
      ],
      lineColor: Colors.blue,
    );

    _pointsLine2 = SantoPointsLine(
      lineWidth: 3,
      pointRadius: 4,
      isShowPoint: false,
      isCurve: true,
      points: [
        SantoPointData(
            pointText: '15',
            y: 15,
            x: 1,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '15';
                })),
        SantoPointData(
            pointText: '30',
            y: 30,
            x: 2,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '30';
                })),
        SantoPointData(
            pointText: '17',
            y: 17,
            x: 3,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '17';
                })),
        SantoPointData(
            pointText: '18',
            y: 25,
            x: 4,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '18';
                })),
        SantoPointData(
            pointText: '13',
            y: 40,
            x: 5,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '13';
                })),
        SantoPointData(
            pointText: '16',
            y: 30,
            x: 6,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '16';
                })),
        SantoPointData(
            pointText: '49',
            y: 49,
            x: 7,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '49';
                })),
        SantoPointData(
            pointText: '66',
            y: 66,
            x: 8,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '66';
                })),
        SantoPointData(
            pointText: '77',
            y: 80,
            x: 9,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '77';
                })),
        SantoPointData(
            pointText: '88',
            y: 90,
            x: 10,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '88';
                })),
        SantoPointData(
            pointText: '99',
            y: 60,
            x: 11,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '99';
                })),
      ],
      shaderColors: [
        Colors.green.withOpacity(0.3),
        Colors.green.withOpacity(0.01)
      ],
      lineColor: Colors.green,
    );

    pointsLineList.add(pointsLine);
    pointsLineList.add(_pointsLine2);
    return pointsLineList;
  }

  List<SantoDialItem> getYDialValuesForExample3() {
    return [
      SantoDialItem(
        dialText: '自定义',
        dialTextStyle: TextStyle(fontSize: 10.0, color: Colors.green),
        value: 0,
      ),
      SantoDialItem(
        dialText: '20',
        dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF808695)),
        value: 20,
      ),
      SantoDialItem(
        dialText: '40',
        dialTextStyle: TextStyle(fontSize: 10.0, color: Colors.red),
        value: 40,
      ),
      SantoDialItem(
        dialText: '60',
        dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF808695)),
        value: 60,
      ),
      SantoDialItem(
        dialText: '80',
        dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF808695)),
        value: 80,
      ),
      SantoDialItem(
        dialText: '100',
        dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF808695)),
        value: 100,
      ),
      SantoDialItem(
        dialText: '120',
        dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF808695)),
        value: 120,
      )
    ];
  }

  _getXDialValuesForExample3(List<SantoPointsLine> lines) {
    List<SantoDialItem> _xDialValue = [];
    for (int index = 0; index < lines[0].points.length; index++) {
      _xDialValue.add(SantoDialItem(
        dialText: '${lines[0].points[index].x}',
        dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF808695)),
        value: lines[0].points[index].x,
      ));
    }
    return _xDialValue;
  }

  /////////////////////
  Widget _brokenLineExample4(context) {
    var chartLine = SantoBrokenLine(
      lines: _getPointsLinesForExample4(),
      size: Size(MediaQuery.of(context).size.width * 2,
          MediaQuery.of(context).size.height / 5 * 1.6 - 20 * 2),
      isShowXHintLine: true,
      yHintLineOffset: 30,
      yDialMin: 0,
      yDialMax: 120,
      yDialValues: _yDialValuesForExample4(),
      xDialMin: 1,
      xDialMax: 11,
      xDialValues: _getXDialValuesForExample4(_getPointsLinesForExample4()),
      isHintLineSolid: false,
      isShowYDialText: true,
    );
    return Container(
      child: Column(
        children: <Widget>[
          _buildIdentificationList(),
          SizedBox(
            height: 16,
          ),
          chartLine
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }

  List<SantoPointsLine> _getPointsLinesForExample4() {
    SantoPointsLine pointsLine, _pointsLine2;
    List<SantoPointsLine> pointsLineList = [];
    pointsLine = SantoPointsLine(
      lineWidth: 3,
      pointRadius: 4,
      isShowPoint: true,
      isCurve: false,
      points: [
        SantoPointData(
            pointText: '30',
            y: 30,
            x: 1,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return Container(
                    alignment: Alignment.center,
                    width: 40,
                    height: 40,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 30,
                            color: Colors.orange,
                          ),
                          Container(
                            height: 30,
                            color: Colors.greenAccent,
                          ),
                          Container(height: 20, color: Colors.green),
                          Container(height: 20, color: Colors.green),
                          Container(height: 20, color: Colors.blue)
                        ],
                      ),
                    ),
                  );
                })),
        SantoPointData(
            pointText: '88',
            y: 80,
            x: 2,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return Container(
                    padding:
                        EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
                    child: Center(
                        child: Text(
                      'content',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    )),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(2.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0.0, 2.0), //阴影xy轴偏移量
                          blurRadius: 4.0, //阴影模糊程度
                        )
                      ],
                    ),
                  );
                })),
        SantoPointData(
            pointText: '20',
            y: 20,
            x: 3,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '20';
                })),
        SantoPointData(
            pointText: '67',
            y: 67,
            x: 4,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '66';
                })),
        SantoPointData(
            pointText: '10',
            y: 10,
            x: 5,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '10';
                })),
        SantoPointData(
            pointText: '40',
            y: 40,
            x: 6,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '40';
                })),
        SantoPointData(
            pointText: '100',
            y: 60,
            x: 7,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '100';
                })),
        SantoPointData(
            pointText: '100',
            y: 70,
            x: 8,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '100';
                })),
        SantoPointData(
            pointText: '100',
            y: 90,
            x: 9,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '100';
                })),
        SantoPointData(
            pointText: '100',
            y: 80,
            x: 10,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '11';
                })),
        SantoPointData(
            pointText: '100',
            y: 100,
            x: 11,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '100';
                })),
      ],
      lineColor: Colors.blue,
    );

    _pointsLine2 = SantoPointsLine(
      lineWidth: 3,
      pointRadius: 4,
      isShowPoint: false,
      isCurve: true,
      points: [
        SantoPointData(
            pointText: '15',
            y: 15,
            x: 1,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '15';
                })),
        SantoPointData(
            pointText: '30',
            y: 30,
            x: 2,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '30';
                })),
        SantoPointData(
            pointText: '17',
            y: 17,
            x: 3,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '17';
                })),
        SantoPointData(
            pointText: '18',
            y: 25,
            x: 4,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '18';
                })),
        SantoPointData(
            pointText: '13',
            y: 40,
            x: 5,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '13';
                })),
        SantoPointData(
            pointText: '16',
            y: 30,
            x: 6,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '16';
                })),
        SantoPointData(
            pointText: '49',
            y: 49,
            x: 7,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '49';
                })),
        SantoPointData(
            pointText: '66',
            y: 66,
            x: 8,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '66';
                })),
        SantoPointData(
            pointText: '77',
            y: 80,
            x: 9,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '77';
                })),
        SantoPointData(
            pointText: '88',
            y: 90,
            x: 10,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '88';
                })),
        SantoPointData(
            pointText: '99',
            y: 60,
            x: 11,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '99';
                })),
      ],
      shaderColors: [
        Colors.green.withOpacity(0.3),
        Colors.green.withOpacity(0.01)
      ],
      lineColor: Colors.green,
    );

    pointsLineList.add(pointsLine);
    pointsLineList.add(_pointsLine2);
    return pointsLineList;
  }

  List<SantoDialItem> _yDialValuesForExample4() {
    return [
      SantoDialItem(
        dialText: '0',
        dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF808695)),
        value: 0,
      ),
      SantoDialItem(
        dialText: '33.3',
        dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF808695)),
        value: 33.3,
      ),
      SantoDialItem(
        dialText: '66.6',
        dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF808695)),
        value: 66.6,
      ),
      SantoDialItem(
        dialText: '100',
        dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF808695)),
        value: 100,
      ),
      SantoDialItem(
        dialText: '120',
        dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF808695)),
        value: 120,
      )
    ];
  }

  List<SantoDialItem> _getXDialValuesForExample4(List<SantoPointsLine> lines) {
    List<SantoDialItem> _xDialValue = [];
    for (int index = 0; index < lines[0].points.length; index++) {
      _xDialValue.add(SantoDialItem(
        dialText: '${lines[0].points[index].x}',
        dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF808695)),
        value: lines[0].points[index].x,
      ));
    }
    return _xDialValue;
  }

///////////////////////
  Widget _brokenLineExample5(context) {
    var chartLine = SantoBrokenLine(
      contentPadding: EdgeInsets.only(left: 20, right: 10),
      lines: _getPointsLineListWithShowPointText(),
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 5 * 1.6 - 20 * 2),
      isShowXHintLine: true,
      yHintLineOffset: 30,
      yDialValues: _yDialValuesForExample5(),
      yDialMin: 0,
      yDialMax: 120,
      xDialValues:
          _getXDialValuesForExample5(_getPointsLineListWithShowPointText()),
      xDialMin: 1,
      xDialMax: 11,
      isHintLineSolid: false,
      isShowYDialText: true,
    );
    return Container(
      child: Column(
        children: <Widget>[
          _buildIdentificationList(),
          SizedBox(
            height: 16,
          ),
          chartLine
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }

  List<SantoDialItem> _yDialValuesForExample5() {
    return [
      SantoDialItem(
        dialText: '0',
        dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF808695)),
        value: 0,
      ),
      SantoDialItem(
        dialText: '33.3',
        dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF808695)),
        value: 33.3,
      ),
      SantoDialItem(
        dialText: '66.6',
        dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF808695)),
        value: 66.6,
      ),
      SantoDialItem(
        dialText: '100',
        dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF808695)),
        value: 100,
      ),
      SantoDialItem(
        dialText: '120',
        dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF808695)),
        value: 120,
      )
    ];
  }

  _getXDialValuesForExample5(List<SantoPointsLine> lines) {
    List<SantoDialItem> _xDialValue = [];
    for (int index = 0; index < lines[0].points.length; index++) {
      _xDialValue.add(SantoDialItem(
        dialText: '${lines[0].points[index].x}',
        dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF808695)),
        value: lines[0].points[index].x,
      ));
    }
    return _xDialValue;
  }

  List<SantoPointsLine> _getPointsLineListWithShowPointText() {
    SantoPointsLine pointsLine, _pointsLine2;
    List<SantoPointsLine> pointsLineList = [];
    pointsLine = SantoPointsLine(
      lineWidth: 3,
      pointRadius: 4,
      pointColor: Colors.blue,
      pointInnerColor: Colors.black12,
      pointInnerRadius: 1.5,
      isShowPoint: true,
      isShowPointText: true,
      isCurve: false,
      lineColor: Colors.blue,
      points: [
        SantoPointData(
            pointText: '9999.99',
            pointTextStyle: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 12, color: Colors.red),
            y: 80,
            x: 1,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return Container(
                    alignment: Alignment.center,
                    width: 40,
                    height: 40,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 30,
                            color: Colors.orange,
                          ),
                          Container(
                            height: 30,
                            color: Colors.greenAccent,
                          ),
                          Container(height: 20, color: Colors.green),
                          Container(height: 20, color: Colors.green),
                          Container(height: 20, color: Colors.blue)
                        ],
                      ),
                    ),
                  );
                })),
        SantoPointData(
            offset: Offset(0, -5),
            pointText: '9999.99',
            pointTextStyle: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 12, color: Colors.red),
            y: 80,
            x: 2,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return Container(
                    padding:
                        EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
                    child: Center(
                        child: Text(
                      'content',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    )),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(2.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0.0, 2.0), //阴影xy轴偏移量
                          blurRadius: 4.0, //阴影模糊程度
                        )
                      ],
                    ),
                  );
                })),
        SantoPointData(
            pointText: '20',
            y: 20,
            x: 3,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '20';
                })),
        SantoPointData(
            pointText: '67',
            y: 67,
            x: 4,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '66';
                })),
        SantoPointData(
            pointText: '10',
            y: 10,
            x: 5,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '10';
                })),
        SantoPointData(
            pointText: '40',
            y: 40,
            x: 6,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '40';
                })),
        SantoPointData(
            pointText: '100',
            y: 60,
            x: 7,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '100';
                })),
        SantoPointData(
            pointText: '100',
            y: 70,
            x: 8,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '100';
                })),
        SantoPointData(
            pointText: '100',
            y: 90,
            x: 9,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '100';
                })),
        SantoPointData(
            pointText: '100',
            y: 80,
            x: 10,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '11';
                })),
        SantoPointData(
            pointText: '100',
            y: 100,
            x: 11,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '100';
                })),
      ],
    );

    _pointsLine2 = SantoPointsLine(
      lineWidth: 3,
      pointRadius: 4,
      isShowPoint: false,
      isCurve: true,
      points: [
        SantoPointData(
            pointText: '1111111',
            y: 15,
            x: 1,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '15';
                })),
        SantoPointData(
            pointText: '30',
            y: 30,
            x: 2,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '30';
                })),
        SantoPointData(
            pointText: '17',
            y: 17,
            x: 3,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '17';
                })),
        SantoPointData(
            pointText: '18',
            y: 25,
            x: 4,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '18';
                })),
        SantoPointData(
            pointText: '13',
            y: 40,
            x: 5,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '13';
                })),
        SantoPointData(
            pointText: '16',
            y: 30,
            x: 6,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '16';
                })),
        SantoPointData(
            pointText: '49',
            y: 49,
            x: 7,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '49';
                })),
        SantoPointData(
            pointText: '66',
            y: 66,
            x: 8,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '66';
                })),
        SantoPointData(
            pointText: '77',
            y: 80,
            x: 9,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '77';
                })),
        SantoPointData(
            pointText: '88',
            y: 90,
            x: 10,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '88';
                })),
        SantoPointData(
            pointText: '99',
            y: 60,
            x: 11,
            lineTouchData: SantoLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '99';
                })),
      ],
      shaderColors: [
        Colors.green.withOpacity(0.3),
        Colors.green.withOpacity(0.01)
      ],
      lineColor: Colors.green,
    );

    pointsLineList.add(pointsLine);
    pointsLineList.add(_pointsLine2);
    return pointsLineList;
  }

  Widget _buildIdentificationList() {
    List<Widget> widgetList = [];
    for (SantoPointsLine bean in _getPointsLinesForExample3()) {
      Widget widget = Row(children: [
        Container(
          height: 3,
          width: 12,
          decoration: BoxDecoration(
              color: bean.lineColor,
              borderRadius: BorderRadius.all(Radius.circular(1.5))),
        ),
        Text('图例', style: TextStyle(fontSize: 12, color: Color(0xFF808695))),
        SizedBox(width: 6),
      ]);

      widgetList.add(widget);
    }
    return Column(mainAxisSize: MainAxisSize.max, children: [
      Container(
          alignment: Alignment.centerLeft,
          child: Text('图表标题',
              style: TextStyle(fontSize: 18, color: Colors.black))),
      Row(children: widgetList),
    ]);
  }
}
