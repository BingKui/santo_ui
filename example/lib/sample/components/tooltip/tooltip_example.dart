

import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// SantoTooltip 文字提示示例
class TooltipExample extends StatefulWidget {
  const TooltipExample({Key? key}) : super(key: key);

  @override
  State<TooltipExample> createState() => _TooltipExampleState();
}

class _TooltipExampleState extends State<TooltipExample> {
  GlobalKey? _leftKey;
  GlobalKey? _leftKey1;
  GlobalKey? _leftKey2;
  GlobalKey? _leftKey3;
  GlobalKey? _leftKey4;
  GlobalKey? _leftKey5;
  GlobalKey? _leftKey6;
  GlobalKey? _leftKey7;

  SantoOverlayController? overlayController;

  @override
  void initState() {
    super.initState();
    _leftKey = GlobalKey();
    _leftKey1 = GlobalKey();
    _leftKey2 = GlobalKey();
    _leftKey3 = GlobalKey();
    _leftKey4 = GlobalKey();
    _leftKey5 = GlobalKey();
    _leftKey6 = GlobalKey();
    _leftKey7 = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(      title: 'Tooltip 文字提示',
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SantoSection(
              title: '左侧弹出',
              description: 'hasCloseIcon 控制气泡右上角关闭按钮的显隐，长文案自动换行',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 10, top: 10),
                    child: SantoNormalButton(
                      key: _leftKey,
                      onTap: () {
                        SantoTooltip.show(context, "提示内容", _leftKey!,
                            hasCloseIcon: true);
                      },
                      child: Text("左侧带关闭"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: SantoNormalButton(
                      key: _leftKey1,
                      onTap: () {
                        SantoTooltip.show(
                            context, "提示内容提示内容提示内容提示内容提示内容提示内容提示内容提示内容", _leftKey1!,
                            hasCloseIcon: false);
                      },
                      child: Text("左侧带无关闭"),
                    ),
                  ),
                ],
              ),
            ),
            SantoSection(
              title: '左侧向上弹出',
              description: 'popDirection 传 top 时气泡翻到按钮上方，箭头指向下方',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: SantoNormalButton(
                      key: _leftKey2,
                      onTap: () {
                        SantoTooltip.show(context,
                            "提示内容提示内容提示内容提示内容提示内容提示内容提示内容提示内容提示内容", _leftKey2!,
                            popDirection: SantoPopupDirection.top,
                            hasCloseIcon: true);
                      },
                      child: Text("左侧带关闭，箭头朝下"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: SantoNormalButton(
                      key: _leftKey3,
                      onTap: () {
                        SantoTooltip.show(
                            context, "提示内容提示内容提示内容提示内容提示内容提示内容提示内容提示内容", _leftKey3!,
                            dismissCallback: () {},
                            popDirection: SantoPopupDirection.top);
                      },
                      child: Text("左侧无关闭，箭头朝下"),
                    ),
                  ),
                ],
              ),
            ),
            SantoSection(
              title: '右侧弹出',
              description: '锚点靠右时气泡自动向左对齐，dismissCallback 感知关闭',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 250),
                    child: SantoNormalButton(
                      key: _leftKey4,
                      onTap: () {
                        SantoTooltip.show(
                            context, "提示内容提示内容提示内容提示内容提示内容提示内容提示内容提示内容", _leftKey4!,
                            hasCloseIcon: true,
                            dismissCallback: () {},
                            popDirection: SantoPopupDirection.bottom);
                      },
                      child: Text("右侧带关闭"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 250),
                    child: SantoNormalButton(
                      key: _leftKey5,
                      onTap: () {
                        SantoTooltip.show(
                            context, "提示内容提示内容提示内容提示内容", _leftKey5!,
                            hasCloseIcon: false,
                            dismissCallback: () {},
                            popDirection: SantoPopupDirection.bottom);
                      },
                      child: Text("右侧无关闭"),
                    ),
                  ),
                ],
              ),
            ),
            SantoSection(
              title: '右侧向上弹出',
              description: 'canWrap 传 false 时提示文案不换行，超出宽度被截断',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 250),
                    child: SantoNormalButton(
                      key: _leftKey6,
                      onTap: () {
                        SantoTooltip.show(
                            context, "提示内容提示内容提示内容提示内容提示内容提示内容", _leftKey6!,
                            hasCloseIcon: true,
                            canWrap: false,
                            dismissCallback: () {},
                            popDirection: SantoPopupDirection.top);
                      },
                      child: Text("右侧带关闭，箭头朝下"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 250),
                    child: SantoNormalButton(
                      key: _leftKey7,
                      onTap: () {
                        SantoTooltip.show(
                            context, "提示内容提示内容提示内容提示内容提示内容提示内容", _leftKey7!,
                            hasCloseIcon: false,
                            dismissCallback: () {},
                            popDirection: SantoPopupDirection.top);
                      },
                      child: Text("右侧无关闭，箭头朝下"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }
}
