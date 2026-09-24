import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';

/// Drawer 抽屉示例
class DrawerExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: 'Drawer 示例',
      children: <Widget>[
        ExampleIntro('drawer'),
        SantoSection(
          title: '基础方向',
          description: 'direction 设为 left 或 right，从对应侧滑出抽屉面板',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoButton(
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
              SantoButton(
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
          description: 'direction 为 top 或 bottom 时，通过 height 指定抽屉高度；内容为 ListView 时安全区由列表自动消费',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoButton(
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
              SantoButton(
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
          description: 'width 分别设为 200 与 400；宽度上限为屏幕的 95%，超出自动收敛',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoButton(
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
              SantoButton(
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
              SantoButton(
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
          description: '底部弹出 420 高度的抽屉；固定底部的按钮行把安全区算进自身 padding，停在手势条之上',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoButton(
                onTap: () {
                  SantoDrawer.show(
                    context: context,
                    direction: SantoDrawerDirection.bottom,
                    height: 420,
                    // Builder 让内容在抽屉子树内取到改写后的安全区
                    child: Builder(
                      builder: (context) => _buildFilterContent(context),
                    ),
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
              SantoButton(
                onTap: () {
                  SantoBottomDrawer.show(
                    context: context,
                    title: '标题左对齐',
                    desc: '这是描述文案,标题和描述默认左对齐',
                    // 静态内容不消费 MediaQuery,需在抽屉子树内读取
                    // 改写后的安全区,算进自身 padding
                    child: Builder(
                      builder: (context) => Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom,
                        ),
                        child: const Text('底部 Drawer 内容'),
                      ),
                    ),
                  );
                },
                text: '标题+描述(左对齐,自适应高度)',
              ),
              const SizedBox(height: 16),
              SantoButton(
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
              SantoButton(
                onTap: () {
                  SantoBottomDrawer.show(
                    context: context,
                    title: '无关闭按钮',
                    desc: 'showCloseButton: false',
                    showCloseButton: false,
                    // 静态内容不消费 MediaQuery,需在抽屉子树内读取
                    // 改写后的安全区,算进自身 padding
                    child: Builder(
                      builder: (context) => Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom,
                        ),
                        child: const Text('只能通过遮罩或内容区操作关闭'),
                      ),
                    ),
                  );
                },
                text: '隐藏右侧关闭按钮',
              ),
              const SizedBox(height: 16),
              SantoButton(
                onTap: () {
                  SantoBottomDrawer.show(
                    context: context,
                    title: '点击遮罩不关闭',
                    desc: 'barrierDismissible: false',
                    barrierDismissible: false,
                    child: Builder(
                      builder: (context) => Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom,
                        ),
                        child: SantoButton(
                          onTap: () => Navigator.of(context).pop(),
                          text: '点我关闭',
                        ),
                      ),
                    ),
                  );
                },
                text: '点击遮罩不关闭',
              ),
              const SizedBox(height: 16),
              SantoButton(
                onTap: () {
                  SantoBottomDrawer.show(
                    context: context,
                    title: '长内容滚动',
                    desc: '内容使用 ListView,底部安全区由 MediaQuery 传递给 ListView 自动避让',
                    child: ListView.separated(
                      itemCount: 30,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text('列表项 ${index + 1}'),
                        );
                      },
                    ),
                  );
                },
                text: '长内容自动滚动(30 项)',
              ),
              const SizedBox(height: 16),
              SantoButton(
                onTap: () {
                  SantoBottomDrawer.show(
                    context: context,
                    title: '内容充满整个抽屉',
                    desc: '设置 height 后内容区通过 Expanded 撑满,子控件可自由使用 Expanded/Flexible',
                    height: 500,
                    contentPadding: EdgeInsets.zero,
                    child: Builder(
                      builder: (context) => Container(
                        color: const Color(0xFFF5F6FA),
                        child: ListView.builder(
                          // 显式 padding 会覆盖 MediaQuery 安全区,
                          // 底部用安全区兜底
                          padding: EdgeInsets.only(
                            left: 20,
                            top: 12,
                            right: 20,
                            bottom: MediaQuery.of(context).padding.bottom + 12,
                          ),
                          itemCount: 20,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Color(0xFF1677FF)
                                        .withOpacity(0.1),
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        color: Color(0xFF1677FF),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '标题项 ${index + 1}',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '这是第 ${index + 1} 行的描述文案',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF808695),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: Color(0xFFC0C4CC),
                                    size: 20,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
                text: '内容充满整个抽屉(height: 500)',
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 构建抽屉内容
  ///
  /// 内容直接是 ListView 且不传 padding:抽屉改写后的安全区由列表自动
  /// 消费为滚动内边距,滚动区铺满整个抽屉,滚到底时最后一项停在安全区
  /// 之上,不在内容外额外加一块空白区域
  Widget _buildDrawerContent(String title) {
    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          for (int i = 1; i <= 10; i++)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Row(
                children: [
                  Icon(Icons.circle, size: 8, color: Colors.grey[400]),
                  const SizedBox(width: 12),
                  Text('列表项 $i', style: TextStyle(fontSize: 15)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// 构建筛选面板内容
  ///
  /// 固定的底部按钮行读取抽屉改写后的 MediaQuery 安全区,把安全区算进
  /// 自身 padding 停在手势条之上;背景仍铺满整个抽屉
  Widget _buildFilterContent(BuildContext context) {
    final double safeBottom = MediaQuery.of(context).padding.bottom;
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
                  SantoTag(
                    selectable: true,
                    tags: const ['全部', '进行中', '已完成', '已取消'],
                    initTagState: const [true],
                    fixWidthMode: false,
                    spacing: 8,
                    verticalSpacing: 8,
                  ),
                  const SizedBox(height: 24),
                  Text('类型', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  SantoTag(
                    selectable: true,
                    tags: const ['全部', '类型A', '类型B', '类型C'],
                    initTagState: const [true],
                    fixWidthMode: false,
                    spacing: 8,
                    verticalSpacing: 8,
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 1),
          Container(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + safeBottom),
            child: Row(
              children: [
                Expanded(
                  child: SantoButton(
                    type: SantoButtonType.normal,
                    onTap: () => Navigator.of(context).pop(),
                    text: '重置',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SantoButton(
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
