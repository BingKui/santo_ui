import 'package:santo_ui/santo_ui.dart';
import 'package:flutter/material.dart';

/// 单元格组件示例
class CellExample extends StatefulWidget {
  @override
  _CellExampleState createState() => _CellExampleState();
}

class _CellExampleState extends State<CellExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SantoAppBar(title: 'Cell 示例'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 基本用法
            SantoPanel(
              title: '基本用法',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SantoCell(
                    title: '设置',
                    onTap: () {
                      SantoToast.show('点击了设置', context);
                    },
                  ),

                  SantoCell(
                    title: '关于我们',
                    bottomLine: false,
                    onTap: () {
                      SantoToast.show('点击了关于我们', context);
                    },
                  ),
                ],
              ),
            ),
            // 带描述
            SantoPanel(
              title: '带描述',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SantoCell(
                    title: '隐私设置',
                    description: '管理你的隐私和数据权限',
                    bottomLine: false,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            // 带左侧图标
            SantoPanel(
              title: '带左侧图标',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SantoCell(
                    title: '消息中心',
                    leftIcon: Icons.notifications,
                    note: '3条新消息',
                    onTap: () {},
                  ),

                  SantoCell(
                    title: '帮助中心',
                    leftIcon: Icons.help_outline,
                    bottomLine: false,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            // 带右侧备注
            SantoPanel(
              title: '带右侧备注',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SantoCell(
                    title: '版本号',
                    note: 'v2.0.1',
                    showArrow: false,
                    bottomLine: false,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            // 不显示箭头
            SantoPanel(
              title: '不显示箭头',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SantoCell(
                    title: '无箭头有备注',
                    showArrow: false,
                    note: '已开启',
                    bottomLine: false,
                  ),
                ],
              ),
            ),
            // 自定义右侧内容
            SantoPanel(
              title: '自定义右侧内容',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SantoCell(
                    title: '头像',
                    leftIcon: Icons.person,
                    rightWidget: SantoAvatar(
                      text: '张',
                      size: 36,
                      backgroundColor: Color(0xFF0984F9),
                    ),
                    bottomLine: false,
                  ),
                ],
              ),
            ),
            // CellGroup 组合
            SantoPanel(
              title: 'CellGroup 组合',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [SizedBox(height: 20)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
