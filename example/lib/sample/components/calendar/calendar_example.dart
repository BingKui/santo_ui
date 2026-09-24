

import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';

///标签选择view
class CalendarExample extends StatefulWidget {
  final String _title;

  CalendarExample(this._title);

  @override
  State<StatefulWidget> createState() => TagViewExamplePageState();
}

class TagViewExamplePageState extends State<CalendarExample> {
  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      appBar: SantoAppBar(
          title: widget._title,
        ),
      children: <Widget>[
        ExampleIntro('calendar'),
        SantoSection(
          title: '单选-无控制-周视图',
          description: 'showControllerBar 为 false，仅渲染一周日期区域',
          child: _calendarViewWeekNocontroll(context),
        ),
        SantoSection(
          title: '单选-无控制-周视图-自定义 WeekName',
          description: 'weekNames 传入星期天、星期一等文案，覆盖默认星期显示',
          child: _calendarViewWeekNocontrollCustomWeekName(context),
        ),
        SantoSection(
          title: '单选-周视图',
          description: '带控制条，initDisplayDate 指定初始展示日期',
          child: _calendarViewWeek(context),
        ),
        SantoSection(
          title: '范围选-周视图',
          description: 'rangeDateChange 回调返回起止日期 start 与 end',
          child: _calendarViewWeekRange(context),
        ),
        SantoSection(
          title: '单选-月视图',
          description: '按月网格展示，minDate 与 maxDate 限定 2020 至 2021 年',
          child: _calendarViewMonth(context),
        ),
        SantoSection(
          title: '范围选-月视图',
          description: 'range 模式下的月视图范围选择，initStartSelectedDate / '
              'initEndSelectedDate 给定初始区间，可选区间为 2020 至 2023 年',
          child: _calendarViewMonthRange(context),
        ),
      ],
    );
  }

  Widget _calendarViewWeekNocontroll(context) {
    return SantoCalendar.single(
      displayMode: DisplayMode.week,
      showControllerBar: false,
      dateChange: (date) {
        SantoToast.show('选中的时间： $date', context);
      },
    );
  }

  Widget _calendarViewWeekNocontrollCustomWeekName(context) {
    return SantoCalendar.single(
      displayMode: DisplayMode.week,
      showControllerBar: false,
      weekNames: ['星期天', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'],
      dateChange: (date) {
        SantoToast.show('选中的时间： $date', context);
      },
    );
  }

  Widget _calendarViewWeek(context) {
    return SantoCalendar.single(
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
    return SantoCalendar.range(
      displayMode: DisplayMode.week,
      rangeDateChange: (rangeDate) {
        SantoToast.show(
            '开始时间： ${rangeDate.start} , 结束时间：${rangeDate.end}', context);
      },
    );
  }

  Widget _calendarViewMonth(context) {
    return SantoCalendar.single(
      initDisplayDate: DateTime.parse('2020-06-01'),
      minDate: DateTime(2020),
      maxDate: DateTime(2021),
      dateChange: (date) {
        SantoToast.show('选中的时间： $date', context);
      },
    );
  }

  Widget _calendarViewMonthRange(context) {
    return SantoCalendar.range(
      initDisplayDate: DateTime.parse('2020-06-01'),
      initStartSelectedDate: DateTime.parse('2020-06-10'),
      initEndSelectedDate: DateTime.parse('2020-06-18'),
      minDate: DateTime(2020),
      maxDate: DateTime(2023),
      rangeDateChange: (rangeDate) {
        SantoToast.show(
            '开始时间： ${rangeDate.start} , 结束时间：${rangeDate.end}', context);
      },
    );
  }
}
