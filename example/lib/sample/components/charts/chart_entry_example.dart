

import 'dart:math';
import 'package:santo_ui/santo_ui.dart';

import 'package:flutter/material.dart';

class FunnelChartExamplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      // Here we take the value from the MyHomePage object that was created by
      // the App.build method, and use it to set our appbar title.
      title: '漏斗图',
      padding: EdgeInsets.zero,
      scrollable: false,
      child: FunnelChartExample(),
    );
  }
}

class FunnelChartExample extends StatefulWidget {
  FunnelChartExample({Key? key}) : super(key: key);

  @override
  _FunnelChartExampleState createState() => _FunnelChartExampleState();
}

class _FunnelChartExampleState extends State<FunnelChartExample> {
  late double maxLayerWidth;
  late double minLayerWidth;
  late double layerMargin;
  late double layerHeight;
  late double offsetX;
  late double offsetY;
  late MarkerAlignment alignment;
  FunnelShape? shape;
  bool defaultStyle = false;

  @override
  void initState() {
    super.initState();
    maxLayerWidth = 240;
    minLayerWidth = 100;
    layerMargin = 0;
    layerHeight = 40;
    offsetX = 0;
    offsetY = 0;
    alignment = MarkerAlignment.right;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 漏斗形态:单侧与双侧
          SantoSection(
            title: '单侧与双侧漏斗',
            description: '同一组数据分别以 leftOrRight 与 leftAndRight 形态绘制',
            child: Column(
              children: [
                SantoFunnelChart(
                  shape: FunnelShape.leftOrRight,
                  alignment: MarkerAlignment.right,
                  maxLayerWidth: maxLayerWidth,
                  minLayerWidth: minLayerWidth,
                  layerMargin: layerMargin,
                  layerHeight: layerHeight,
                  markerCount: 5,
                  childOffset: Offset(offsetX, offsetY),
                  layerPainter: SantoDefaultFunnelLayerPainter(
                      titles: ['layer1', 'layer2', 'layer3', 'layer4', 'layer5']),
                  layerCount: 5,
                  builder: (index) {
                    return Container(
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Widget${index.toString()}',
                              style: TextStyle(color: Colors.black, fontSize: 14),
                            ),
                          ]),
                    );
                  },
                ),
                Container(
                  height: 10,
                ),
                SantoFunnelChart(
                  shape: FunnelShape.leftAndRight,
                  alignment: alignment,
                  maxLayerWidth: maxLayerWidth,
                  minLayerWidth: minLayerWidth,
                  layerMargin: layerMargin,
                  layerHeight: layerHeight,
                  markerCount: 5,
                  childOffset: Offset(offsetX, offsetY),
                  layerPainter: SantoDefaultFunnelLayerPainter(
                      titles: ['layer1', 'layer2', 'layer3', 'layer4', 'layer5']),
                  layerCount: 5,
                  builder: (index) {
                    return Container(
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Widget${index.toString()}',
                              style: TextStyle(color: Colors.black, fontSize: 14),
                            ),
                          ]),
                    );
                  },
                ),
              ],
            ),
          ),
          // layer 宽度约束
          SantoSection(
            title: 'layer 宽度范围',
            description: 'minLayerWidth 与 maxLayerWidth 互相约束，拖动时不会越过对方',
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text('layer最小宽度'),
                    ),
                    Expanded(
                      child: SantoSlider(
                          value: minLayerWidth,
                          divisions: 100,
                          onChanged: (data) {
                            setState(() {
                              if (minLayerWidth >= maxLayerWidth) {
                                minLayerWidth = maxLayerWidth - 1;
                              } else {
                                minLayerWidth = data;
                              }
                            });
                            debugPrint('change:$data');
                          },
                          onChangeStart: (data) {
                            debugPrint('start:$data');
                          },
                          onChangeEnd: (data) {
                            debugPrint('end:$data');
                          },
                          min: 0,
                          max: maxLayerWidth,
                          label: '${minLayerWidth.toStringAsFixed(0)}',
                          activeColor: Colors.green,
                          inactiveColor: Colors.grey,
                          semanticFormatterCallback: (double newValue) {
                            return '${newValue.round()}}';
                          }),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text('layer最大宽度'),
                    ),
                    Expanded(
                      child: SantoSlider(
                          value: maxLayerWidth,
                          divisions: 100,
                          onChanged: (data) {
                            setState(() {
                              if (maxLayerWidth <= minLayerWidth) {
                                maxLayerWidth = minLayerWidth + 1;
                              } else {
                                maxLayerWidth = data;
                              }
                            });
                            debugPrint('change:$data');
                          },
                          onChangeStart: (data) {
                            debugPrint('start:$data');
                          },
                          onChangeEnd: (data) {
                            debugPrint('end:$data');
                          },
                          min: minLayerWidth,
                          max: 300.0,
                          label: '${maxLayerWidth.toStringAsFixed(0)}',
                          activeColor: Colors.green,
                          inactiveColor: Colors.grey,
                          semanticFormatterCallback: (double newValue) {
                            return '${newValue.round()}}';
                          }),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // layer 间距与高度
          SantoSection(
            title: 'layer 间距与高度',
            description: 'layerMargin 调整层与层间距，layerHeight 调整每层高度',
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text('layer间距'),
                    ),
                    Expanded(
                      child: SantoSlider(
                          value: layerMargin,
                          divisions: 100,
                          onChanged: (data) {
                            setState(() {
                              layerMargin = data;
                            });
                            debugPrint('change:$data');
                          },
                          onChangeStart: (data) {
                            debugPrint('start:$data');
                          },
                          onChangeEnd: (data) {
                            debugPrint('end:$data');
                          },
                          min: 0,
                          max: 100,
                          label: '${layerMargin.toStringAsFixed(0)}',
                          activeColor: Colors.green,
                          inactiveColor: Colors.grey,
                          semanticFormatterCallback: (double newValue) {
                            return '${newValue.round()}}';
                          }),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text('layer高度'),
                    ),
                    Expanded(
                      child: SantoSlider(
                          value: layerHeight,
                          divisions: 100,
                          onChanged: (data) {
                            setState(() {
                              layerHeight = data;
                            });
                            debugPrint('change:$data');
                          },
                          onChangeStart: (data) {
                            debugPrint('start:$data');
                          },
                          onChangeEnd: (data) {
                            debugPrint('end:$data');
                          },
                          min: 1,
                          max: 100,
                          label: '${layerHeight.toStringAsFixed(0)}',
                          activeColor: Colors.green,
                          inactiveColor: Colors.grey,
                          semanticFormatterCallback: (double newValue) {
                            return '${newValue.round()}}';
                          }),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text('layer高度'),
                    ),
                    Expanded(
                      child: SantoSlider(
                          value: layerHeight,
                          divisions: 100,
                          onChanged: (data) {
                            setState(() {
                              layerHeight = data;
                            });
                            debugPrint('change:$data');
                          },
                          onChangeStart: (data) {
                            debugPrint('start:$data');
                          },
                          onChangeEnd: (data) {
                            debugPrint('end:$data');
                          },
                          min: 1,
                          max: 100,
                          label: '${layerHeight.toStringAsFixed(0)}',
                          activeColor: Colors.green,
                          inactiveColor: Colors.grey,
                          semanticFormatterCallback: (double newValue) {
                            return '${newValue.round()}}';
                          }),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // builder 内容的 X、Y 偏移
          SantoSection(
            title: 'Widget 偏移量',
            description: 'childOffset 通过 X、Y 偏移移动 builder 内容，范围 -25 到 25',
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text('Widget X偏移量'),
                    ),
                    Expanded(
                      child: SantoSlider(
                          value: offsetX,
                          divisions: 50,
                          onChanged: (data) {
                            setState(() {
                              offsetX = data;
                            });
                            debugPrint('change:$data');
                          },
                          onChangeStart: (data) {
                            debugPrint('start:$data');
                          },
                          onChangeEnd: (data) {
                            debugPrint('end:$data');
                          },
                          min: -25,
                          max: 25,
                          label: '${offsetX.toStringAsFixed(0)}',
                          activeColor: Colors.green,
                          inactiveColor: Colors.grey,
                          semanticFormatterCallback: (double newValue) {
                            return '${newValue.round()}}';
                          }),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text('Widget Y偏移量'),
                    ),
                    Expanded(
                      child: SantoSlider(
                          value: offsetY,
                          divisions: 50,
                          onChanged: (data) {
                            setState(() {
                              offsetY = data;
                            });
                            debugPrint('change:$data');
                          },
                          onChangeStart: (data) {
                            debugPrint('start:$data');
                          },
                          onChangeEnd: (data) {
                            debugPrint('end:$data');
                          },
                          min: -25,
                          max: 25,
                          label: '${offsetY.toStringAsFixed(0)}',
                          activeColor: Colors.green,
                          inactiveColor: Colors.grey,
                          semanticFormatterCallback: (double newValue) {
                            return '${newValue.round()}}';
                          }),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 双侧漏斗的标签对齐方式
          SantoSection(
            title: '标签位置',
            description: 'alignment 支持居左、居中、居右，改变双侧漏斗标签的排布',
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text('标签位置'),
                ),
                SantoNormalButton.outline(
                  onTap: () {
                    setState(() {
                      alignment = MarkerAlignment.left;
                    });
                  },
                  text: '居左',
                ),
                SantoNormalButton.outline(
                  onTap: () {
                    setState(() {
                      alignment = MarkerAlignment.center;
                    });
                  },
                  text: '居中',
                ),
                SantoNormalButton.outline(
                  onTap: () {
                    setState(() {
                      alignment = MarkerAlignment.right;
                    });
                  },
                  text: '居右',
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RadarChartExamplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      appBar: SantoAppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: '雷达图',
      ),
      padding: EdgeInsets.zero,
      child: RadarChartExample(),
    );
  }
}

class RadarChartExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RadarChartExampleState();
  }
}

class _RadarChartExampleState extends State<RadarChartExample>
    with SingleTickerProviderStateMixin {
  late double radius;
  int? sideCount;
  double? angle;
  late double padding;
  Map<String, List<double>> dataList1 = Map();

  Map<String, List<double>> dataList2 = Map();

  late AnimationController controller;
  late Animation<double> animation;
  bool defaultStyle = false;

  @override
  void initState() {
    super.initState();
    radius = 80;
    sideCount = 6;
    padding = 4;
    angle = 0;
    for (int i = 3; i <= 8; i++) {
      List<double> data1 = [];
      List<double> data2 = [];

      for (int j = 0; j < i; j++) {
        data1.add(Random().nextDouble() * 10);
        data2.add(Random().nextDouble() * 10);
      }
      dataList1[i.toString()] = data1;
      dataList2[i.toString()] = data2;
    }
    controller = new AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    animation = new CurvedAnimation(parent: controller, curve: Curves.ease);
    animation = new Tween(begin: 0.0, end: 1.0).animate(animation);
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // 雷达图绘制与顶点标签
        SantoSection(
          title: '数据与顶点标签',
          description: 'provider 返回两组数据，builder 自定义各顶点标签的内容',
          child: Column(
            children: <Widget>[
              AnimatedBuilder(
                  animation: animation,
                  builder: (_, _) {
                    if (defaultStyle) {
                      return SantoRadarChart.defaultStyle(
                        radius: radius,
                        sidesCount: 5,
                        markerMargin: padding,
                        rotateAngle: angle! * 2 * pi / 360,
                        data: [
                          dataList1[sideCount.toString()]!,
                          dataList2[sideCount.toString()]!
                        ],
                        tagNames: [
                          '合作共赢诚实守信',
                          '合作共赢诚实守信',
                          '合作共赢诚实守信',
                          '合作共赢诚实守信',
                          '合作共赢诚实守信'
                        ],
                      );
                    } else {
                      return SantoRadarChart(
                        radius: radius,
                        provider: RadarProvider(sideCount, dataList1, dataList2),
                        sidesCount: sideCount!,
                        markerMargin: padding,
                        crossedAxisLine: true,
                        rotateAngle: angle! * 2 * pi / 360,
                        animateProgress: animation.value,
                        builder: (index) {
                          return Text(
                            '顶点${index.toString()}',
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          );
                        },
                      );
                    }
                  }),
            ],
          ),
        ),
        // 半径与标签间距
        SantoSection(
          title: '半径与标签间距',
          description: 'radius 与 markerMargin 分别控制图形半径、标签与图形的距离',
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text('半径'),
                  ),
                  Expanded(
                    child: SantoSlider(
                        value: radius,
                        divisions: 100,
                        onChanged: (data) {
                          setState(() {
                            radius = data;
                          });
                          debugPrint('change:$data');
                        },
                        onChangeStart: (data) {
                          debugPrint('start:$data');
                        },
                        onChangeEnd: (data) {
                          debugPrint('end:$data');
                        },
                        min: 1,
                        max: 150,
                        label: '${radius.toStringAsFixed(0)}',
                        activeColor: Colors.green,
                        inactiveColor: Colors.grey,
                        semanticFormatterCallback: (double newValue) {
                          return '${newValue.round()}}';
                        }),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text('标签间距'),
                  ),
                  Expanded(
                    child: SantoSlider(
                        value: padding,
                        divisions: 10,
                        onChanged: (data) {
                          setState(() {
                            padding = data;
                          });
                          debugPrint('change:$data');
                        },
                        onChangeStart: (data) {
                          debugPrint('start:$data');
                        },
                        onChangeEnd: (data) {
                          debugPrint('end:$data');
                        },
                        min: 0,
                        max: 10,
                        label: '${padding.toStringAsFixed(0)}',
                        activeColor: Colors.green,
                        inactiveColor: Colors.grey,
                        semanticFormatterCallback: (double newValue) {
                          return '${newValue.round()}}';
                        }),
                  ),
                ],
              ),
            ],
          ),
        ),
        // 边数与旋转角度
        SantoSection(
          title: '边数与旋转角度',
          description: 'sidesCount 与 rotateAngle 变化时重播入场动画，改完立即生效',
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text('边数'),
                  ),
                  Expanded(
                    child: SantoSlider(
                        value: sideCount!.toDouble(),
                        divisions: 6,
                        onChanged: (data) {
                          if (data.toInt() != sideCount) {
                            setState(() {
                              sideCount = data.toInt();
                              controller.reset();
                              controller.forward();
                            });
                          }
                        },
                        onChangeStart: (data) {
                          debugPrint('start:$data');
                        },
                        onChangeEnd: (data) {
                          debugPrint('end:$data');
                        },
                        min: defaultStyle ? sideCount!.toDouble() : 3,
                        max: defaultStyle ? sideCount!.toDouble() : 8,
                        label: '${sideCount!.toStringAsFixed(0)}',
                        activeColor: Colors.green,
                        inactiveColor: Colors.grey,
                        semanticFormatterCallback: (double newValue) {
                          return '${newValue.round()}}';
                        }),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text('旋转角度'),
                  ),
                  Expanded(
                    child: SantoSlider(
                        value: angle!.toDouble(),
                        divisions: 360,
                        onChanged: (data) {
                          if (data.toDouble() != angle) {
                            setState(() {
                              angle = data.toDouble();
                              controller.reset();
                              controller.forward();
                            });
                          }
                        },
                        onChangeStart: (data) {
                          debugPrint('start:$data');
                        },
                        onChangeEnd: (data) {
                          debugPrint('end:$data');
                        },
                        min: 0,
                        max: 360,
                        label: '${angle!.toStringAsFixed(0)}',
                        activeColor: Colors.green,
                        inactiveColor: Colors.grey,
                        semanticFormatterCallback: (double newValue) {
                          return '${newValue.round()}}';
                        }),
                  ),
                ],
              ),
            ],
          ),
        ),
        // 预设样式与自定义样式对比
        SantoSection(
          title: '预设风格切换',
          description: 'defaultStyle 在预设样式与自定义绘制样式之间切换',
          child: MaterialButton(
            onPressed: () {
              setState(() {
                sideCount = 5;
                defaultStyle = !defaultStyle;
              });
            },
            color: Colors.orange,
            child: Text(defaultStyle ? '使用自定义风格' : '使用默认风格'),
          ),
        )
      ],
    );
  }
}

