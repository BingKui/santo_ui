import 'package:santo_ui/src/components/picker/base/santo_picker_title_config.dart';
import 'package:santo_ui/src/components/picker/santo_picker_cliprrect.dart';
import 'package:santo_ui/src/components/picker/time_picker/santo_date_picker_constants.dart';
import 'package:santo_ui/src/components/picker/time_picker/santo_date_time_formatter.dart';
import 'package:santo_ui/src/components/picker/time_picker/date_range_picker/santo_date_range_widget.dart';
import 'package:santo_ui/src/components/picker/time_picker/date_range_picker/santo_time_range_widget.dart';
import 'package:santo_ui/src/theme/santo_theme.dart';
import 'package:santo_ui/src/utils/i18n/santo_date_picker_i18n.dart';
import 'package:flutter/material.dart';

/// 时间范围选择展示模式
enum SantoDateTimeRangePickerMode {
  /// 日期模式，仅展示到 月、日
  date,

  /// 时间模式，仅展示到 时、分、秒
  time,
}

/// 从底部弹出时间范围选择 Picker
class SantoDateRangePicker {
  /// isDismissible[bool]点击背景是否自动消失
  /// minDateTime: [DateTime] 可选的最小时间
  /// maxDateTime: [DateTime] 可选的最大时间
  /// isLimitTimeRange: [bool] 是否显示开始时间必须小于等于结束时间，默认为 true，仅在 [SantoDateTimeRangePickerMode] 为 time 时生效
  /// initialDateTime: [DateTime] 初始化选中时间
  /// dateFormat: [String] 时间展示格式，如：yyyy 年 MM 月 dd 日
  /// minuteDivider：[int] 分钟展示间隔，默认值为 1
  /// locale: [DateTimePickerLocale] internationalization
  /// pickerMode: [SantoDateTimeRangePickerMode] 展示的 mode: date(DatePicker)、time(TimePicker)
  /// onCancel: [DateVoidCallback] 取消回调
  /// onClose: [DateVoidCallback] 关闭回调
  /// onChanged: [DateValueCallback] 时间变化回调
  /// onConfirm: [DateValueCallback] 点击确认的回调
  /// pickerTitleConfig: [SantoPickerTitleConfig] Picker title 配置
  /// themeData: [SantoPickerConfig] 主题配置
  static void showDatePicker(
    BuildContext context, {
    bool isDismissible = true,
    DateTime? minDateTime,
    DateTime? maxDateTime,
    bool isLimitTimeRange = true,
    DateTime? initialStartDateTime,
    DateTime? initialEndDateTime,
    String? dateFormat,
    int minuteDivider = 1,
    DateTimePickerLocale locale = datetimePickerLocaleDefault,
    SantoDateTimeRangePickerMode pickerMode = SantoDateTimeRangePickerMode.date,
    SantoPickerTitleConfig pickerTitleConfig = SantoPickerTitleConfig.Default,
    DateVoidCallback? onCancel,
    DateVoidCallback? onClose,
    DateRangeValueCallback? onChanged,
    DateRangeValueCallback? onConfirm,
    SantoPickerConfig? themeData,
  }) {
    // handle the range of datetime
    if (minDateTime == null) {
      minDateTime = DateTime.parse(datePickerMinDatetime);
    }
    if (maxDateTime == null) {
      maxDateTime = DateTime.parse(datePickerMaxDatetime);
    }

    // handle initial DateTime
    if (initialStartDateTime == null) {
      initialStartDateTime = DateTime.now();
    }

    // Set value of date format
    dateFormat =
        DateTimeFormatter.generateDateRangePickerFormat(dateFormat, pickerMode);

    Navigator.push(
      context,
      _DatePickerRoute(
        minDateTime: minDateTime,
        maxDateTime: maxDateTime,
        isLimitTimeRange: isLimitTimeRange,
        initialStartDateTime: initialStartDateTime,
        initialEndDateTime: initialEndDateTime,
        dateFormat: dateFormat,
        minuteDivider: minuteDivider,
        pickerMode: pickerMode,
        pickerTitleConfig: pickerTitleConfig,
        onCancel: onCancel,
        onChanged: onChanged,
        onConfirm: onConfirm,
        isDismissible: isDismissible,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        themeData: themeData,
      ),
    ).whenComplete(onClose ?? () {});
  }
}

