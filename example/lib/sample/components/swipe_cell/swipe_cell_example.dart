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
    return SantoPageLayout(      title: 'SwipeCell 示例',
      children: <Widget>[
        // 提示
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Text(
            '左滑或右滑列表项查看操作按钮',
            style: TextStyle(
              color: const Color(0xFF17233D).withAlpha(150),
              fontSize: 14,
            ),
          ),
        ),

        // 仅右侧操作
        SantoSection(
          title: '仅右侧操作',
          description: '只配置 right 面板，左滑露出删除按钮并触发点击回调',
          child: _buildSwipeCellWithRightOnly(),
        ),
        // 仅左侧操作
        SantoSection(
          title: '仅左侧操作',
          description: '只配置 left 面板，右滑露出置顶按钮并触发点击回调',
          child: _buildSwipeCellWithLeftOnly(),
        ),
        // 左右都有操作
        SantoSection(
          title: '左右都有操作',
          description: '同时传入 left 与 right，左右滑动分别展示不同操作按钮',
          child: _buildSwipeCellWithBoth(),
        ),
        // 列表中使用
        SantoSection(
          title: '列表中使用',
          description: '多个单元格纵向排列，用于列表场景中逐项滑动操作',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSwipeCellWithRightOnly(),
              _buildSwipeCellWithLeftOnly(),
            ],
          ),
        ),
        // 组内互斥 (groupTag)
        SantoSection(
          title: '组内互斥 (groupTag)',
          description: 'groupTag 相同的单元格互斥展开，打开一个会自动收起其他',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSwipeCellWithRightOnly(groupTag: 'demo'),
              _buildSwipeCellWithLeftOnly(groupTag: 'demo'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSwipeCellWithRightOnly({Object? groupTag}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SantoSwipeCell(
        groupTag: groupTag,
        right: SantoSwipeCellPanel(
          extentRatio: 0.3,
          actions: [
            SantoSwipeCellAction(
              label: '删除',
              backgroundColor: const Color(0xFFFF4D4F),
              onPressed: () {
                SantoToast.show('点击删除', context);
              },
            ),
          ],
        ),
        cell: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFDCDEE2)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            '左滑显示删除按钮',
            style: TextStyle(fontSize: 16, color: Color(0xFF17233D)),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeCellWithLeftOnly({Object? groupTag}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SantoSwipeCell(
        groupTag: groupTag,
        left: SantoSwipeCellPanel(
          extentRatio: 0.3,
          actions: [
            SantoSwipeCellAction(
              label: '置顶',
              backgroundColor: const Color(0xFF1677FF),
              onPressed: () {
                SantoToast.show('点击置顶', context);
              },
            ),
          ],
        ),
        cell: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFDCDEE2)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            '右滑显示置顶按钮',
            style: TextStyle(fontSize: 16, color: Color(0xFF17233D)),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeCellWithBoth({Object? groupTag}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SantoSwipeCell(
        groupTag: groupTag,
        left: SantoSwipeCellPanel(
          extentRatio: 0.3,
          actions: [
            SantoSwipeCellAction(
              label: '置顶',
              backgroundColor: const Color(0xFF1677FF),
              onPressed: () {
                SantoToast.show('点击置顶', context);
              },
            ),
          ],
        ),
        right: SantoSwipeCellPanel(
          extentRatio: 0.3,
          actions: [
            SantoSwipeCellAction(
              label: '编辑',
              backgroundColor: const Color(0xFFFAAD14),
              onPressed: () {
                SantoToast.show('点击编辑', context);
              },
            ),
            SantoSwipeCellAction(
              label: '删除',
              backgroundColor: const Color(0xFFFF4D4F),
              onPressed: () {
                SantoToast.show('点击删除', context);
              },
            ),
          ],
        ),
        cell: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFDCDEE2)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            '左右滑动显示操作按钮',
            style: TextStyle(fontSize: 16, color: Color(0xFF17233D)),
          ),
        ),
      ),
    );
  }
}
