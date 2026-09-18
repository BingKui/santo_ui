

import 'dart:async';

import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:example/sample/components/actionsheet/actionsheet_selected_list_custom_example.dart';
import 'package:example/sample/components/actionsheet/actionsheet_selected_list_example.dart';
import 'package:example/sample/home/list_item.dart';
import 'package:flutter/material.dart';

class ActionSheetEntryPage extends StatefulWidget {
  final title;

  ActionSheetEntryPage(this.title);

  @override
  _ActionSheetEntryPageState createState() => _ActionSheetEntryPageState();
}

class _ActionSheetEntryPageState extends State<ActionSheetEntryPage> {
  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      appBar: SantoAppBar(
          title: widget.title,
        ),
        children: <Widget>[
          ExampleIntro('actionsheet'),
          ListItem(
            title: "CommonActionSheet",
            describe: '通用样式ActionSheet，无独立辅助信息',
            onPressed: () {
              _showCommonStylex();
            },
          ),
          ListItem(
            title: "CommonActionSheet",
            describe: '通用样式ActionSheet，包含描述信息',
            onPressed: () {
              _showCommonStyle(context);
            },
          ),
          ListItem(
            title: "CommonActionSheet",
            describe: '通用样式ActionSheet，不包含描述信息',
            onPressed: () {
              _showCommonStyle1(context);
            },
          ),
          ListItem(
            title: "CommonActionSheet",
            describe: '蓝色样式ActionSheet，不包含描述信息',
            onPressed: () {
              _showCommonStyle2(context);
            },
          ),
          ListItem(
            title: "CommonActionSheet",
            describe: '通用样式ActionSheet，自定义textstyle',
            onPressed: () {
              _showCommonCustomStyle(context);
            },
          ),
          ListItem(
            title: "CommonActionSheet",
            describe: '通用样式ActionSheet，选项名动态变化',
            onPressed: () {
              _showChangeableStyle(context);
            },
          ),
          ListItem(
            title: "已选菜单列表",
            describe: '已选菜单列表',
            onPressed: () {
              _showSelectedListActionSheet(context);
            },
          ),
          ListItem(
            title: "已选菜单列表自定义视图",
            describe: '已选菜单列表自定义视图',
            onPressed: () {
              _showCustomSelectedListActionSheet(context);
            },
          ),
        ],
    );
  }

  void _showCommonStyle(BuildContext context) {
    List<SantoCommonActionSheetItem> actions = [];
    actions.add(SantoCommonActionSheetItem(
      '选项一（警示项）',
      desc: '辅助信息辅助信息辅助信息',
      actionStyle: SantoCommonActionSheetItemStyle.alert,
    ));
    actions.add(SantoCommonActionSheetItem(
      '选项二',
      desc: '辅助信息辅助信息辅助信息',
      actionStyle: SantoCommonActionSheetItemStyle.normal,
    ));
    actions.add(SantoCommonActionSheetItem(
      '选项三',
      desc: '辅助信息辅助信息辅助信息',
      actionStyle: SantoCommonActionSheetItemStyle.normal,
    ));

    // 展示actionSheet
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return SantoCommonActionSheet(
            title: "辅助内容辅助内容辅助内容辅助内容辅助内容辅助内容辅助内容辅助内容辅助内容辅助内容辅助内容辅助内容",
            actions: actions,
            cancelTitle: "自定义取消名称",
            clickCallBack: (int index, SantoCommonActionSheetItem actionEle) {
              String? title = actionEle.title;
              SantoToast.show("title: $title, index: $index", context);
            },
          );
        });
  }

  void _showCommonStylex() {
    List<SantoCommonActionSheetItem> actions = [];
    // 构建标题+辅助信息的普通项
    actions.add(SantoCommonActionSheetItem(
      '选项一（警示项）',
      desc: '辅助信息辅助信息辅助信息辅助信息',
      actionStyle: SantoCommonActionSheetItemStyle.alert,
    ));
    // 构建标题+辅助信息的普通项
    actions.add(SantoCommonActionSheetItem(
      '选项二',
      desc: '辅助信息辅助信息辅助信息',
      actionStyle: SantoCommonActionSheetItemStyle.normal,
    ));
    // 构建只有标题的普通项
    actions.add(SantoCommonActionSheetItem(
      '选项三',
      actionStyle: SantoCommonActionSheetItemStyle.normal,
    ));
    // 构建不带标题栏的actionSheet
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return SantoCommonActionSheet(
            actions: actions,
            clickCallBack: (int index, SantoCommonActionSheetItem actionEle) {
              String? title = actionEle.title;
              SantoToast.show("title: $title, index: $index", context);
            },
          );
        });
  }

  void _showCommonStyle1(BuildContext context) {
    List<SantoCommonActionSheetItem> actions = [];
    actions.add(SantoCommonActionSheetItem(
      '选项一（警示项）',
      actionStyle: SantoCommonActionSheetItemStyle.alert,
    ));
    actions.add(SantoCommonActionSheetItem(
      '选项二',
      actionStyle: SantoCommonActionSheetItemStyle.normal,
    ));
    actions.add(SantoCommonActionSheetItem(
      '选项三',
      actionStyle: SantoCommonActionSheetItemStyle.normal,
    ));

    // 展示actionSheet
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return SantoCommonActionSheet(
            actions: actions,
            clickCallBack: (
              int index,
              SantoCommonActionSheetItem actionEle,
            ) {
              String? title = actionEle.title;
              SantoToast.show("title: $title, index: $index", context);
            },
          );
        });
  }

  void _showCommonStyle2(BuildContext context) {
    List<SantoCommonActionSheetItem> actions = [];
    actions.add(SantoCommonActionSheetItem(
      '选项一: （010）1234567',
      actionStyle: SantoCommonActionSheetItemStyle.link,
    ));
    actions.add(SantoCommonActionSheetItem(
      '选项二:（010）1234567',
      actionStyle: SantoCommonActionSheetItemStyle.link,
    ));
    actions.add(SantoCommonActionSheetItem(
      '选项三',
      actionStyle: SantoCommonActionSheetItemStyle.link,
    ));

    // 展示actionSheet
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return SantoCommonActionSheet(
            title: "电话等蓝色样式的需求",
            actions: actions,
            clickCallBack: (
              int index,
              SantoCommonActionSheetItem actionEle,
            ) {
              String? title = actionEle.title;
              SantoToast.show("title: $title, index: $index", context);
            },
          );
        });
  }

  void _showCommonCustomStyle(BuildContext context) {
    List<SantoCommonActionSheetItem> actions = [];
    actions.add(
      SantoCommonActionSheetItem(
        '选项一: 自定义主标题样式',
        desc: '辅助信息默认样式',
        titleStyle: TextStyle(
          fontSize: 18,
          color: Color(0xFF123984),
        ),
      ),
    );
    actions.add(
      SantoCommonActionSheetItem(
        '选项二: 自定义辅助信息样式',
        desc: '自定义辅助信息样式',
        descStyle: TextStyle(
          fontSize: 14,
          color: Color(0xFF129834),
        ),
      ),
    );
    actions.add(
      SantoCommonActionSheetItem(
        '选项三: 自定义拦截点击事件，点击无效',
        desc: '辅助信息',
        titleStyle: TextStyle(
          fontSize: 16,
          color: Color(0xFF808695),
        ),
        descStyle: TextStyle(
          fontSize: 14,
          color: Color(0xFF808695),
        ),
      ),
    );

    // 展示actionSheet
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return SantoCommonActionSheet(
            title: "自定义点击拦截事件，选项三点击不反回，其他选项点击事件正常，并且自定义标题最大行数为3行，超出会截断会截断会截断",
            actions: actions,
            maxTitleLines: 3,
            clickCallBack: (
              int index,
              SantoCommonActionSheetItem actionEle,
            ) {
              String? title = actionEle.title;
              SantoToast.show("title: $title, index: $index", context);
            },
            onItemClickInterceptor: (
              int index,
              SantoCommonActionSheetItem actionEle,
            ) {
              // 选项三点击事件被拦截，不作处理
              if (index == 2) {
                SantoToast.show("被拦截了", context);
                return true;
              }
              // 其他选项正常
              return false;
            },
          );
        });
  }

  void _showChangeableStyle(BuildContext context) {
    // 倒数次数
    var countdown = 10;
    // 用于控制timer只加载一次
    var started = false;
    // 计时器
    late Timer periodTimer;
    List<SantoCommonActionSheetItem> actions = [];
    actions.add(SantoCommonActionSheetItem(
      '倒计时:$countdown',
      actionStyle: SantoCommonActionSheetItemStyle.alert,
    ));
    actions.add(SantoCommonActionSheetItem(
      '选项二',
      actionStyle: SantoCommonActionSheetItemStyle.normal,
    ));
    actions.add(SantoCommonActionSheetItem(
      '选项三',
      actionStyle: SantoCommonActionSheetItemStyle.normal,
    ));
    // 展示actionSheet
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          // 通过statefulBuilder可以实现动态变换选项文案（本example只作为使用参考，请根据具体情况选择方式）
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            if (!started) {
              started = true;
              // 设置timer，每1秒循环一次
              periodTimer = Timer.periodic(Duration(seconds: 1), (timer) {
                if (countdown > 0) {
                  countdown = countdown - 1;
                  setState(() {
                    // 循环刷新当前时间,变换title
                    actions[0].title = '倒计时:$countdown';
                    // 变化特定辅助信息
                    var times = 10 - countdown;
                    actions[0].desc = '倒计时:$times';
                  });
                } else if (countdown == 0) {
                  periodTimer.cancel();
                }
              });
            }
            return SantoCommonActionSheet(
              actions: actions,
              clickCallBack: (
                int index,
                SantoCommonActionSheetItem actionEle,
              ) {
                // 点击后立即停止计时
                periodTimer.cancel();
                var title = actionEle.title;
                SantoToast.show("title: $title, index: $index", context);
              },
            );
          });
          // then用来在pop折后停止timer，如果不需要在pop后进行操作，不需要使用then
        }).then((value) {
      periodTimer.cancel();
    });
  }

  void _showSelectedListActionSheet(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) {
        return SelectedListActionSheetExamplePage();
      },
    ));
  }

  void _showCustomSelectedListActionSheet(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) {
        return SelectedListActionSheetCustomExamplePage();
      },
    ));
  }
}
