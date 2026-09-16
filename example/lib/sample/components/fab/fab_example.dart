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
    return Scaffold(
      appBar: SantoAppBar(title: 'Fab 悬浮按钮示例'),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 基础用法
                SantoPanel(
                  title: '基础用法',
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
                              backgroundColor: Color(0xFF00AE66),
                              onPressed: () {
                                _showSnackBar('点击了绿色按钮');
                              },
                            ),
                            // 红色
                            SantoFab(
                              icon: Icons.close,
                              backgroundColor: Color(0xFFFA3F3F),
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
                SantoPanel(
                  title: '不同大小',
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
                SantoPanel(
                  title: '扩展形按钮（带文字）',
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
                              backgroundColor: Color(0xFF00AE66),
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
                SantoPanel(
                  title: '自定义图标颜色',
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SantoFab(
                          icon: Icons.favorite,
                          backgroundColor: Colors.white,
                          iconColor: Color(0xFFFA3F3F),
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
                          iconColor: Color(0xFF0984F9),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),

                // 计数器示例
                SantoPanel(
                  title: '计数器示例',
                  child: Center(
                    child: Text(
                      '当前计数: $_counter',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                SizedBox(height: 80),
              ],
            ),
          ),

          // 右下角定位的悬浮按钮
          SantoFab.positioned(
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
        ],
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
