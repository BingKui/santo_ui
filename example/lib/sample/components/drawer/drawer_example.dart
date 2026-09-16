import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// Drawer 抽屉示例
class DrawerExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(title: 'Drawer 示例'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SantoSection(
              title: '基础方向',
              description: 'direction 设为 left 或 right，从对应侧滑出抽屉面板',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SantoNormalButton(
                    onTap: () {
                      SantoDrawer.show(
                        context: context,
                        direction: SantoDrawerDirection.right,
                        child: _buildDrawerContent('右侧抽屉'),
                      );
                    },
                    text: '打开右侧抽屉',
                  ),
                  const SizedBox(height: 16),
                  SantoNormalButton(
                    onTap: () {
                      SantoDrawer.show(
                        context: context,
                        direction: SantoDrawerDirection.left,
                        child: _buildDrawerContent('左侧抽屉'),
                      );
                    },
                    text: '打开左侧抽屉',
                  ),
                ],
              ),
            ),
            SantoSection(
              title: '顶部 / 底部抽屉',
              description: 'direction 为 top 或 bottom 时，通过 height 指定抽屉高度',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SantoNormalButton(
                    onTap: () {
                      SantoDrawer.show(
                        context: context,
                        direction: SantoDrawerDirection.top,
                        height: 300,
                        child: _buildDrawerContent('顶部抽屉'),
                      );
                    },
                    text: '打开顶部抽屉 (height: 300)',
                  ),
                  const SizedBox(height: 16),
                  SantoNormalButton(
                    onTap: () {
                      SantoDrawer.show(
                        context: context,
                        direction: SantoDrawerDirection.bottom,
                        height: 400,
                        child: _buildDrawerContent('底部抽屉'),
                      );
                    },
                    text: '打开底部抽屉 (height: 400)',
                  ),
                ],
              ),
            ),
            SantoSection(
              title: '自定义宽度',
              description: 'width 分别设为 200 与 400，对比抽屉的宽窄表现',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SantoNormalButton(
                    onTap: () {
                      SantoDrawer.show(
                        context: context,
                        direction: SantoDrawerDirection.right,
                        width: 200,
                        child: _buildDrawerContent('宽度 200'),
                      );
                    },
                    text: '打开窄抽屉 (width: 200)',
                  ),
                  const SizedBox(height: 16),
                  SantoNormalButton(
                    onTap: () {
                      SantoDrawer.show(
                        context: context,
                        direction: SantoDrawerDirection.right,
                        width: 400,
                        child: _buildDrawerContent('宽度 400'),
                      );
                    },
                    text: '打开宽抽屉 (width: 400)',
                  ),
                ],
              ),
            ),
            SantoSection(
              title: '自定义遮罩',
              description: 'maskColor 传入半透明黑色，调整遮罩层的深浅',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SantoNormalButton(
                    onTap: () {
                      SantoDrawer.show(
                        context: context,
                        direction: SantoDrawerDirection.right,
                        maskColor: Colors.black.withAlpha(0x33),
                        child: _buildDrawerContent('浅色遮罩'),
                      );
                    },
                    text: '打开抽屉（浅色遮罩）',
                  ),
                ],
              ),
            ),
            SantoSection(
              title: '筛选面板场景',
              description: '底部弹出 420 高度的抽屉，内部为筛选表单的组合场景',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SantoNormalButton(
                    onTap: () {
                      SantoDrawer.show(
                        context: context,
                        direction: SantoDrawerDirection.bottom,
                        height: 420,
                        child: _buildFilterContent(context),
                      );
                    },
                    text: '打开筛选面板（底部弹出）',
                  ),
                ],
              ),
            ),
            SantoSection(
              title: '底部 Drawer (SantoBottomDrawer)',
              description: 'SantoBottomDrawer 演示对齐方式、固定高度、关闭按钮与遮罩行为',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SantoNormalButton(
                    onTap: () {
                      SantoBottomDrawer.show(
                        context: context,
                        title: '标题左对齐',
                        desc: '这是描述文案,标题和描述默认左对齐',
                        child: const Text('底部 Drawer 内容'),
                      );
                    },
                    text: '标题+描述(左对齐,自适应高度)',
                  ),
                  const SizedBox(height: 16),
                  SantoNormalButton(
                    onTap: () {
                      SantoBottomDrawer.show(
                        context: context,
                        title: '标题居中',
                        desc: '标题和描述居中显示',
                        titleAlign: SantoBottomDrawerTitleAlign.center,
                        height: 300,
                        child: const Center(child: Text('固定高度 300')),
                      );
                    },
                    text: '标题+描述(居中,固定高度)',
                  ),
                  const SizedBox(height: 16),
                  SantoNormalButton(
                    onTap: () {
                      SantoBottomDrawer.show(
                        context: context,
                        title: '无关闭按钮',
                        desc: 'showCloseButton: false',
                        showCloseButton: false,
                        child: const Text('只能通过遮罩或内容区操作关闭'),
                      );
                    },
                    text: '隐藏右侧关闭按钮',
                  ),
                  const SizedBox(height: 16),
                  SantoNormalButton(
                    onTap: () {
                      SantoBottomDrawer.show(
                        context: context,
                        title: '点击遮罩不关闭',
                        desc: 'barrierDismissible: false',
                        barrierDismissible: false,
                        child: SantoNormalButton(
                          onTap: () => Navigator.of(context).pop(),
                          text: '点我关闭',
                        ),
                      );
                    },
                    text: '点击遮罩不关闭',
                  ),
                  const SizedBox(height: 16),
                  SantoNormalButton(
                    onTap: () {
                      SantoBottomDrawer.show(
                        context: context,
                        title: '长内容滚动',
                        desc: '内容超过最大高度(屏幕 85%)时请使用可滚动控件',
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: 30,
                          itemBuilder: (context, index) =>
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8),
                                child: Text('列表项 ${index + 1}'),
                              ),
                        ),
                      );
                    },
                    text: '长内容 + 底部安全区域',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建抽屉内容
  Widget _buildDrawerContent(String title) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              children: List.generate(
                10,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Icon(Icons.circle, size: 8, color: Colors.grey[400]),
                      const SizedBox(width: 12),
                      Text('列表项 ${index + 1}', style: TextStyle(fontSize: 15)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建筛选面板内容
  Widget _buildFilterContent(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              children: [
                Text(
                  '筛选条件',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(Icons.close, size: 22),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('状态', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['全部', '进行中', '已完成', '已取消'].map((e) {
                      return ChoiceChip(
                        label: Text(e),
                        selected: e == '全部',
                        onSelected: (selected) {},
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  Text('类型', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['全部', '类型A', '类型B', '类型C'].map((e) {
                      return ChoiceChip(
                        label: Text(e),
                        selected: e == '全部',
                        onSelected: (selected) {},
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 1),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: SantoNormalButton.outline(
                    onTap: () => Navigator.of(context).pop(),
                    text: '重置',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SantoNormalButton(
                    onTap: () {
                      Navigator.of(context).pop();
                      SantoToast.show('应用筛选', context);
                    },
                    text: '确定',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
