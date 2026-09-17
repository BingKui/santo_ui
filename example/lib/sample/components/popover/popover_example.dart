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
    return SantoPageLayout(      title: 'Popover 气泡弹出框示例',
      children: <Widget>[
        // 场景1：向下弹出
        SantoSection(
          title: '向下弹出 (bottom)',
          description: 'direction 设为 bottom，气泡从触发元素下方弹出',
          child: SantoNormalButton(
            key: _bottomKey,
            onTap: () {
              SantoPopover.show(
                context: context,
                target: _bottomKey,
                direction: SantoPopoverDirection.bottom,
                content: Text(
                  '这是一个向下弹出的气泡',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              );
            },
            text: '向下弹出',
          ),
        ),

        // 场景2：向上弹出
        SantoSection(
          title: '向上弹出 (top)',
          description: 'direction 设为 top，气泡从触发元素上方弹出',
          child: SantoNormalButton(
            key: _topKey,
            onTap: () {
              SantoPopover.show(
                context: context,
                target: _topKey,
                direction: SantoPopoverDirection.top,
                content: Text(
                  '这是一个向上弹出的气泡',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              );
            },
            text: '向上弹出',
          ),
        ),

        // 场景3：向左弹出
        SantoSection(
          title: '向左/右弹出',
          description: 'direction 传 left 或 right，气泡从按钮左右两侧展开',
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
                    content: Text(
                      '向左弹出',
                      style:
                          TextStyle(color: Colors.white, fontSize: 14),
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
                    content: Text(
                      '向右弹出',
                      style:
                          TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  );
                },
                text: '向右',
              ),
            ],
          ),
        ),

        // 场景4：不显示箭头
        SantoSection(
          title: '不显示箭头',
          description: 'showArrow 传 false，气泡与触发元素间不绘制指示三角',
          child: SantoNormalButton(
            key: _noArrowKey,
            onTap: () {
              SantoPopover.show(
                context: context,
                target: _noArrowKey,
                direction: SantoPopoverDirection.bottom,
                showArrow: false,
                content: Text(
                  '没有箭头的气泡框',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              );
            },
            text: '不显示箭头',
          ),
        ),

        // 场景5：自定义背景色
        SantoSection(
          title: '自定义背景色',
          description: 'backgroundColor 传入自定义色值，替换气泡默认深色背景',
          child: SantoNormalButton(
            key: _customKey,
            onTap: () {
              SantoPopover.show(
                context: context,
                target: _customKey,
                direction: SantoPopoverDirection.bottom,
                backgroundColor: Color(0xFF1677FF),
                content: Text(
                  '蓝色背景的气泡',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              );
            },
            text: '自定义背景色',
          ),
        ),

        // 场景6：富文本内容
        SantoSection(
          title: '富文本内容',
          description: 'content 可传 Column 与 Row，在气泡内自定义多行分享面板',
          child: SantoNormalButton(
            key: _richKey,
            onTap: () {
              SantoPopover.show(
                context: context,
                target: _richKey,
                direction: SantoPopoverDirection.bottom,
                content: Column(
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
              );
            },
            text: '富文本内容',
          ),
        ),

        SizedBox(height: 40),
      ],
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
