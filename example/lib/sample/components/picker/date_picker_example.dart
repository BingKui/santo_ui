
import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/list_item.dart';
import 'package:flutter/material.dart';

class DatePickerExamplePage extends StatelessWidget {
  final String _title;

  DatePickerExamplePage(this._title);

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      appBar: SantoAppBar(
          title: _title,
        ),
        children: <Widget>[
          SantoSection(
            title: '基础模式',
            description: 'pickerMode 支持 time、date 与 datetime 三种选择类型',
            child: Column(
              children: <Widget>[
                ListItem(
                  title: "TimeStyle",
                  describe: '时间样式选择器',
                  onPressed: () {
                    _showPicker(context, SantoDateTimePickerMode.time);
                  },
                ),
                ListItem(
                  title: "DateStyle",
                  describe: '日期样式时间选择器',
                  onPressed: () {
                    _showPicker(context, SantoDateTimePickerMode.date);
                  },
                ),
                ListItem(
                  title: "DateAndTimeStyle",
                  describe: '日期和时间样式选择器',
                  onPressed: () {
                    _showPicker(context, SantoDateTimePickerMode.datetime);
                  },
                ),
              ],
            ),
          ),
          SantoSection(
            title: '时间范围选择',
            description:
                'isLimitTimeRange 传 false 时两端不受限，minuteDivider 控制间隔步长',
            child: Column(
              children: <Widget>[
                ListItem(
                  title: "Time Range Style",
                  describe: '时间范围选择器',
                  onPressed: () {
                    _showRangePicker(
                        context, SantoDateTimeRangePickerMode.time);
                  },
                ),
                ListItem(
                  title: "Time Range Style",
                  describe: '时间范围选择器-不限制选择的时间范围',
                  onPressed: () {
                    _showRangePickerNoLimited(
                        context, SantoDateTimeRangePickerMode.time);
                  },
                ),
              ],
            ),
          ),
          SantoSection(
            title: '日期范围选择',
            description:
                'dateFormat 可传 yyyy年-MM月-dd日 等格式，isDismissible 控制遮罩关闭',
            child: Column(
              children: <Widget>[
                ListItem(
                  title: "Date Range Style",
                  describe: '日期范围选择器',
                  onPressed: () {
                    _showRangePicker(
                        context, SantoDateTimeRangePickerMode.date);
                  },
                ),
                ListItem(
                  title: "Date Range Style",
                  describe: '日期范围选择器(yyyy年MM月dd日)',
                  onPressed: () {
                    _showyyyyMMddRangePicker(context);
                  },
                ),
              ],
            ),
          ),
        ],
    );
  }

