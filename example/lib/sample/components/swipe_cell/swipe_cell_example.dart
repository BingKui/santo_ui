import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// 滑动单元格示例页面
class SwipeCellExample extends StatefulWidget {
  const SwipeCellExample({Key? key}) : super(key: key);

  @override
  _SwipeCellExampleState createState() => _SwipeCellExampleState();
}

class _SwipeCellExampleState extends State<SwipeCellExample> {
  final List<String> _items = List.generate(10, (index) => '列表项 $index');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(title: 'SwipeCell 示例'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 提示
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text(
              '左滑或右滑列表项查看操作按钮',
              style: TextStyle(
                color: const Color(0xFF222222).withAlpha(150),
                fontSize: 14,
              ),
            ),
          ),

          // 仅右侧操作
          SantoPanel(title: '仅右侧操作', child: _buildSwipeCellWithRightOnly()),
          // 仅左侧操作
          SantoPanel(title: '仅左侧操作', child: _buildSwipeCellWithLeftOnly()),
          // 左右都有操作
          SantoPanel(title: '左右都有操作', child: _buildSwipeCellWithBoth()),
          // 列表中使用
          SantoPanel(
            title: '列表中使用',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSwipeCellWithRightOnly(),
                _buildSwipeCellWithLeftOnly(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeCellWithRightOnly() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SantoSwipeCell(
        rightActions: [
          _buildActionButton(
            color: const Color(0xFFFA3F3F),
            label: '删除',
            onTap: () {
              SantoToast.show('点击删除', context);
            },
          ),
        ],
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFEEEEEE)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            '左滑显示删除按钮',
            style: TextStyle(fontSize: 16, color: Color(0xFF222222)),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeCellWithLeftOnly() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SantoSwipeCell(
        leftActions: [
          _buildActionButton(
            color: const Color(0xFF0984F9),
            label: '置顶',
            onTap: () {
              SantoToast.show('点击置顶', context);
            },
          ),
        ],
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFEEEEEE)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            '右滑显示置顶按钮',
            style: TextStyle(fontSize: 16, color: Color(0xFF222222)),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeCellWithBoth() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SantoSwipeCell(
        leftActions: [
          _buildActionButton(
            color: const Color(0xFF0984F9),
            label: '置顶',
            onTap: () {
              SantoToast.show('点击置顶', context);
            },
          ),
        ],
        rightActions: [
          _buildActionButton(
            color: const Color(0xFFFAAD14),
            label: '编辑',
            onTap: () {
              SantoToast.show('点击编辑', context);
            },
          ),
          _buildActionButton(
            color: const Color(0xFFFA3F3F),
            label: '删除',
            onTap: () {
              SantoToast.show('点击删除', context);
            },
          ),
        ],
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFEEEEEE)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            '左右滑动显示操作按钮',
            style: TextStyle(fontSize: 16, color: Color(0xFF222222)),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        color: color,
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
