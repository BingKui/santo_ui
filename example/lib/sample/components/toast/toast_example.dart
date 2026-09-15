

import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

class ToastExample extends StatefulWidget {
  @override
  _ToastExampleState createState() => _ToastExampleState();
}

class _ToastExampleState extends State<ToastExample>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(
        title: 'SantoToast示例',
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SantoNormalButton(
                onTap: () {
                  SantoToast.show(
                    "普通长Toast",
                    context,
                    duration: SantoDuration.long,
                    gravity: SantoToastGravity.center,
                  );
                },
                child: Text("普通长Toast"),
              ),
              SantoNormalButton(
                onTap: () {
                  SantoToast.show(
                    "失败图标Toast",
                    context,
                    preIcon: Image.asset(
                      "assets/image/icon_toast_fail.png",
                      width: 24,
                      height: 24,
                    ),
                    duration: SantoDuration.short,
                  );
                },
                child: Text("失败图标Toast"),
              ),
              SantoNormalButton(
                onTap: () {
                  SantoToast.show(
                    "成功图标Toast",
                    context,
                    preIcon: Image.asset(
                      "assets/image/icon_toast_success.png",
                      width: 24,
                      height: 24,
                    ),
                    duration: SantoDuration.short,
                  );
                },
                child: Text("成功图标Toast"),
              ),
              SantoNormalButton(
                onTap: () {
                  SantoToast.show("自定义位置Toast", context,
                      duration: SantoDuration.short,
                      verticalOffset: 100,
                      gravity: SantoToastGravity.bottom);
                },
                child: Text("自定义位置Toast"),
              ),
              SantoNormalButton(
                onTap: () {
                  SantoToast.show(
                    "自定义时长Toast",
                    context,
                    duration: Duration(seconds: 5),
                  );
                },
                child: Text("自定义时长Toast(5s)"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