class _DatePickerRoute<T> extends PopupRoute<T> {
  final DateTime? minDateTime,
      maxDateTime,
      initialStartDateTime,
      initialEndDateTime;
  final bool isLimitTimeRange;
  final String? dateFormat;
  final SantoDateTimeRangePickerMode pickerMode;
  final SantoPickerTitleConfig pickerTitleConfig;
  final VoidCallback? onCancel;
  final DateRangeValueCallback? onChanged;
  final DateRangeValueCallback? onConfirm;
  final int minuteDivider;
  final ThemeData? theme;
  final bool? isDismissible;
  SantoPickerConfig? themeData;

  _DatePickerRoute({
    this.minDateTime,
    this.maxDateTime,
    this.isLimitTimeRange = true,
    this.initialStartDateTime,
    this.initialEndDateTime,
    this.minuteDivider = 1,
    this.dateFormat,
    this.pickerMode = SantoDateTimeRangePickerMode.date,
    this.pickerTitleConfig = SantoPickerTitleConfig.Default,
    this.onCancel,
    this.onChanged,
    this.onConfirm,
    this.theme,
    this.barrierLabel,
    this.isDismissible,
    this.themeData,
    RouteSettings? settings,
  }) : super(settings: settings) {
    this.themeData ??= SantoPickerConfig();
    this.themeData = SantoThemeConfigurator.instance
        .getConfig(configId: this.themeData!.configId)
        .pickerConfig
        .merge(this.themeData);
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  bool get barrierDismissible => isDismissible ?? true;

  @override
  final String? barrierLabel;

  @override
  Color get barrierColor =>
      SantoThemeConfigurator.instance.getConfig().commonConfig.fillMask;

  AnimationController? _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController =
        BottomSheet.createAnimationController(navigator!.overlay!);
    return _animationController!;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    double height = themeData!.pickerHeight;
    if (pickerTitleConfig.title != null || pickerTitleConfig.showTitle) {
      height += themeData!.titleHeight;
    }

    Widget bottomSheet = MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: _DatePickerComponent(
        route: this,
        pickerHeight: height,
      ),
    );

    if (theme != null) {
      bottomSheet = Theme(data: theme!, child: bottomSheet);
    }
    return bottomSheet;
  }
}

class _DatePickerComponent extends StatelessWidget {
  final _DatePickerRoute route;
  final double _pickerHeight;

  _DatePickerComponent({required this.route, required pickerHeight})
      : this._pickerHeight = pickerHeight;

  @override
  Widget build(BuildContext context) {
    Widget? pickerWidget;
    switch (route.pickerMode) {
      case SantoDateTimeRangePickerMode.date:
        pickerWidget = SantoDateRangeWidget(
          minDateTime: route.minDateTime,
          maxDateTime: route.maxDateTime,
          initialStartDateTime: route.initialStartDateTime,
          initialEndDateTime: route.initialEndDateTime,
          dateFormat: route.dateFormat,
          pickerTitleConfig: route.pickerTitleConfig,
          onCancel: route.onCancel,
          onChanged: route.onChanged,
          onConfirm: route.onConfirm,
          themeData: route.themeData,
        );
        break;
      case SantoDateTimeRangePickerMode.time:
        pickerWidget = SantoTimeRangeWidget(
          minDateTime: route.minDateTime,
          maxDateTime: route.maxDateTime,
          isLimitTimeRange: route.isLimitTimeRange,
          initialStartDateTime: route.initialStartDateTime,
          initialEndDateTime: route.initialEndDateTime,
          minuteDivider: route.minuteDivider,
          dateFormat: route.dateFormat,
          pickerTitleConfig: route.pickerTitleConfig,
          onCancel: route.onCancel,
          onChanged: route.onChanged,
          onConfirm: route.onConfirm,
          themeData: route.themeData,
        );
        break;
    }
    return GestureDetector(
      child: AnimatedBuilder(
        animation: route.animation!,
        builder: (BuildContext context, Widget? child) {
          return ClipRect(
            child: CustomSingleChildLayout(
              delegate:
                  _BottomPickerLayout(route.animation!.value, _pickerHeight),
              child: SantoPickerClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(route.themeData!.cornerRadius),
                  topRight: Radius.circular(route.themeData!.cornerRadius),
                ),
                child: pickerWidget,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BottomPickerLayout extends SingleChildLayoutDelegate {
  _BottomPickerLayout(this.progress, this.contentHeight);

  final double progress;
  final double contentHeight;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      minHeight: 0.0,
      maxHeight: contentHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    double height = size.height - childSize.height * progress;
    return Offset(0.0, height);
  }

  @override
  bool shouldRelayout(_BottomPickerLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
