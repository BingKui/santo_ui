

import 'dart:math';

import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

class ScrollActorTabExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(      title: '锚点',
      scrollable: false,
      children: <Widget>[
        SantoAnchorTab(
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
        ),
      ],
    );
  }
}
