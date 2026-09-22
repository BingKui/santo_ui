import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';

/// SantoActionBar 基础用法示例
class ActionBarBasicExample extends StatefulWidget {
  @override
  State<ActionBarBasicExample> createState() => _ActionBarBasicExampleState();
}

class _ActionBarBasicExampleState extends State<ActionBarBasicExample> {
  /// 示例背景色,用于在白色卡片上区分出操作栏区域
  static const Color _demoBackground = Color(0xFFF5F5F5);

  bool _loading = false;

  void _toast(String text) {
    SantoToast.show(text, context);
  }

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(      title: 'ActionBar 基础用法',
      children: <Widget>[
        ExampleIntro('action_bar'),
        SantoSection(
          title: '基础用法',
          description: 'children 混排图标与按钮，图标区靠左，按钮区靠右（默认尺寸，与栏右缘留 gapMd 间距）',
          child: SantoActionBar(
            backgroundColor: _demoBackground,
            children: [
              SantoActionBarIcon(
                icon: SantoIcons.headset,
                text: '客服',
                onTap: () => _toast('点击了客服'),
              ),
              SantoActionBarIcon(
                icon: SantoIcons.cart,
                text: '购物车',
                onTap: () => _toast('点击了购物车'),
              ),
              SantoActionBarButton(
                text: '立即购买',
                type: SantoActionBarButtonType.danger,
                onTap: () => _toast('点击了立即购买'),
              ),
            ],
          ),
        ),
        SantoSection(
          title: '图标角标',
          description: 'dot 展示红点，badgeCount 展示数字角标',
          child: SantoActionBar(
            backgroundColor: _demoBackground,
            children: [
              const SantoActionBarIcon(
                icon: SantoIcons.chatBubble,
                text: '消息',
                dot: true,
              ),
              const SantoActionBarIcon(
                icon: SantoIcons.cart,
                text: '购物车',
                badgeCount: 5,
              ),
              const SantoActionBarIcon(
                icon: SantoIcons.bellNotification,
                text: '通知',
                badgeCount: 12,
              ),
              SantoActionBarButton(
                text: '确定',
                type: SantoActionBarButtonType.primary,
                onTap: () => _toast('点击了确定'),
              ),
            ],
          ),
        ),
        SantoSection(
          title: '自定义图标颜色',
          description: 'color 控制图标颜色，图标文案跟随主题基础文字色',
          child: SantoActionBar(
            backgroundColor: _demoBackground,
            children: [
              const SantoActionBarIcon(
                icon: SantoIcons.star,
                text: '收藏',
                color: Color(0xFFFF5722),
              ),
              const SantoActionBarIcon(
                icon: SantoIcons.thumbsUp,
                text: '点赞',
                color: Color(0xFF52C41A),
              ),
              SantoActionBarButton(
                text: '分享',
                onTap: () => _toast('点击了分享'),
              ),
            ],
          ),
        ),
        SantoSection(
          title: '按钮类型',
          description: 'type 提供 normal、primary、success、warning、danger 五种类型',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SantoActionBar(
                backgroundColor: _demoBackground,
                children: [
                  SantoActionBarButton(text: '默认按钮'),
                  SantoActionBarButton(
                    text: '主要按钮',
                    type: SantoActionBarButtonType.primary,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SantoActionBar(
                backgroundColor: _demoBackground,
                children: [
                  SantoActionBarButton(
                    text: '成功按钮',
                    type: SantoActionBarButtonType.success,
                  ),
                  SantoActionBarButton(
                    text: '警告按钮',
                    type: SantoActionBarButtonType.warning,
                  ),
                  SantoActionBarButton(
                    text: '危险按钮',
                    type: SantoActionBarButtonType.danger,
                  ),
                ],
              ),
            ],
          ),
        ),
        SantoSection(
          title: '自定义按钮颜色',
          description: 'color 覆盖 type 的背景色，此时按钮文案为白色且无描边',
          child: SantoActionBar(
            backgroundColor: _demoBackground,
            children: [
              SantoActionBarButton(text: '加入购物车', color: const Color(0xFFBE99FF)),
              SantoActionBarButton(text: '立即购买', color: const Color(0xFF7232DD)),
            ],
          ),
        ),
        SantoSection(
          title: '禁用状态',
          description: 'disabled 降低透明度到 0.4 且不响应点击',
          child: SantoActionBar(
            backgroundColor: _demoBackground,
            children: [
              const SantoActionBarIcon(
                icon: SantoIcons.headset,
                text: '客服',
                disabled: true,
              ),
              SantoActionBarButton(
                text: '已下架',
                disabled: true,
                onTap: () => _toast('禁用按钮不应触发'),
              ),
              SantoActionBarButton(
                text: '立即购买',
                type: SantoActionBarButtonType.danger,
                onTap: () => _toast('点击了立即购买'),
              ),
            ],
          ),
        ),
        SantoSection(
          title: '加载状态',
          description: 'loading 展示进度指示且不响应点击，点击右侧按钮切换加载态',
          child: SantoActionBar(
            backgroundColor: _demoBackground,
            children: [
              SantoActionBarButton(
                text: '提交订单',
                type: SantoActionBarButtonType.primary,
                loading: _loading,
                onTap: () => _toast('提交订单'),
              ),
              SantoActionBarButton(
                text: _loading ? '结束加载' : '开始加载',
                onTap: () => setState(() => _loading = !_loading),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