//  ///时间样式时间选择器
//  void _showTimeStyle(BuildContext context) {
//    DatePickerWidget(
//      context: context,
//      title: "请选择开始看房时间",
//      mode: CupertinoDatePickerMode.time,
//      minuteInterval: 20,
//      currentDate: DateTime.now(),
//      confirmTimeClick: (date) {
//        print("the date is ${date.toString()}");
//      },
//    ).show();
//  }
//
//  ///日期样式选择器
//  void _showDateStyle(BuildContext context) {
//    DatePickerWidget(
//      context: context,
//      title: "请选择入住时间",
//      mode: CupertinoDatePickerMode.date,
//      minYear: 2019,
//      currentDate: DateTime.now(),
//      confirmTimeClick: (date) {
//        print("the date is ${date.toString()}");
//      },
//    ).show();
//  }
//
//  ///日期和时间样式选择器
//  void _showDateAndTimeStyle(BuildContext context) {
//    DatePickerWidget(
//      context: context,
//      title: "请选择入住时间",
//      mode: CupertinoDatePickerMode.dateAndTime,
//      minDate: DateTime.now(),
//      currentDate: DateTime.now(),
//      confirmTimeClick: (date) {
//        print("the date is ${date.toString()}");
//      },
//    ).show();
//  }

  _showPicker(BuildContext context, SantoDateTimePickerMode mode) {
    String format;
    const String MIN_DATETIME = '2020-01-15 00:00:00';
    const String MAX_DATETIME = '2021-12-31 23:59:59';
    switch (mode) {
      case SantoDateTimePickerMode.date:
        format = 'yyyy年,MMMM月,dd日';
        break;
      case SantoDateTimePickerMode.datetime:
        format = 'yyyy年,MM月,dd日,HH时:mm分:ss秒';
        break;
      case SantoDateTimePickerMode.time:
        format = 'HH:mm:ss';
        break;
    }

    SantoDatePicker.showDatePicker(context,
        maxDateTime: DateTime.parse(MAX_DATETIME),
        minDateTime: DateTime.parse(MIN_DATETIME),
        initialDateTime: DateTime.parse('2020-01-01 18:26:59'),
        pickerMode: mode,
        minuteDivider: 30,
        pickerTitleConfig: SantoPickerTitleConfig.Default,
        dateFormat: format, onConfirm: (dateTime, list) {
      SantoToast.show("onConfirm:  $dateTime   $list", context);
    }, onClose: () {
      print("onClose");
    }, onCancel: () {
      print("onCancel");
    }, onChanged: (dateTime, list) {
      print("onChanged:  $dateTime    $list");
    });
  }

  _showRangePickerNoLimited(
      BuildContext context, SantoDateTimeRangePickerMode mode) {
    String format;
    const String MIN_DATETIME = '2020-01-01 00:00:00';
    const String MAX_DATETIME = '2020-12-31 23:59:59';
    format = 'HH时:mm分';
    SantoPickerTitleConfig timePickerTheme = SantoPickerTitleConfig(
        title: SantoPickerTitleConfig.Default.title,
        showTitle: pickerShowTitleDefault,
        titleContent: "选择时间范围");
    SantoDateRangePicker.showDatePicker(context,
        minDateTime: DateTime.parse(MIN_DATETIME),
        maxDateTime: DateTime.parse(MAX_DATETIME),
        pickerMode: mode,
        isLimitTimeRange: false,
        minuteDivider: 10,
        pickerTitleConfig: timePickerTheme,
        dateFormat: format,
        initialStartDateTime: DateTime(2020, 06, 21, 08, 00, 00),
        initialEndDateTime: DateTime(2020, 06, 23, 10, 00, 00),
        onConfirm: (startDateTime, endDateTime, startlist, endlist) {
      SantoToast.show(
          "onConfirm:  $startDateTime   $endDateTime     $startlist     $endlist",
          context);
    }, onClose: () {
      print("onClose");
    }, onCancel: () {
      print("onCancel");
    }, onChanged: (startDateTime, endDateTime, startlist, endlist) {
      SantoToast.show(
          "onChanged:  $startDateTime   $endDateTime     $startlist     $endlist",
          context);
    });
  }

  _showRangePicker(BuildContext context, SantoDateTimeRangePickerMode mode) {
    String format;
    const String MIN_DATETIME = '2020-01-01 00:00:00';
    const String MAX_DATETIME = '2020-12-31 23:59:59';
    switch (mode) {
      case SantoDateTimeRangePickerMode.date:
        format = 'MM月-dd日';
        SantoPickerTitleConfig pickerTitleConfig =
            SantoPickerTitleConfig(titleContent: "选择时间范围");
        SantoDateRangePicker.showDatePicker(context,
            isDismissible: false,
            minDateTime: DateTime.parse(MIN_DATETIME),
            maxDateTime: DateTime.parse(MAX_DATETIME),
            pickerMode: SantoDateTimeRangePickerMode.date,
            pickerTitleConfig: pickerTitleConfig,
            dateFormat: format,
            initialStartDateTime: DateTime(2021, 06, 21, 11, 00, 00),
            initialEndDateTime: DateTime(2021, 06, 23, 10, 00, 00),
            onConfirm: (startDateTime, endDateTime, startlist, endlist) {
          SantoToast.show(
              "onConfirm:  $startDateTime   $endDateTime     $startlist     $endlist",
              context);
        }, onClose: () {
          print("onClose");
        }, onCancel: () {
          print("onCancel");
        }, onChanged: (startDateTime, endDateTime, startlist, endlist) {
          SantoToast.show(
              "onChanged:  $startDateTime   $endDateTime     $startlist     $endlist",
              context);
        });
        break;

      case SantoDateTimeRangePickerMode.time:
        format = 'HH时:mm分';
        SantoPickerTitleConfig pickerTitleConfig =
            SantoPickerTitleConfig(titleContent: "选择时间范围");
        SantoDateRangePicker.showDatePicker(context,
            minDateTime: DateTime.parse(MIN_DATETIME),
            maxDateTime: DateTime.parse(MAX_DATETIME),
            pickerMode: mode,
            minuteDivider: 10,
            pickerTitleConfig: pickerTitleConfig,
            dateFormat: format,
            initialStartDateTime: DateTime(2020, 06, 21, 08, 00, 00),
            initialEndDateTime: DateTime(2020, 06, 23, 10, 00, 00),
            onConfirm: (startDateTime, endDateTime, startlist, endlist) {
          SantoToast.show(
              "onConfirm:  $startDateTime   $endDateTime     $startlist     $endlist",
              context);
        }, onClose: () {
          print("onClose");
        }, onCancel: () {
          print("onCancel");
        }, onChanged: (startDateTime, endDateTime, startlist, endlist) {
          SantoToast.show(
              "onChanged:  $startDateTime   $endDateTime     $startlist     $endlist",
              context);
        });
        break;
    }
  }

  void _showyyyyMMddRangePicker(BuildContext context) {
    String format = 'yyyy年-MM月-dd日';
    SantoPickerTitleConfig pickerTitleConfig =
        SantoPickerTitleConfig(titleContent: "选择时间范围");
    SantoDateRangePicker.showDatePicker(context,
        isDismissible: false,
        minDateTime: DateTime(2010, 06, 01, 00, 00, 00),
        maxDateTime: DateTime(2029, 07, 24, 23, 59, 59),
        pickerMode: SantoDateTimeRangePickerMode.date,
        minuteDivider: 10,
        pickerTitleConfig: pickerTitleConfig,
        dateFormat: format,
        initialStartDateTime: DateTime(2020, 06, 21, 11, 00, 00),
        initialEndDateTime: DateTime(2020, 06, 23, 10, 00, 00),
        onConfirm: (startDateTime, endDateTime, startlist, endlist) {
      SantoToast.show(
          "onConfirm:  $startDateTime   $endDateTime     $startlist     $endlist",
          context);
    }, onClose: () {
      print("onClose");
    }, onCancel: () {
      print("onCancel");
    }, onChanged: (startDateTime, endDateTime, startlist, endlist) {
      SantoToast.show(
          "onChanged:  $startDateTime   $endDateTime     $startlist     $endlist",
          context);
    });
  }
}
