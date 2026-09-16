

import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

class GroupAddExamplePage extends StatelessWidget {

  GroupAddExamplePage();

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: Text(
                "基本样式：",
                style: TextStyle(
                  color: Color(0xFF17233D),
                  fontSize: 22,
                ),
              ),
            ),
            SantoAddLabel(
              title: "添加组",
              onTap: () {
                SantoToast.show("点击触发onTap回调", context);
              },
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
              child: Text(
                "全功能样式-禁用：",
                style: TextStyle(
                  color: Color(0xFF17233D),
                  fontSize: 22,
                ),
              ),
            ),
            SantoAddLabel(
              isEdit: false,
              title: "添加组",
              onTap: () {
                SantoToast.show("点击触发onTap回调", context);
              },
            ),
          ],
    );
  }
}
