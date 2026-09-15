

import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

///标签选择view
class CalendarViewExample extends StatefulWidget {
  final String _title;

  CalendarViewExample(this._title);

  @override
  State<StatefulWidget> createState() => TagViewExamplePageState();
}

class TagViewExamplePageState extends State<CalendarViewExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SantoAppBar(
          title: widget._title,
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: ListView(
            children: <Widget>[
              Text('单选-无控制-周视图'),
              _calendarViewWeekNocontroll(context),
              SantoLine(
                height: 40.0,
              ),
              Text('单选-无控制-周视图-自定义 WeekName'),
              _calendarViewWeekNocontrollCustomWeekName(context),
              SantoLine(
                height: 40.0,
              ),
              Text('单选-周视图'),
              _calendarViewWeek(context),
              SantoLine(
                height: 40.0,
              ),
              Text('范围选-周视图'),
              _calendarViewWeekRange(context),
              SantoLine(
                height: 40.0,
              ),
              Text('单选-月视图'),
              _calendarViewMonth(context),
              SantoLine(
                height: 40.0,
              ),
              Text('范围选-月视图'),
              _calendarViewMonthRange(context),
            ],
          ),
        ));
  }

  Widget _calendarViewWeekNocontroll(context) {
    return SantoCalendarView.single(
      displayMode: DisplayMode.week,
      showControllerBar: false,
      dateChange: (date) {
        SantoToast.show('选中的时间： $date', context);
      },
    );
  }

  Widget _calendarViewWeekNocontrollCustomWeekName(context) {
    return SantoCalendarView.single(
      displayMode: DisplayMode.week,
      showControllerBar: false,
      weekNames: ['星期天', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'],
      dateChange: (date) {
        SantoToast.show('选中的时间： $date', context);
      },
    );
  }

  Widget _calendarViewWeek(context) {
    return SantoCalendarView.single(
      displayMode: DisplayMode.week,
      initDisplayDate: DateTime.parse('2020-06-01'),
      minDate: DateTime(2020),
      maxDate: DateTime(2021),
      dateChange: (date) {
        SantoToast.show('选中的时间： $date', context);
      },
    );
  }

  Widget _calendarViewWeekRange(context) {
    return SantoCalendarView.range(
      displayMode: DisplayMode.week,
      rangeDateChange: (rangeDate) {
        SantoToast.show(
            '开始时间： ${rangeDate.start} , 结束时间：${rangeDate.end}', context);
      },
    );
  }

  Widget _calendarViewMonth(context) {
    return SantoCalendarView.single(
      initDisplayDate: DateTime.parse('2020-06-01'),
      minDate: DateTime(2020),
      maxDate: DateTime(2021),
      dateChange: (date) {
        SantoToast.show('选中的时间： $date', context);
      },
    );
  }

  Widget _calendarViewMonthRange(context) {
    return SantoCalendarView.range(
      minDate: DateTime(2020),
      maxDate: DateTime(2023),
      rangeDateChange: (rangeDate) {
        SantoToast.show(
            '开始时间： ${rangeDate.start} , 结束时间：${rangeDate.end}', context);
      },
    );
  }
}
