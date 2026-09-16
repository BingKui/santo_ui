import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

class SantoSwitchButtonExample extends StatefulWidget {
  @override
  _SantoSwitchButtonExampleState createState() =>
      _SantoSwitchButtonExampleState();
}

class _SantoSwitchButtonExampleState extends State<SantoSwitchButtonExample> {
  bool value1 = true;
  bool value2 = true;
  bool value3 = false;
  bool value5 = true;
  bool loadingValue = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(
        title: '开关元件',
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SantoSection(
              title: '基础用法',
              description: 'value 与 onChanged 双向绑定，点击切换开关状态',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SantoBubbleText(maxLines: 2, text: '具备选中、未选中、以及禁用状态'),
                  SizedBox(height: 12),
                  SantoSwitchButton(
                    value: value1,
                    onChanged: (value) {
                      setState(() {
                        value1 = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            SantoSection(
              title: '禁用状态',
              description: 'enabled 为 false 时组件置灰且不可切换',
              child: SantoSwitchButton(
                enabled: false,
                value: value2,
                onChanged: (value) {
                  setState(() {
                    value2 = value;
                  });
                },
              ),
            ),
            SantoSection(
              title: '未选中状态',
              description: 'value 为 false 时展示未选中的灰色轨道',
              child: SantoSwitchButton(
                value: value3,
                onChanged: (value) {
                  setState(() {
                    value3 = value;
                  });
                },
              ),
            ),
            SantoSection(
              title: '加载状态',
              description: 'loading 为 true 时显示加载指示器并禁用交互',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SantoSwitchButton(
                    value: loadingValue,
                    loading: true,
                    onChanged: (value) {
                      setState(() {
                        loadingValue = value;
                      });
                    },
                  ),
                  SizedBox(height: 8),
                  Text('loading 时显示加载指示器并禁用交互',
                      style: TextStyle(fontSize: 13, color: Colors.grey)),
                ],
              ),
            ),
            SantoSection(
              title: '自定义大小',
              description: 'size 传入 Size 自定义开关的宽高尺寸',
              child: SantoSwitchButton(
                size: Size(80, 40),
                value: value5,
                onChanged: (value) {
                  setState(() {
                    value5 = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
