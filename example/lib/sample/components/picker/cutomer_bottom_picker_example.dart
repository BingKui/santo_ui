

import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/list_item.dart';
import 'package:flutter/material.dart';

class CustomPickerExamplePage extends StatelessWidget {
  CustomPickerExamplePage();

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      scrollable: false,
      child: ListView(
          children: <Widget>[
            SantoSection(
              title: '输入框内容',
              description: 'contentWidget 内放 TextField，autofocus 时被键盘抬起且不遮挡',
              child: ListItem(
                title: "底部弹窗的内容为输入框",
                describe: '被键盘抬起',
                isShowLine: false,
                onPressed: () {
                  SantoBottomPicker.show(context, onCancel: () {
                    Navigator.of(context).pop();
                  },
                      onConfirm: () {},
                      contentWidget: Container(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '键盘抬起，不遮挡picker',
                              style: TextStyle(
                                color: Color(0xFF17233D),
                                fontSize: 20,
                              ),
                            ),
                            TextField(
                              autofocus: true,
                              decoration: InputDecoration(hintText: '请输入'),
                            )
                          ],
                        ),
                      ));
                },
              ),
            ),
            SantoSection(
              title: '确定与取消回调',
              description: 'onConfirm 与 onCancel 返回后不关闭弹窗，便于自定义处理',
              child: ListItem(
                title: "底部弹窗确定取消事件",
                describe: '支持底部弹窗确定取消事件并不关闭弹窗',
                onPressed: () {
                  SantoBottomPicker.show(context, onConfirm: () {
                    SantoToast.show('不关闭', context);
                  }, onCancel: () {
                    SantoToast.show('不关闭', context);
                  },
                      contentWidget: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '通过属性支持确定和取消不关闭弹窗',
                            style: TextStyle(
                              color: Color(0xFF17233D),
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ));
                },
              ),
            ),
            SantoSection(
              title: '隐藏标题栏',
              description: 'showTitle 传 false，弹窗顶部区域留白由 contentWidget 决定',
              child: ListItem(
                title: "底部弹窗不显示title",
                describe: '支持底部弹窗不显示title',
                onPressed: () {
                  SantoBottomPicker.show(context,
                      showTitle: false,
                      contentWidget: Container(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'showTitle 属性设置为 false，不显示顶部title区域，',
                              style: TextStyle(
                                color: Color(0xFF17233D),
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              '其他区域可以完全自定义',
                              style: TextStyle(
                                color: Color(0xFF17233D),
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ));
                },
              ),
            ),
            SantoSection(
              title: '遮罩不可关闭',
              description: 'barrierDismissible 传 false，遮罩手势被忽略，只能点按钮关闭',
              child: ListItem(
                title: "点击遮罩不关闭",
                describe: '支持点击遮罩不关闭',
                onPressed: () {
                  SantoBottomPicker.show(context,
                      barrierDismissible: false,
                      contentWidget: Container(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '键盘抬起，不遮挡picker',
                              style: TextStyle(
                                color: Color(0xFF17233D),
                                fontSize: 20,
                              ),
                            ),
                            TextField(
                              autofocus: true,
                              decoration: InputDecoration(hintText: '请输入'),
                            )
                          ],
                        ),
                      ));
                },
              ),
            ),
          ],
        ),
    );
  }
}
