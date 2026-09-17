import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// Fab 悬浮按钮示例页面
class FabExample extends StatefulWidget {
  @override
  _FabExampleState createState() => _FabExampleState();
}

class _FabExampleState extends State<FabExample> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: 'Fab 悬浮按钮示例',
      // 右下角悬浮按钮会盖住内容末尾,底部留出避让
      bottomInset: 80,
      children: <Widget>[
        // 基础用法
        SantoSection(
          title: '基础用法',
          description: '圆形悬浮按钮，通过 backgroundColor 自定义底色',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('圆形悬浮按钮，支持自定义图标和颜色',
                  style: TextStyle(fontSize: 13, color: Colors.grey)),
              SizedBox(height: 16),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // 默认蓝色
                    SantoFab(
                      icon: Icons.add,
                      onPressed: () {
                        _showSnackBar('点击了默认蓝色按钮');
                      },
                    ),
                    // 绿色
                    SantoFab(
                      icon: Icons.check,
                      backgroundColor: Color(0xFF52C41A),
                      onPressed: () {
                        _showSnackBar('点击了绿色按钮');
                      },
                    ),
                    // 红色
                    SantoFab(
                      icon: Icons.close,
                      backgroundColor: Color(0xFFFF4D4F),
                      onPressed: () {
                        _showSnackBar('点击了红色按钮');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 不同大小
        SantoSection(
          title: '不同大小',
          description: 'size 分别设为 40、56、72，对比圆形按钮的直径',
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SantoFab(
                  icon: Icons.add,
                  size: 40,
                  onPressed: () {},
                ),
                SantoFab(
                  icon: Icons.add,
                  size: 56,
                  onPressed: () {},
                ),
                SantoFab(
                  icon: Icons.add,
                  size: 72,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),

        // 扩展形按钮
        SantoSection(
          title: '扩展形按钮（带文字）',
          description: 'text 设置后自动变为扩展形，图标与文字水平排列',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('设置 text 属性后自动变为扩展形',
                  style: TextStyle(fontSize: 13, color: Colors.grey)),
              SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    SantoFab(
                      icon: Icons.add,
                      text: '新建项目',
                      onPressed: () {
                        _showSnackBar('点击了新建项目');
                      },
                    ),
                    SizedBox(height: 12),
                    SantoFab(
                      icon: Icons.edit,
                      text: '编辑',
                      backgroundColor: Color(0xFF52C41A),
                      onPressed: () {
                        _showSnackBar('点击了编辑');
                      },
                    ),
                    SizedBox(height: 12),
                    SantoFab(
                      icon: Icons.share,
                      text: '分享',
                      backgroundColor: Color(0xFFFAAD14),
                      onPressed: () {
                        _showSnackBar('点击了分享');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 自定义图标颜色
        SantoSection(
          title: '自定义图标颜色',
          description: 'iconColor 自定义图标颜色，配合白色 backgroundColor 使用',
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SantoFab(
                  icon: Icons.favorite,
                  backgroundColor: Colors.white,
                  iconColor: Color(0xFFFF4D4F),
                  onPressed: () {},
                ),
                SantoFab(
                  icon: Icons.star,
                  backgroundColor: Colors.white,
                  iconColor: Color(0xFFFAAD14),
                  onPressed: () {},
                ),
                SantoFab(
                  icon: Icons.thumb_up,
                  backgroundColor: Colors.white,
                  iconColor: Color(0xFF1677FF),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),

        // 计数器示例
        SantoSection(
          title: '计数器示例',
          description: '点击右下角 positioned 悬浮按钮，联动更新当前计数',
          child: Center(
            child: Text(
              '当前计数: $_counter',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
      ],
      // 右下角定位的悬浮按钮:叠在内容之上
      overlay: SantoFab.positioned(
          icon: Icons.add,
          text: '增加',
          onPressed: () {
            setState(() {
              _counter++;
            });
          },
          position: SantoFabPosition.bottomRight,
          edgeOffset: 24,
        ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
