import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/rule_panel.dart';
import 'package:flutter/material.dart';

/// SantoMoreMenu 更多菜单示例
class MoreMenuExample extends StatelessWidget {
  List<SantoMoreMenuItem> _items(BuildContext context) => [
        SantoMoreMenuItem(
          label: '文档',
          icon: Icons.description_outlined,
          onTap: () => SantoToast.show('点击了文档', context),
        ),
        SantoMoreMenuItem(
          label: '会议',
          icon: Icons.videocam_outlined,
          onTap: () => SantoToast.show('点击了会议', context),
        ),
        SantoMoreMenuItem(
          label: '邮箱',
          icon: Icons.mail_outline,
          onTap: () => SantoToast.show('点击了邮箱', context),
        ),
        SantoMoreMenuItem(
          label: 'AI 表格',
          icon: Icons.grid_view_outlined,
          onTap: () => SantoToast.show('点击了 AI 表格', context),
        ),
        SantoMoreMenuItem(
          label: 'AI 听记',
          icon: Icons.mic_none,
          onTap: () => SantoToast.show('点击了 AI 听记', context),
        ),
        SantoMoreMenuItem(
          label: 'DING',
          icon: Icons.bolt_outlined,
          onTap: () => SantoToast.show('点击了 DING', context),
        ),
        SantoMoreMenuItem(
          label: '应用市场',
          icon: Icons.apps_outlined,
          onTap: () => SantoToast.show('点击了应用市场', context),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SantoAppBar(title: 'MoreMenu 更多菜单'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const RulePanel(
              '更多菜单用于收纳低频入口:底部弹出大圆角面板,标题栏支持右上角操作,'
              '菜单项以图标宫格展示,默认 4 列。',
              maxLines: 3,
            ),
            SantoSection(
              title: '基础用法',
              description: 'SantoMoreMenu.show 弹出菜单，title 与 actionText 配置标题栏',
              child: SizedBox(
                width: double.infinity,
                child: SantoNormalButton(
                  text: '弹出更多菜单',
                  onTap: () {
                    SantoMoreMenu.show(
                      context,
                      title: '更多',
                      actionText: '编辑',
                      onActionTap: () => SantoToast.show('点击了编辑', context),
                      items: _items(context),
                    );
                  },
                ),
              ),
            ),
            SantoSection(
              title: '自定义列数与圆角',
              description: 'columns 指定宫格列数，radius 自定义面板圆角',
              child: SizedBox(
                width: double.infinity,
                child: SantoNormalButton(
                  text: '3 列 / 圆角 16 / 无标题',
                  onTap: () {
                    SantoMoreMenu.show(
                      context,
                      columns: 3,
                      radius: 16,
                      items: _items(context).sublist(0, 6),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
