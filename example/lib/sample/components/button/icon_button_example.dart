import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// @desc    图片和文字随意组合

class SantoIconBtnExample extends StatefulWidget {
  @override
  _SantoIconBtnExampleState createState() => _SantoIconBtnExampleState();
}

class _SantoIconBtnExampleState extends State<SantoIconBtnExample>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(
        title: '图文组合示列',
      ),
      body: SingleChildScrollView(
        child: iconButton(),
      ),
    );
  }

  Widget iconButton() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 50, bottom: 50),
          child: Center(
            child: SantoIconButton(
                name: '文字在下',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF808695),
                ),
                direction: Direction.bottom,
                padding: 4,
                iconHeight: 30,
                iconWidth: 30,
                iconWidget: Icon(Icons.arrow_upward),
                onTap: () {
                  SantoToast.show('按钮被点击', context);
                }),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 50),
          child: Center(
            child: SantoIconButton(
                name: '文字在上',
                direction: Direction.top,
                padding: 4,
                iconWidget: Icon(Icons.assignment),
                onTap: () {
                  SantoToast.show('按钮被点击', context);
                }),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 50),
          child: Center(
            child: SantoIconButton(
                name: '文字在右',
                direction: Direction.right,
                padding: 4,
                iconWidget: Icon(Icons.autorenew),
                onTap: () {
                  SantoToast.show('按钮被点击', context);
                }),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 50),
          child: Center(
            child: SantoIconButton(
                name: '文字在左',
                direction: Direction.left,
                padding: 4,
                iconWidget: Icon(Icons.backspace),
                onTap: () {
                  SantoToast.show('按钮被点击', context);
                }),
          ),
        )
      ],
    );
  }
}
