import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// SantoPanel 面板示例
class PanelExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(title: 'Panel 面板'),
      body: ListView(
        children: [
          SantoPanel(
            title: '基础面板',
            child: Text('这是一个基础面板,内容自适应高度,圆角 12px。'),
          ),
          SantoPanel(
            title: '带操作面板',
            actions: [
              SantoNormalButton.outline(
                text: '取消',
                onTap: () => SantoToast.show('点击了取消', context),
              ),
              SizedBox(width: 12),
              SantoNormalButton(
                text: '确定',
                onTap: () => SantoToast.show('点击了确定', context),
              ),
            ],
            child: Text('Header 左侧为标题,右侧为操作按钮区。'),
          ),
          SantoPanel(
            title: '可滚动面板',
            actions: [
              Text(' maxHeight: 120', style: TextStyle(color: Colors.grey)),
            ],
            maxHeight: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                20,
                (i) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text('滚动内容条目 ${i + 1}'),
                ),
              ),
            ),
          ),
          SantoPanel(
            title: '无内容边距面板',
            contentPadding: false,
            child: Container(
              color: Color(0xFFF5F6FA),
              width: double.infinity,
              padding: EdgeInsets.all(16),
              child: Text('contentPadding: false,内容紧贴面板边缘,可自行控制留白。'),
            ),
          ),
        ],
      ),
    );
  }
}
