import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// 气泡弹出框示例
class PopoverExample extends StatefulWidget {
  @override
  _PopoverExampleState createState() => _PopoverExampleState();
}

class _PopoverExampleState extends State<PopoverExample> {
  final GlobalKey _topKey = GlobalKey();
  final GlobalKey _bottomKey = GlobalKey();
  final GlobalKey _leftKey = GlobalKey();
  final GlobalKey _rightKey = GlobalKey();
  final GlobalKey _customKey = GlobalKey();
  final GlobalKey _noArrowKey = GlobalKey();
  final GlobalKey _richKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(title: 'Popover 气泡弹出框示例'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 场景1：向下弹出
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '向下弹出 (bottom)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SantoNormalButton(
                key: _bottomKey,
                onTap: () {
                  SantoPopover.show(
                    context: context,
                    target: _bottomKey,
                    direction: SantoPopoverDirection.bottom,
                    content: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Text(
                        '这是一个向下弹出的气泡',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  );
                },
                text: '向下弹出',
              ),
            ),

            SizedBox(height: 24),

            // 场景2：向上弹出
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '向上弹出 (top)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SantoNormalButton(
                key: _topKey,
                onTap: () {
                  SantoPopover.show(
                    context: context,
                    target: _topKey,
                    direction: SantoPopoverDirection.top,
                    content: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Text(
                        '这是一个向上弹出的气泡',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  );
                },
                text: '向上弹出',
              ),
            ),

            SizedBox(height: 24),

            // 场景3：向左弹出
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '向左/右弹出',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SantoNormalButton(
                    key: _leftKey,
                    onTap: () {
                      SantoPopover.show(
                        context: context,
                        target: _leftKey,
                        direction: SantoPopoverDirection.left,
                        content: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Text(
                            '向左弹出',
                            style:
                                TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      );
                    },
                    text: '向左',
                  ),
                  SantoNormalButton(
                    key: _rightKey,
                    onTap: () {
                      SantoPopover.show(
                        context: context,
                        target: _rightKey,
                        direction: SantoPopoverDirection.right,
                        content: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Text(
                            '向右弹出',
                            style:
                                TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      );
                    },
                    text: '向右',
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // 场景4：不显示箭头
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '不显示箭头',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SantoNormalButton(
                key: _noArrowKey,
                onTap: () {
                  SantoPopover.show(
                    context: context,
                    target: _noArrowKey,
                    direction: SantoPopoverDirection.bottom,
                    showArrow: false,
                    content: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Text(
                        '没有箭头的气泡框',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  );
                },
                text: '不显示箭头',
              ),
            ),

            SizedBox(height: 24),

            // 场景5：自定义背景色
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '自定义背景色',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SantoNormalButton(
                key: _customKey,
                onTap: () {
                  SantoPopover.show(
                    context: context,
                    target: _customKey,
                    direction: SantoPopoverDirection.bottom,
                    backgroundColor: Color(0xFF0984F9),
                    content: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Text(
                        '蓝色背景的气泡',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  );
                },
                text: '自定义背景色',
              ),
            ),

            SizedBox(height: 24),

            // 场景6：富文本内容
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '富文本内容',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SantoNormalButton(
                key: _richKey,
                onTap: () {
                  SantoPopover.show(
                    context: context,
                    target: _richKey,
                    direction: SantoPopoverDirection.bottom,
                    content: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.share, color: Colors.white, size: 16),
                              SizedBox(width: 8),
                              Text(
                                '分享到',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildShareIcon('微信', Color(0xFF07C160)),
                              SizedBox(width: 12),
                              _buildShareIcon('朋友圈', Color(0xFF07C160)),
                              SizedBox(width: 12),
                              _buildShareIcon('QQ', Color(0xFF12B7F5)),
                              SizedBox(width: 12),
                              _buildShareIcon('微博', Color(0xFFE6162D)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                text: '富文本内容',
              ),
            ),

            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /// 构建分享图标
  Widget _buildShareIcon(String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label[0],
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 10),
        ),
      ],
    );
  }
}
