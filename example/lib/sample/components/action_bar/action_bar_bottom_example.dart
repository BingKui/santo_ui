import 'package:santo_ui/santo_ui.dart';
import 'package:example/sample/home/example_intro.dart';
import 'package:flutter/material.dart';

/// ActionBar 吸底用法示例
///
/// 操作栏作为 [Scaffold.bottomNavigationBar] 使用,固定在页面底部不随内容滚动。
class ActionBarBottomExample extends StatelessWidget {
  const ActionBarBottomExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      backgroundColor: const Color(0xFFF5F6FA),
      title: 'ActionBar · 吸底用法',
      children: <Widget>[
        ExampleIntro('action_bar'),
        for (int i = 1; i <= 10; i++)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '内容卡片 $i',
              style: const TextStyle(fontSize: 14),
            ),
          ),
      ],
      bottomNavigationBar: SantoActionBar(
        children: [
          SantoActionBarIcon(
            icon: const Icon(Icons.headset_mic),
            text: '客服',
            onTap: () => SantoToast.show('点击了客服', context),
          ),
          SantoActionBarIcon(
            icon: const Icon(Icons.shopping_cart),
            text: '购物车',
            badgeCount: 2,
            onTap: () => SantoToast.show('点击了购物车', context),
          ),
          SantoActionBarIcon(
            icon: const Icon(Icons.star),
            text: '收藏',
            onTap: () => SantoToast.show('点击了收藏', context),
          ),
          SantoActionBarButton(
            text: '加入购物车',
            type: SantoActionBarButtonType.warning,
            onTap: () => SantoToast.show('点击了加入购物车', context),
          ),
          SantoActionBarButton(
            text: '立即购买',
            type: SantoActionBarButtonType.danger,
            onTap: () => SantoToast.show('点击了立即购买', context),
          ),
        ],
      ),
    );
  }
}
