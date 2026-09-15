import 'package:santo_ui/src/theme/santo_theme_configurator.dart';
import 'package:flutter/material.dart';

class SantoDialItem {
  /// 刻度标志内容
  String? dialText;

  /// 刻度标志样式
  TextStyle? dialTextStyle;

  /// 刻度选中样式
  TextStyle? selectedDialTextStyle;

  /// x,y 轴刻度值。用于刻度在坐标的真实定位
  double value;

  SantoDialItem(
      {this.dialText,
      this.dialTextStyle,
      this.selectedDialTextStyle,
      required this.value});
}

class SantoPointData {
  /// x点的值
  double x;

  /// y点的值
  double y;

  /// PointData展示的相对偏移量
  Offset offset;

  /// 点要展示的内容
  String? pointText;

  /// 点展示内容样式
  TextStyle? pointTextStyle;

  /// 折线节点的点击击事件是否可用
  bool isClickable;

  /// 点击时附加信息展示
  SantoLineTouchData lineTouchData;

  SantoPointData(
      {this.x = 0,
      this.y = 0,
      this.offset = const Offset(0, 0),
      this.pointText,
      this.pointTextStyle,
      this.isClickable = true,
      required this.lineTouchData}) {
    pointText ??= '$y';
    pointTextStyle ??= TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 12,
        color: SantoThemeConfigurator.instance
            .getConfig()
            .commonConfig
            .colorTextBase);
  }
}

class SantoLineTouchData {
  /// 用于临时存储要展示 tip 内容在坐标的位置
  double? x, y;

  /// 要展示 tip 的相对偏移量
  Offset tipOffset;

  /// 要展示的 tip 的宽高
  Size tipWindowSize;

  /// 点击回调，由于返回 展示内容（String 或 Widget）
  Function()? onTouch;

  SantoLineTouchData({
    required this.tipWindowSize,
    this.tipOffset = const Offset(0, 0),
    this.onTouch,
  });
}

/// 每条线的定义
class SantoPointsLine {
  /// 点集合
  List<SantoPointData> points;

  /// 线宽
  double lineWidth;

  /// Line渐变色，从曲线到x轴从上到下的闭合颜色集
  List<Color>? shaderColors;

  /// 曲线或折线的颜色
  Color lineColor;

  /// 点外圈的颜色
  Color? pointColor;

  /// 点的外半径参数
  double pointRadius;

  /// 点内圈的颜色
  Color? pointInnerColor;

  /// 点内圈的半径
  double? pointInnerRadius;

  /// 标记是否为曲线
  bool isCurve;

  /// 是否绘制折线节点。
  bool isShowPoint;

  ///  是否展示节点的文本
  bool isShowPointText;

  SantoPointsLine(
      {this.lineWidth = 2,
      this.pointRadius = 0,
      this.pointColor,
      this.pointInnerRadius,
      this.pointInnerColor,
      this.isCurve = false,
      required this.points,
      this.isShowPoint = true,
      this.isShowPointText = false,
      this.shaderColors,
      this.lineColor = Colors.purple}) {
    pointColor ??= lineColor;
    pointInnerColor ??= lineColor;
    pointInnerRadius ??= pointRadius - 1.5;
  }
}