class RadarProvider extends SantoRadarChartDataProvider {
  final Map<String, List<double>> dataList1;

  final Map<String, List<double>> dataList2;

  final int? sideCount;

  RadarProvider(this.sideCount, this.dataList1, this.dataList2);

  @override
  int getRadarCount() {
    return 2;
  }

  @override
  SantoRadarChartStyle getRadarStyle(int radarIndex) {
    switch (radarIndex) {
      case 0:
        return const SantoRadarChartStyle(
          strokeColor: Colors.blue,
          areaColor: Color(0x332196F3),
          dotted: true,
          dotColor: Colors.blue,
        );
      case 1:
        return const SantoRadarChartStyle(
          strokeColor: Colors.green,
          areaColor: Color(0x334CAF50),
          dotted: true,
          dotColor: Colors.green,
        );
    }
    return const SantoRadarChartStyle(
      strokeColor: Colors.blue,
      strokeWidth: 1,
      areaColor: Color(0x332196F3),
      dotted: true,
      dotColor: Colors.blue,
      dotRadius: 2,
    );
  }

  @override
  List<double> getRadarValues(int radarIndex) {
    switch (radarIndex) {
      case 0:
        return dataList1[sideCount.toString()]!;
      case 1:
        return dataList2[sideCount.toString()]!;
    }
    return dataList1[sideCount.toString()]!;
  }
}
