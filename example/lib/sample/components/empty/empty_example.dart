

import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

class EmptyExample extends StatelessWidget {
  final int? caseIndex;

  EmptyExample({this.caseIndex});

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(      title: '异常页面',
        scrollable: false,
        child: _buildEmpty(caseIndex, context) ?? const SizedBox.shrink());
  }

  Widget? _buildEmpty(int? index, BuildContext context) {
    Widget? widget;
    switch (index) {
      case 0:
        widget = SantoEmpty(
          img: Image.asset(
            'assets/image/content_failed.png',
            scale: 3.0,
          ),
          isCenterVertical: true,
          title: "获取数据失败，请重试",
          operateTexts: <String>["请点击页面重试"],
          operateAreaType: OperateAreaType.textButton,
          action: (index) {
            SantoToast.show("获取数据失败，请重试", context);
          },
        );
        break;
      case 1:
        widget = SantoEmpty(
          isCenterVertical: true,
          img: Image.asset(
            'assets/image/no_data.png',
            scale: 3.0,
          ),
          title: SantoIntl.of(context).localizedResource.noDataTip,
        );
        break;
      case 2:
        widget = SantoEmpty(
          img: Image.asset(
            'assets/image/network_error.png',
            scale: 3.0,
          ),
          title: '网络数据异常',
        );
        break;
      case 3:
        widget = SantoEmpty(
          img: Image.asset(
            'assets/image/no_data.png',
            scale: 3.0,
          ),
          content: '您的门店暂无用户',
        );
        break;
      case 4:
        widget = SantoEmpty(
          img: Image.asset(
            'assets/image/no_data.png',
            scale: 3.0,
          ),
          title: "这是副标题内容这是副标题内容这是副标",
          content: '您的门店暂无用户',
          operateAreaType: OperateAreaType.singleButton,
          operateTexts: ["切换账号"],
          action: (index) {
            SantoToast.show("第$index个按钮被点击了", context);
          },
        );
        break;
      case 5:
        widget = SantoEmpty(
          img: Image.asset(
            'assets/image/no_data.png',
            scale: 3.0,
          ),
          title: "暂无",
          content: '您还没有在维护的信息哦',
          operateAreaType: OperateAreaType.doubleButton,
          operateTexts: ['去添加', '去修改'],
          action: (index) {
            SantoToast.show("第$index个按钮被点击了", context);
          },
        );
        break;
      case 6:
        widget = SantoEmpty(
          content: '您的门店暂无用户',
        );
        break;
    }

    return widget;
  }
}
