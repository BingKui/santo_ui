import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

class LoadingExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(
        title: 'Loading案例',
      ),
      body: Center(
          child: Column(children: [
        SantoSection(
          title: '默认文案 Loading',
          description: '不传 content 时展示本地化默认加载文案',
          child: SantoPageLoading(),
        ),
        SantoSection(
          title: '短文案 Loading',
          description: 'content 较短时加载弹层宽度自适应收窄',
          child: SantoPageLoading(
            content: "我是较短的 Loading",
          ),
        ),
        SantoSection(
          title: '长文案 Loading',
          description: 'content 超长时受最大宽度限制并省略号截断',
          child: SantoPageLoading(
            content: "我是较长的我是较长的我是较长的Loading",
          ),
        )
      ])),
    );
  }
}
