

import 'dart:math';

import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';

class AnchorExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(      title: 'Anchor 锚点',
      scrollable: false,
      children: <Widget>[
        ExampleIntro('anchor'),
        // 锚点组件自带滚动,用 Expanded 给它一个有界高度
        Expanded(
            child: SantoAnchor(
          itemCount: 20,
          widgetIndexedBuilder: (context, index) {
            return StatefulBuilder(builder: (_, state) {
              double height = Random().nextInt(400).toDouble();
              return GestureDetector(child: Container(
                child: Center(child: Text('$index')),
                height: height,
                color: Color.fromARGB(Random().nextInt(255), Random().nextInt(255),
                    Random().nextInt(255), Random().nextInt(255)),
              ),
              onTap: (){
                state(() {});
              },);
            });
          },
          tabIndexedBuilder: (context, index) {
            return BadgeTab(text: 'index $index');
          },
        )),
      ],
    );
  }
}
