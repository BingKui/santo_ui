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
    return SantoPageLayout(      title: 'Cell 示例',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 基本用法
          SantoSection(
            title: '基本用法',
            description: 'onTap 触发点击回调，bottomLine 控制末项是否保留分割线',
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
          SantoSection(
            title: '带描述',
            description: 'description 在标题下方展示补充说明，字号更小颜色更浅',
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
          SantoSection(
            title: '带左侧图标',
            description: 'leftIcon 设置左侧图标，note 在右侧展示备注信息',
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
          SantoSection(
            title: '带右侧备注',
            description: 'note 展示版本号等右侧备注，数值类信息无需箭头引导',
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
          SantoSection(
            title: '不显示箭头',
            description: 'showArrow 设为 false 隐藏右箭头，仅保留 note 文字',
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
          SantoSection(
            title: '自定义右侧内容',
            description: 'rightWidget 传入 SantoAvatar，替换箭头位置展示头像',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SantoCell(
                  title: '头像',
                  leftIcon: Icons.person,
                  rightWidget: SantoAvatar(
                    text: '张',
                    size: 36,
                    backgroundColor: Color(0xFF1677FF),
                  ),
                  bottomLine: false,
                ),
              ],
            ),
          ),
          // CellGroup 组合
          SantoSection(
            title: 'CellGroup 组合',
            description: 'SantoCellGroup 组合多个 SantoCell，统一管理分割线并支持分组标题',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SantoCellGroup(
                  title: '账号设置',
                  children: [
                    SantoCell(
                      title: '个人信息',
                      description: '查看和编辑个人资料',
                      leftIcon: Icons.person,
                      onTap: () {
                        SantoToast.show('点击了个人信息', context);
                      },
                    ),
                    SantoCell(
                      title: '通知设置',
                      leftIcon: Icons.notifications,
                      note: '已开启',
                      onTap: () {
                        SantoToast.show('点击了通知设置', context);
                      },
                    ),
                    SantoCell(
                      title: '隐私',
                      leftIcon: Icons.lock_outline,
                      bottomLine: false,
                      onTap: () {
                        SantoToast.show('点击了隐私', context);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),
                SantoCellGroup(
                  children: [
                    SantoCell(
                      title: '清除缓存',
                      note: '23.5MB',
                      onTap: () {
                        SantoToast.show('点击了清除缓存', context);
                      },
                    ),
                    SantoCell(
                      title: '退出登录',
                      showArrow: false,
                      bottomLine: false,
                      onTap: () {
                        SantoToast.show('点击了退出登录', context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
